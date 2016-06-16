//
//  imageSliderViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "imageSliderViewController.h"
#import "imagePageContentViewController.h"

@interface imageSliderViewController ()<UIPageViewControllerDataSource>

@end

@implementation imageSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIPageControl *pageControl = [UIPageControl appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:self.view.tintColor];
    [pageControl setHidesForSinglePage:YES];
    
    _imagePageController = [[UIPageViewController alloc]
                       initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                       options:nil];
    
    
    [_imagePageController setDataSource:self];
    
    [[_imagePageController view] setFrame:[[self view] bounds]];
    
    imagePageContentViewController *firstViewController = [self viewControllerAtIndex:_currentPageIndex];
    
    if (firstViewController) {
        NSArray *viewControllers = [NSArray arrayWithObjects:firstViewController, nil];
        
        [_imagePageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        
        [self addChildViewController:_imagePageController];
        [self.view addSubview:_imagePageController.view];
        
        [_imagePageController didMoveToParentViewController:self];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark PageViewController Datasource
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
    
    if ((index == [_photos count]) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

- (imagePageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    if (([_photos count] == 0) || (index >= [_photos count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    imagePageContentViewController *pageContentController = [[imagePageContentViewController alloc] initWithNibName:@"imagePageContentViewController" bundle:nil];
    
    [pageContentController setPageIndex:index];
    [pageContentController setContentMode:_contentMode];    
    [pageContentController setSelectedPhoto:[[_photos allObjects] objectAtIndex:index]];

    
    return pageContentController;
}

/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [_photos count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
*/
@end
