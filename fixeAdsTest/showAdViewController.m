//
//  showAdViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "showAdViewController.h"
#import "presentImagesViewController.h"
#import "mapViewController.h"
#import "ModalCustomPresentAnimationController.h"
#import "ModalCustomDismissAnimationController.h"

@interface showAdViewController ()
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) NSInteger previousPageIndex;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@end

@implementation showAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (IS_IPAD) {
        
        if (_selectedAd) {
            [self.navigationItem setTitle:_selectedAd.title];
        }
        
        [self.navigationItem setLeftBarButtonItem:self.splitViewController.displayModeButtonItem];
    }
    else{
        UIImage *logo = [UIImage imageNamed:@"OLX"];
        
        UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:logo];
        
        [logoView addSubview:imageView];
        
        [self.navigationItem setTitleView:logoView];
    }
    
    
    
    FAKIonIcons *mapIcon = [FAKIonIcons iosLocationOutlineIconWithSize:30];
    [_mapButton setTitle:nil];
    
    [self.navigationItem.rightBarButtonItem setImage:[mapIcon imageWithSize:CGSizeMake(30, 30)]];
    [self.navigationItem.rightBarButtonItem setTitle:nil];
    
    [self configureViewData];

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
    
    
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    adViewController *currentController = (adViewController *)[pageViewController.viewControllers objectAtIndex:0];
    
    _previousPageIndex = _currentPageIndex;
    _currentPageIndex = currentController.pageIndex;
    
    _selectedAd = [_ads objectAtIndex:_currentPageIndex];
    
    [self.navigationItem setTitle:_selectedAd.title];
    
    //We can't have showAdViewController and itemListTableViewController being delegates of eachother so in order to send a message to itemListViewController we'll post a notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adIndexHasChangedNotification" object:[NSNumber numberWithInteger:_currentPageIndex]];    
    
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

#pragma mark adViewController Delegate
-(void)presentImagesAtIndex:(NSInteger)index{
    
    [self performSegueWithIdentifier:@"showImages" sender:[NSNumber numberWithInteger:index]];
}

-(void)showAdsForUser:(User *)user{
    
    //Only called on iPhone version
    if (!IS_IPAD) {
        [self performSegueWithIdentifier:@"showUserAds" sender:user];
    }
    
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
    else if ([segue.identifier isEqualToString:@"showUserAds"]){
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        [navigationController setTransitioningDelegate:self];
        
        userAdsTableViewController *userAdsController = (userAdsTableViewController *)[navigationController topViewController];
                
        [userAdsController setDelegate:self];
        [userAdsController setSelectedUser:sender];
        [userAdsController setSelectedAd:_selectedAd];
        
    }
    
}

#pragma mark Item List Delegate

-(void)didSelectAd:(Ad *)selectedAd fromAds:(NSArray *)ads{
    
    _selectedAd = selectedAd;
    _ads = ads;
    
    _previousPageIndex = _currentPageIndex;    
    _currentPageIndex = [_ads indexOfObject:_selectedAd];
    
    //We now need to refresh all the data
    [self configureViewData];
    
    if (IS_IPAD) {
        [self.splitViewController.displayModeButtonItem action];
    }
}


#pragma mark SplitViewController Delegate
-(void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{

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

#pragma mark Functions
-(void)configureViewData{
    
    if (_selectedAd) {
        
        //We need to remove all current controllers because of when we're switching from full list to user items list.
        
        if (_pageController) {
            [_pageController.view removeFromSuperview];
        }
        
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
        
        if (firstViewController) {
            NSArray *viewControllers = @[firstViewController];
            
            if (_currentPageIndex > _previousPageIndex) {
                [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }
            else{
                [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            
            
            [self addChildViewController:_pageController];
            
            [self.view addSubview:_pageController.view];
            
            [_pageController didMoveToParentViewController:self];
        }
        
        [self.navigationItem setTitle:_selectedAd.title];
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }

}

#pragma mark IPad ONLY


@end
