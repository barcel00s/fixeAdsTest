//
//  Ad.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ad : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(Ad *)createAdWithDetails:(NSDictionary *)details inContext:(NSManagedObjectContext *)context;
+(Ad *)findAdWithId:(NSNumber *)adId inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Ad+CoreDataProperties.h"
