//
//  SLPresentationController.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2020/3/17.
//

#import "SLPresentationController.h"

@implementation SLPresentationController

- (void)presentationTransitionWillBegin {
    self.presentedView.frame = self.containerView.bounds;
    [self.containerView addSubview:self.presentedView];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
//    NSLog(@"presentationTransitionDidEnd");
}

- (void)dismissalTransitionWillBegin {
//    NSLog(@"dismissalTransitionWillBegin");
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [self.presentedView removeFromSuperview];
}
@end
