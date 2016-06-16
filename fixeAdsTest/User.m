//
//  User.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "User.h"
#import "Ad.h"

@implementation User

// Insert code here to add functionality to your managed object subclass
+(User *)createUserWithDetails:(NSDictionary *)details inContext:(NSManagedObjectContext *)context{
    User *newUser = [User findUserWithId:[details objectForKey:@"id"] inContext:context];
    
        
    if (!newUser) {
        //This is a new user. We must create a new object.
        newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User"inManagedObjectContext:context];
    }
    
    //Update the data fields
    
    [newUser setUser_id:[details objectForKey:@"id"]];
    
    if (![[details objectForKey:@"name"] isEqualToString:@""] && ![[details objectForKey:@"name"] isEqualToString:@" "]) {
        [newUser setName:[details objectForKey:@"name"]];
    }    
    
    [newUser setAds_url:[details objectForKey:@"ads_url"]];
    
    return newUser;
}

+(User *)findUserWithId:(NSString *)userId inContext:(NSManagedObjectContext *)context{
    User *foundUser = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id = %@", userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error looking for user with id %@ - %@",userId, error.localizedDescription);
    }
    else{
        foundUser = [fetchedObjects lastObject];
    }
    
    return foundUser;
}
@end
