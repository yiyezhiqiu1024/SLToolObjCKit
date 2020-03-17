//
//  SLAnimatedTransitioning.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2020/3/17.
//  自定义转场动画
//

#import <UIKit/UIKit.h>

@interface SLAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presented;
@end
