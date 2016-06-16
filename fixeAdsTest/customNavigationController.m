//
//  customNavigationController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "customNavigationController.h"

@interface customNavigationController ()

@end

@implementation customNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Prevent back swipe gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.interactivePopGestureRecognizer setEnabled:NO];
    }
    
    //Dynamic Text Changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    
    [self refreshFonts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Mark Notification Actions

-(void)refreshFonts{
    
    //Title
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle3];
    
    NSNumber *fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    
    NSDictionary *fontTraitsDictionary = @{UIFontWeightTrait:[NSNumber numberWithFloat:UIFontWeightBold]};
    
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont,UIFontDescriptorTraitsAttribute:fontTraitsDictionary}];
    
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    NSDictionary *titleTextAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]};
    
    [self.navigationBar setTitleTextAttributes:titleTextAttributes];
    
    //Configure Back Button
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    
    fontTraitsDictionary = @{UIFontWeightTrait:[NSNumber numberWithFloat:UIFontWeightBold]};
    
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont,UIFontDescriptorTraitsAttribute:fontTraitsDictionary}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
    
}

@end
