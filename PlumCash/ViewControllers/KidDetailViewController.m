//
//  KidDetailViewController.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "KidDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CardIO.h"
#import "APIClient.h"
#import "Card.h"
#import "NSObject+ProgressHUD.h"
#import "UIViewController+Alert.h"
#import "TransactionsViewController.h"
#import "TransactionTableViewCell.h"
#import "CategoriesTableViewController.h"

@interface KidDetailViewController () <CardIOPaymentViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *outerImage;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *spentLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *spentBarProgress;
@property (strong, nonatomic) IBOutlet UILabel *pointsBarLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *allowanceProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *pointsBar;

// buttons
@property (strong, nonatomic) IBOutlet UIButton *editCard;
@property (strong, nonatomic) IBOutlet UIButton *rewardButton;
@property (strong, nonatomic) IBOutlet UITextField *rewardContent;
@property (strong, nonatomic) IBOutlet UIButton *allowanceButton;
@property (strong, nonatomic) IBOutlet UITextField *allowanceAmount;
@property (strong, nonatomic) IBOutlet UILabel *currentCardDigits;
@property (strong, nonatomic) IBOutlet UIButton *editCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *viewTransactionsButton;


- (IBAction)backgroundTapped:(id)sender;

@end

@implementation KidDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//	[self setKid:[Kid mockKid]];
    [self updateUI];
    // Do any additional setup after loading the view.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self updateUI];
}

- (void)setKid:(Kid *)kid {
	_kid = kid;
    
    [APIClient getCardsForKid:self.kid success:^(NSArray<Card *> *cards) {
        [self updateUI];
    } failure:nil];
    
    [self updateUI];
}

- (void)updateUI {
    self.title = self.kid.name; // doesn't work
    self.name.text = self.kid.name;
    [self.image setImageWithURL:self.kid.profileImageUrl placeholderImage:nil];
    self.pointsBar.progress = self.kid.pointsGoal > 0 ? self.kid.points / self.kid.pointsGoal : 0;
    self.pointsBarLabel.text = [NSString stringWithFormat:@"%.0f / %.0f points", ceil(self.kid.points), ceil(self.kid.pointsGoal)];
	self.spentBarProgress.progress = ceil(self.kid.spent.floatValue) / ceil(self.kid.allowance.floatValue);
    self.spentLabel.text = [NSString stringWithFormat:@"%.0f / %.0f $", ceil(self.kid.spent.floatValue), ceil(self.kid.allowance.floatValue)];
    
    self.image.layer.cornerRadius = _image.bounds.size.width/2;
    self.image.layer.masksToBounds = YES;
    self.outerImage.layer.cornerRadius = _outerImage.bounds.size.width/2;
    self.outerImage.layer.masksToBounds = YES;
    self.outerImage.backgroundColor = [UIColor orangeColor];
    
    if (self.kid.cards.count) {
        NSString *number = self.kid.cards[self.kid.cards.count-1].number;
        self.currentCardDigits.text = [NSString stringWithFormat:@"ending in **%@", [number substringFromIndex:12]];
        self.viewTransactionsButton.hidden = NO;
    } else {
        self.viewTransactionsButton.hidden = YES;
    }
}

- (IBAction)addCardPressed:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.hideCardIOLogo = YES;
    scanViewController.collectCVV = NO;
    scanViewController.collectCardholderName = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (IBAction)sendAllowancePressed:(id)sender {
    NSNumber *amount = [NSNumber numberWithFloat:self.allowanceAmount.text.floatValue];
    
    if ([User currentUser].cards.count == 0) {
        [self showMessage:@"Please add your card to send money from first." withType:MessageTypeError];
        return;
    }
    if (self.kid.cards.count == 0) {
        [self showMessage:[NSString stringWithFormat:@"Please add a card for %@ to receive money on.", self.kid.name] withType:MessageTypeError];
        return;
    }
    
    [APIClient transferAmount:amount fromCard:[User currentUser].cards[0] toCard:self.kid.cards[0] success:^(BOOL successfully) {
        [self showHudWithTitle:@"Transfer successful!"];
        self.kid.allowance = [NSNumber numberWithFloat:(self.kid.allowance.floatValue + amount.floatValue)];
        self.kid.cards[0].allowance = [NSNumber numberWithFloat:(self.kid.cards[0].allowance.floatValue + amount.floatValue)];
        [self updateUI];
     } failure:nil];
}


#pragma mark - card.io Delegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // Use the card info...
    Card *card = [Card new];
    card.ownerType = @"kid";
    card.ownerId = self.kid.kidId;
    card.nameOnCard = info.cardholderName;
    card.number = info.cardNumber;
    card.expirationDate = [NSString stringWithFormat:@"%lu-%02lu-01", (unsigned long)info.expiryYear, (unsigned long)info.expiryMonth];
    [self.kid.cards addObject:card];
    
    [self updateUI];
    
    [APIClient createCard:card success:^(Card *card) {
        //
        [scanViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        // oh no!
        [scanViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TransactionsViewController class]]) {
        TransactionsViewController *controller = segue.destinationViewController;
        controller.card = self.kid.cards[0];
    } else if ([segue.destinationViewController isKindOfClass:[CategoriesTableViewController class]]) {
        CategoriesTableViewController *controller = segue.destinationViewController;
        controller.card = self.kid.cards[0];
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [self.allowanceAmount resignFirstResponder];
}

@end
