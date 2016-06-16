//
//  presentImagesViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "presentImagesViewController.h"
#import "imageSliderViewController.h"

@interface presentImagesViewController ()
@property(nonatomic, strong) imageSliderViewController *imagesController;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation presentImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FAKIonIcons *closeIcon = [FAKIonIcons closeIconWithSize:30.0];
    
    [_closeButton setTitle:nil forState:UIControlStateNormal];
    [_closeButton setImage:[closeIcon imageWithSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"imagesContainer"]) {
        
        _imagesController = (imageSliderViewController *)segue.destinationViewController;
        
        [_imagesController setCurrentPageIndex:_selectedIndex];
        [_imagesController setPhotos:_photos];
        [_imagesController setContentMode:UIViewContentModeScaleAspectFit];
    }
    
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
