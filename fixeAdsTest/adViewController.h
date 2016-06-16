//
//  adViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ad.h"
@class adViewController;
@protocol adViewControllerProtocol <NSObject>

//Performs the segue to present the full screen images
-(void)presentImagesAtIndex:(NSInteger)index;

@end

@interface adViewController : UIViewController

@property NSUInteger pageIndex;
@property (nonatomic, strong) Ad *selectedAd;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *imageSliderContainer;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id <adViewControllerProtocol> delegate;

@end
