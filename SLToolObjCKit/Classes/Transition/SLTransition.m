//
//  SLTransition.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2020/3/17.
//

#import "SLTransition.h"
#import "SLPresentationController.h"
#import "SLAnimatedTransitioning.h"

@implementation SLTransition
SLSingletonM(transition)

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[SLPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    SLAnimatedTransitioning *anim = [[SLAnimatedTransitioning alloc] init];
    anim.presented = YES;
    return anim;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    SLAnimatedTransitioning *anim = [[SLAnimatedTransitioning alloc] init];
    anim.presented = NO;
    return anim;
}
@end
