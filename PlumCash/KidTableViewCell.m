//
//  KidTableViewCell.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "KidTableViewCell.h"
static NSString *const _reuseIdentifier = @"KidTableViewCell";

@interface KidTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIProgressView *pointsBar;
@property (strong, nonatomic) IBOutlet UILabel *pointsBarLabel;
@property (strong, nonatomic) IBOutlet UILabel *spentLabel;

@end


@implementation KidTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (NSString*)reuseIdentifier {
	return _reuseIdentifier;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setters
- (void)setKid:kid {
	_kid = kid;
	self.name.text = self.kid.name;
//	self.profileImage = 
	self.pointsBar.progress = self.kid.points / self.kid.pointsGoal;
	self.pointsBarLabel.text = [NSString stringWithFormat:@"%.0f / %.0f points", ceil(self.kid.points), ceil(self.kid.pointsGoal)];
	self.spentLabel.text = [NSString stringWithFormat:@"%.0f spent of %.0f dollars", ceil(self.kid.spent), ceil(self.kid.allowance)];
}


@end
