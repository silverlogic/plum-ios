//
//  Chore.h
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chore : NSObject

@property (nonatomic, strong) NSNumber *choreId;
@property (nonatomic, strong) NSNumber *kidId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, copy) NSString *status;

+ (NSDictionary*)fieldMappings;

@end
