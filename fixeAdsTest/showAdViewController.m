//
//  showAdViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "showAdViewController.h"
#import "adViewController.h"
#import "presentImagesViewController.h"
#import "mapViewController.h"
#import "ModalCustomPresentAnimationController.h"
#import "ModalCustomDismissAnimationController.h"


@interface showAdViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,adViewControllerProtocol,UIViewControllerTransitioningDelegate>
@property (nonatomic) NSInteger currentPageIndex;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@end

@implementation showAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *logo = [UIImage imageNamed:@"OLX"];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:logo];
    
    [logoView addSubview:imageView];

    [self.navigationItem setTitleView:logoView];
    
    _pageController = [[UIPageViewController alloc]
                       initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                       options:nil];
    
    
    [_pageController setDataSource:self];
    [_pageController setDelegate:self];
    
    [[_pageController view] setFrame:[[self view] bounds]];
    
    NSInteger index = [_ads indexOfObject:_selectedAd];
    _currentPageIndex = index;
    
    adViewController *firstViewController = [self viewControllerAtIndex:index];
    
    NSArray *viewControllers = @[firstViewController];
    
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    

    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];    
    
    [_pageController didMoveToParentViewController:self];
    
    FAKIonIcons *mapIcon = [FAKIonIcons iosLocationOutlineIconWithSize:30];
    [_mapButton setImage:[mapIcon imageWithSize:CGSizeMake(30, 30)]];
    [_mapButton setTitle:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PageViewController Datasource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((adViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((adViewController*) viewController).pageIndex;
    
    if ((index == [_ads count]) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

#pragma mark PageViewController Delegate

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    adViewController *adController = (adViewController *)[pendingViewControllers lastObject];
    
    _currentPageIndex = adController.pageIndex;
    _selectedAd = [_ads objectAtIndex:_currentPageIndex];
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{

}

- (adViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([_ads count] == 0) || (index >= [_ads count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    adViewController *adController = [[adViewController alloc] initWithNibName:@"adViewController" bundle:nil];

    [adController setPageIndex:index];
    [adController setSelectedAd:[_ads objectAtIndex:index]];
    [adController setDelegate:self];
    
    return adController;
}

-(void)presentImagesAtIndex:(NSInteger)index{
    
    [self performSegueWithIdentifier:@"showImages" sender:[NSNumber numberWithInteger:index]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showImages"]) {
        presentImagesViewController *imagesController = (presentImagesViewController *)segue.destinationViewController;
        
        
        NSNumber *index = sender;
        [imagesController setSelectedIndex:index.integerValue];        
        [imagesController setPhotos:_selectedAd.photos];
        [imagesController setTransitioningDelegate:self];
        
    }
    else if ([segue.identifier isEqualToString:@"showMap"]){
        mapViewController *mapController = (mapViewController *)segue.destinationViewController;        
        [mapController setSelectedAd:_selectedAd];
    }
    
}

#pragma mark Transition Animation Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source{
    return [ModalCustomPresentAnimationController new];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [ModalCustomDismissAnimationController new];
}


@end
