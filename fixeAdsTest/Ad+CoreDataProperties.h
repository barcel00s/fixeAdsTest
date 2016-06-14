//
//  Ad+CoreDataProperties.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Ad.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ad (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ad_description;
@property (nullable, nonatomic, retain) NSNumber *has_email;
@property (nullable, nonatomic, retain) NSNumber *is_highlighted;
@property (nullable, nonatomic, retain) NSNumber *is_negotiable;
@property (nullable, nonatomic, retain) NSNumber *is_top_ad;
@property (nullable, nonatomic, retain) NSNumber *map_latitude;
@property (nullable, nonatomic, retain) NSNumber *map_longitude;
@property (nullable, nonatomic, retain) NSNumber *map_radius;
@property (nullable, nonatomic, retain) NSNumber *map_zoom;
@property (nullable, nonatomic, retain) NSString *subtype;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *url_preview;
@property (nullable, nonatomic, retain) NSString *user_ads_url;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSNumber *ad_id;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSSet<Photo *> *photos;

@end

@interface Ad (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet<Photo *> *)values;
- (void)removePhotos:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
