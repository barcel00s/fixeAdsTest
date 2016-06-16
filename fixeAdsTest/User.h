//
//  User.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ad;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(User *)createUserWithDetails:(NSDictionary *)details inContext:(NSManagedObjectContext *)context;
+(User *)findUserWithId:(NSString *)userId inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
