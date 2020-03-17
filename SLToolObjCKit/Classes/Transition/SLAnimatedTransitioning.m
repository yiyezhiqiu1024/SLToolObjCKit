//
//  SLAnimatedTransitioning.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2020/3/17.
//

#import "SLAnimatedTransitioning.h"
#import "UIView+Extension.h"

const CGFloat duration = 1.0;

@implementation SLAnimatedTransitioning


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.presented) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//        toView.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 1, 0);
//        toView.y = -toView.height;
        toView.x = toView.width;
        [UIView animateWithDuration:duration animations:^{
//            toView.y = 0;
            toView.x = 0;
//            toView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//            fromView.y = -fromView.height;
            fromView.x = -fromView.width;
//            fromView.layer.transform = CATransform3DMakeRotation(M_PI_2, 1, 1, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
