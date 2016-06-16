//
//  Photo+CoreDataProperties.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) NSNumber *slot;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) Ad *ad;

@end

NS_ASSUME_NONNULL_END
