//
//  imagePageContentViewController.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
@interface imagePageContentViewController : UIViewController
@property NSUInteger pageIndex;
@property (nonatomic, strong) Photo *selectedPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) UIViewContentMode contentMode;
@end
