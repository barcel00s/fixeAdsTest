//
//  showAdViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ad.h"
#import "adViewController.h"
#import "userAdsTableViewController.h"
#import "itemListTableViewController.h"

@interface showAdViewController : UIViewController <UISplitViewControllerDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,adViewControllerProtocol,UIViewControllerTransitioningDelegate,userAdsTableViewControllerProtocol,itemListTableViewProtocol>

@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) Ad *selectedAd;

@property (nonatomic, strong) UIPageViewController *pageController;
@end
