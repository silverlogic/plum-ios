//
//  Transaction.h
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic, strong) NSNumber *transactionId;
@property (nonatomic, strong) NSNumber *cardId;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSDate *date;

+ (NSDictionary*)fieldMappings;

@end
