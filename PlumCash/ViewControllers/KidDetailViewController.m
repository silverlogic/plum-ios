//
//  KidDetailViewController.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "KidDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface KidDetailViewController ()
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
	
    [self updateUI];
}

- (void)updateUI {
    self.title = self.kid.name; // doesn't work
    self.name.text = self.kid.name;
    [self.image setImageWithURL:self.kid.profileImageUrl placeholderImage:nil];
    self.pointsBar.progress = self.kid.pointsGoal > 0 ? self.kid.points / self.kid.pointsGoal : 0;
    self.pointsBarLabel.text = [NSString stringWithFormat:@"%.0f / %.0f points", ceil(self.kid.points), ceil(self.kid.pointsGoal)];
    self.spentLabel.text = [NSString stringWithFormat:@"%.0f spent of %.0f dollars", ceil(self.kid.spent), ceil(self.kid.allowance)];
	self.image.layer.cornerRadius = _image.bounds.size.width/2;
	self.image.layer.masksToBounds = YES;
	self.outerImage.layer.cornerRadius = _outerImage.bounds.size.width/2;
	self.outerImage.layer.masksToBounds = YES;
	self.outerImage.backgroundColor = [UIColor orangeColor];

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
