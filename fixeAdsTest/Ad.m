//
//  Ad.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "Ad.h"

@implementation Ad

// Insert code here to add functionality to your managed object subclass
+(Ad *)createAdWithDetails:(NSDictionary *)details inContext:(NSManagedObjectContext *)context{
    
    Ad *newAd = [Ad findAdWithId:[details objectForKey:@"id"] inContext:context];    
    
    if (!newAd) {
        //This is a new ad. We must create a new object.
        newAd = [NSEntityDescription insertNewObjectForEntityForName:@"Ad"inManagedObjectContext:context];
    }
    
    //Update the data fields
    NSString *adIdString = [details objectForKey:@"id"];
    
    [newAd setAd_id:[NSNumber numberWithInteger:adIdString.integerValue]];
    
    [newAd setTitle:[details objectForKey:@"title"]];
    [newAd setAd_description:[details objectForKey:@"description"]];
    [newAd setCity:[details objectForKey:@"city_label"]];
    [newAd setHas_email:[details objectForKey:@"has_email"]];
    [newAd setIs_highlighted:[details objectForKey:@"highlighted"]];
    [newAd setIs_negotiable:[details objectForKey:@"price_is_negotiable"]];
    [newAd setIs_top_ad:[details objectForKey:@"topAd"]];
    [newAd setPrice:[details objectForKey:@"list_label_ad"]];
    
    NSNumber *latitude = [NSNumber numberWithFloat:((NSString *)[details objectForKey:@"map_lat"]).floatValue];
    [newAd setMap_latitude:latitude];
    
    NSNumber *longitude = [NSNumber numberWithFloat:((NSString *)[details objectForKey:@"map_lon"]).floatValue];
    [newAd setMap_longitude:longitude];
    
    [newAd setMap_radius:[details objectForKey:@"map_radius"]];
    
    NSString *mapZoomString = [details objectForKey:@"map_zoom"];
    
    [newAd setMap_zoom:[NSNumber numberWithInteger:mapZoomString.integerValue]];
    
    [newAd setUrl:[details objectForKey:@"url"]];
    [newAd setUrl_preview:[details objectForKey:@"preview_url"]];
    [newAd setUser_ads_url:[details objectForKey:@"user_ads_url"]];
    
    if (![[details objectForKey:@"person"] isEqualToString:@""] && ![[details objectForKey:@"person"] isEqualToString:@" "]) {
        [newAd setUsername:[details objectForKey:@"person"]];
    }
    //Default is "Não identificado"
    
    
    //Now we add the photos.
    NSDictionary *photos = [details objectForKey:@"photos"];
    NSArray *photosData = [photos objectForKey:@"data"];
    
    for(NSDictionary *photoData in photosData){
        NSMutableDictionary *newDictionary = [photoData mutableCopy];
        [newDictionary setObject:[photos objectForKey:@"riak_key"] forKey:@"riak_key"];
        
        Photo *newPhoto = [Photo createPhotoWithDetails:newDictionary inContext:context];
        
        [newAd addPhotosObject:newPhoto];
    }
    
    return newAd;
}

+(Ad *)findAdWithId:(NSNumber *)adId inContext:(NSManagedObjectContext *)context{
    Ad *foundAd = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ad"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ad_id = %@", adId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error looking for ad with id %@ - %@",adId, error.localizedDescription);
    }
    else{
        foundAd = [fetchedObjects lastObject];
    }
    
    return foundAd;
    
}
@end
