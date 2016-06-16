//
//  adViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "adViewController.h"
#import "imageSliderViewController.h"
#import "imagePageContentViewController.h"
#import "userAdsTableViewController.h"

@interface adViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,userAdsTableViewControllerProtocol>

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIStackView *mainStack;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *isNegotiableLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageContainerHeightConstraint;
@property (nonatomic, strong) imageSliderViewController *imageSlider;
@property (nonatomic) NSInteger currentImageIndex;
@property (strong, nonatomic) IBOutlet UIButton *showUserItems;

@end

@implementation adViewController

-(void)setSelectedAd:(Ad *)selectedAd{
    
    _selectedAd = selectedAd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Dynamic Text Changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    
    // Do any additional setup after loading the view from its nib.    
    [self setupView];
    
    [self refreshFonts];
    
    FAKIonIcons *userIcon = [FAKIonIcons personIconWithSize:40];
    [_showUserItems setImage:[userIcon imageWithSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //The app wasn't setting the content size correctly on the first view controller when loading the view. This workaround is to allow the app to determine the stack view size before assigning the content size.
    [self performSelector:@selector(setScrollViewContentSizeWithDelay) withObject:nil afterDelay:0.5];
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

#pragma mark Page Controller Datasource

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((imagePageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((imagePageContentViewController*) viewController).pageIndex;
    
    if ((index == [_imageSlider.photos count]) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

- (imagePageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_imageSlider.photos count] == 0) || (index >= [_imageSlider.photos count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    imagePageContentViewController *pageContentController = [[imagePageContentViewController alloc] initWithNibName:@"imagePageContentViewController" bundle:nil];
    
    [pageContentController setPageIndex:index];
    [pageContentController setContentMode:UIViewContentModeScaleAspectFill];
    
    [pageContentController setSelectedPhoto:[[_imageSlider.photos array] objectAtIndex:index]];
    
    return pageContentController;
}

#pragma mark Page Controller Delegate
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    imagePageContentViewController *imageController = (imagePageContentViewController *)[pageViewController.viewControllers objectAtIndex:0];
    
    _currentImageIndex = imageController.pageIndex;
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    

    
}

-(void)didSelectAd:(Ad *)selectedAd fromAds:(NSArray *)ads{
/*    _selectedAd = selectedAd;
    
    [self setupView];*/
    
    [self.delegate didSelectAd:selectedAd fromAds:ads];
}

#pragma mark Gesture Actions
- (IBAction)tapOnImageView:(UITapGestureRecognizer *)sender {
    [self.delegate presentImagesAtIndex:_currentImageIndex];
}

#pragma mark Button Actions
- (IBAction)showUserItems:(UIButton *)sender {
    
    if (IS_IPAD) {
        userAdsTableViewController *userAdsController = [[userAdsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        [userAdsController setDelegate:self];
        [userAdsController setSelectedUser:_selectedAd.user];
        [userAdsController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [userAdsController setModalPresentationStyle:UIModalPresentationPopover];
        [userAdsController.popoverPresentationController setSourceView:_showUserItems];
        [userAdsController.popoverPresentationController setSourceRect:CGRectMake(30, 15, 1, 1)];
        
        [self presentViewController:userAdsController animated:YES completion:nil];
    }
    else{
        [self.delegate showAdsForUser:_selectedAd.user];
    }
    
}


#pragma mark Functions
-(void)configureImageSlider{
    
    //Load the image slider
    
    if (_imageSlider) {
        [_imageSlider.view removeFromSuperview];
    }
    
    _imageSlider = [[imageSliderViewController alloc] init];
    
    [_imageSlider setPhotos:_selectedAd.photos];
    [_imageSlider setContentMode:UIViewContentModeScaleAspectFill];
    
    [_imageSlider.view setFrame:_imageSliderContainer.frame];
    [_imageSliderContainer addSubview:_imageSlider.view];
    
    
    //Since we're adding the image page controller without a container (via adding view), this controller must be the datasource otherwise the datasource methods aren't called.
    [_imageSlider.imagePageController setDataSource:self];
    [_imageSlider.imagePageController setDelegate:self];
    
    UIPageControl *pageControl = [UIPageControl appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:self.view.tintColor];
    [pageControl setHidesForSinglePage:YES];
    
    _imageSlider.imagePageController = [[UIPageViewController alloc]
                            initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                            navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                            options:nil];
    
    
    [[_imageSlider.imagePageController view] setFrame:[[_imageSlider view] bounds]];
    
    imagePageContentViewController *firstViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:firstViewController, nil];
    
    [_imageSlider.imagePageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
    [_imageSlider addChildViewController:_imageSlider.imagePageController];
    //[_imageSlider.view addSubview:_imageSlider.imagePageController.view];
    
    [_imageSlider.imagePageController didMoveToParentViewController:self];
    
}

-(void)refreshFonts{
    //Title Label
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle2];
    
    NSNumber *fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    
    NSDictionary *fontTraitsDictionary = @{UIFontWeightTrait:[NSNumber numberWithFloat:UIFontWeightBold]};
    
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont,UIFontDescriptorTraitsAttribute:fontTraitsDictionary}];
    
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_titleLabel setFont:font];
    
    
    //Location Label
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_locationLabel setFont:font];
    
    
    //Description Label
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_descriptionLabel setFont:font];
    
    
    //Username Label
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_usernameLabel setFont:font];
    
    
    //Price Label - Footnote Template
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCallout];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    fontTraitsDictionary = @{UIFontWeightTrait:[NSNumber numberWithFloat:UIFontWeightBold]};
    
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont,UIFontDescriptorTraitsAttribute:fontTraitsDictionary}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_priceLabel setFont:font];
    [_isNegotiableLabel setFont:font];
}

-(void)setScrollViewContentSizeWithDelay{    
    
    CGSize contentSize = CGSizeMake(_mainStack.frame.size.width, _mainStack.frame.size.height);
    
    [_mainScrollView setContentSize:contentSize];

}

-(void)setupView{
    
    if ([_selectedAd.photos count] > 0) {
        
        [self configureImageSlider];
    }
    else{         
        //This ad hasn't got any images.
        [_imageSliderContainer layoutIfNeeded];
        
        [UIView animateWithDuration:0.5 animations:^{
            //We hide the image container            
            [_imageContainerHeightConstraint setConstant:0.0];
            [_imageSliderContainer layoutIfNeeded];
        }];
    }
    
    //Configure the view.
    [_usernameLabel setText:_selectedAd.user.name];
    [_descriptionLabel setText:_selectedAd.ad_description];
    [_titleLabel setText:_selectedAd.title];
    [_locationLabel setText:_selectedAd.city];
    [_priceLabel setText:_selectedAd.price];
    
    if ([_selectedAd.is_negotiable boolValue]) {
        [_isNegotiableLabel setText:@"Negociável"];
    }
    else{
        [_isNegotiableLabel setText:@"Não negociável"];
    }
    
}

@end
