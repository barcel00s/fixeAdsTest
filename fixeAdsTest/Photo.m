//
//  Photo.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "Photo.h"
#import "Ad.h"

@implementation Photo

// Insert code here to add functionality to your managed object subclass
+(Photo *)createPhotoWithDetails:(NSDictionary *)details inContext:(NSManagedObjectContext *)context{

    NSString *photoURL = [NSString stringWithFormat:@"%@%@_%@_%@x%@.jpg", kBasePhotosURL, [details objectForKey:@"riak_key"],[details objectForKey:@"slot_id"], [details objectForKey:@"w"], [details objectForKey:@"h"]];    
    
    Photo *newPhoto = [Photo findPhotoWithURL:photoURL inContext:context];
    
    if (!newPhoto) {
        //This is a new ad. We must create a new object.
        newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"inManagedObjectContext:context];
    
        [newPhoto setUrl:photoURL];
        
    }
    
    
    [newPhoto setSlot:[details objectForKey:@"slot_id"]];

    //Note: We do not download the image data here. We dowload it on a per-need basis when scrolling the tableView.
    
    return newPhoto;
}

+(Photo *)findPhotoWithURL:(NSString *)urlString inContext:(NSManagedObjectContext *)context{
    Photo *foundPhoto = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url = %@", urlString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error looking for photo with url %@ - %@",urlString, error.localizedDescription);
    }
    else{
        foundPhoto = [fetchedObjects lastObject];
    }
    
    return foundPhoto;
}

@end
