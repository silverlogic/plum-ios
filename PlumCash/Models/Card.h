//
//  Card.h
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSNumber *cardId;
@property (nonatomic, copy) NSString *ownerType;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, copy) NSString *nameOnCard;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, strong) NSString *expirationDate;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *subType;
@property (nonatomic, strong) NSNumber *allowance;
@property (nonatomic, strong) NSNumber *spent;

+ (NSDictionary*)fieldMappings;

@end
