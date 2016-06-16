//
//  imageSliderViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//
//This controller is used whenever we wish to present a PageController to present a set of images (So far we are using it to present the images in the ad controller (adViewController) and the images in full screen (presentImagesViewController).

#import <UIKit/UIKit.h>

@interface imageSliderViewController : UIViewController
@property (nonatomic, strong) NSOrderedSet *photos;
@property (nonatomic, strong) UIPageViewController *imagePageController;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) UIViewContentMode contentMode;
@end
