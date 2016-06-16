//
//  imageSliderViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageSliderViewController : UIViewController
@property (nonatomic, strong) NSSet *photos;
@property (nonatomic, strong) UIPageViewController *imagePageController;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) UIViewContentMode contentMode;
@end
