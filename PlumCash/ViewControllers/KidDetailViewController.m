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

@interface KidDetailViewController () <CardIOPaymentViewControllerDelegate>
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
    
    // @TODO: load cards
    [self updateUI];
}

- (void)updateUI {
    self.title = self.kid.name; // doesn't work
    self.name.text = self.kid.name;
    [self.image setImageWithURL:self.kid.profileImageUrl placeholderImage:nil];
    self.pointsBar.progress = self.kid.pointsGoal > 0 ? self.kid.points / self.kid.pointsGoal : 0;
    self.pointsBarLabel.text = [NSString stringWithFormat:@"%.0f / %.0f points", ceil(self.kid.points), ceil(self.kid.pointsGoal)];
    self.spentLabel.text = [NSString stringWithFormat:@"%.0f spent of %.0f dollars", ceil(self.kid.spent), ceil(self.kid.allowance)];
}

- (IBAction)addCardPressed:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.hideCardIOLogo = YES;
    scanViewController.collectCVV = NO;
    scanViewController.collectCardholderName = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
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
    self.currentCardDigits.text = info.redactedCardNumber;
    
    [APIClient createCard:card success:^(Card *card) {
        //
        [scanViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        // oh no!
        [scanViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
