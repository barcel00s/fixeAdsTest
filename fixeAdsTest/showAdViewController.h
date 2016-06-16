//
//  showAdViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ad.h"

@interface showAdViewController : UIViewController
@property (nonatomic, strong) NSArray *ads;
@property (nonatomic, strong) Ad *selectedAd;

@property (nonatomic, strong) UIPageViewController *pageController;
@end
