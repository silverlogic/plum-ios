//
//  KidTableViewCell.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "KidTableViewCell.h"
#import "UIImageView+AFNetworking.h"

static NSString *const _reuseIdentifier = @"KidTableViewCell";

@interface KidTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *outerCircle;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIProgressView *pointsBar;
@property (strong, nonatomic) IBOutlet UILabel *pointsBarLabel;
@property (strong, nonatomic) IBOutlet UILabel *spentLabel;

@end


@implementation KidTableViewCell

- (void)awakeFromNib {
    // Initialization code
	self.profileImage.layer.cornerRadius = _profileImage.bounds.size.width/2;
	self.profileImage.layer.masksToBounds = YES;
	self.outerCircle.layer.cornerRadius = _outerCircle.bounds.size.width/2;
	self.outerCircle.layer.masksToBounds = YES;
}

+ (NSString*)reuseIdentifier {
	return _reuseIdentifier;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setters
- (void)setKid:(Kid *)kid {
	_kid = kid;
	self.name.text = self.kid.name;
	// reversed points and spent labels until points exist
    [self.profileImage setImageWithURL:kid.profileImageUrl placeholderImage:nil];
	self.pointsBar.progress = ceil(self.kid.spent.floatValue) / ceil(self.kid.allowance.floatValue);
	self.spentLabel.text = [NSString stringWithFormat:@"%.0f / %.0f points", ceil(self.kid.points), ceil(self.kid.pointsGoal)];
	self.pointsBarLabel.text = [NSString stringWithFormat:@"%.0f / %.0f $", ceil(self.kid.spent.floatValue), ceil(self.kid.allowance.floatValue)];
}


@end
