//
//  userAdsTableViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Ad.h"

@class userAdsTableViewController;

@protocol userAdsTableViewControllerProtocol <NSObject>

-(void)didSelectAd:(Ad *)selectedAd fromAds:(NSArray *)ads;

@end


@interface userAdsTableViewController : UITableViewController
@property (nonatomic, strong) User *selectedUser;
@property (nonatomic, strong) Ad *selectedAd;
@property (nonatomic, weak) id <userAdsTableViewControllerProtocol> delegate;
@end
