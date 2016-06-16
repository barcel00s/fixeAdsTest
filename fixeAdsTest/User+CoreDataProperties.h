//
//  User+CoreDataProperties.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ads_url;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSOrderedSet<Ad *> *ads;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)insertObject:(Ad *)value inAdsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAdsAtIndex:(NSUInteger)idx;
- (void)insertAds:(NSArray<Ad *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAdsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAdsAtIndex:(NSUInteger)idx withObject:(Ad *)value;
- (void)replaceAdsAtIndexes:(NSIndexSet *)indexes withAds:(NSArray<Ad *> *)values;
- (void)addAdsObject:(Ad *)value;
- (void)removeAdsObject:(Ad *)value;
- (void)addAds:(NSOrderedSet<Ad *> *)values;
- (void)removeAds:(NSOrderedSet<Ad *> *)values;

@end

NS_ASSUME_NONNULL_END
