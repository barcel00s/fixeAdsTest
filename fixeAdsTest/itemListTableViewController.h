//
//  itemListTableViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ad.h"

@class itemListTableViewController;

@protocol itemListTableViewProtocol <NSObject>

-(void)didSelectAd:(Ad *)selectedAd fromAds:(NSArray *)ads;

@end

@interface itemListTableViewController : UITableViewController
@property (nonatomic, weak) id <itemListTableViewProtocol> delegate;

@end
