//
//  CustomDismissAnimationController.m
//  CoolTour
//
//  Created by Rui Cardoso on 16/09/15.
//  Copyright (c) 2015 Coding Beats. All rights reserved.
//

 /*
    We dismiss the view controller by sending it up and fading it at the same time

 */

#import "ModalCustomDismissAnimationController.h"

@implementation ModalCustomDismissAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kTimeTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [fromViewController.view setFrame:CGRectOffset(finalFrame, 0, bounds.size.height)];
        [fromViewController.view setAlpha:0.8];

        [toViewController.view setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        [toViewController.view setAlpha:1.0];

        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

@end
