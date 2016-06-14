//
//  Photo.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ad;

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(Photo *)createPhotoWithDetails:(NSDictionary *)details inContext:(NSManagedObjectContext *)context;

+(Photo *)findPhotoWithURL:(NSString *)urlString inContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

#import "Photo+CoreDataProperties.h"
