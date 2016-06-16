//
//  CustomPresentAnimationController.m
//  CoolTour
//
//  Created by Rui Cardoso on 16/09/15.
//  Copyright (c) 2015 Coding Beats. All rights reserved.
//
/*
    We present the view controller from down to up, bouncing a little and fading the original view

 */

#import "ModalCustomPresentAnimationController.h"

@implementation ModalCustomPresentAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kTimeTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *containerView = [transitionContext containerView];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [toViewController.view setFrame:CGRectOffset(finalFrame, 0, bounds.size.height)];
    [toViewController.view setAlpha:0.0];
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [fromViewController.view setTransform:CGAffineTransformMakeScale(0.75, 0.75)];
        [fromViewController.view setAlpha:0.5];

        [toViewController.view setFrame:finalFrame];
        [toViewController.view setAlpha:1.0];
        
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];        
    }];
    
}

@end
