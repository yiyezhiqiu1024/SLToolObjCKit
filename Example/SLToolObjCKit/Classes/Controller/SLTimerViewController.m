//
//  SLTimerViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/29.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLTimerViewController.h"

#import <SLToolObjCKit/SLTimer.h>

@interface SLTimerViewController ()
@property (copy, nonatomic) NSString *name;
@end

@implementation SLTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.name = @"2";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stop];
    NSLog(@"%s", __func__);
}

- (void)dealloc {

    NSLog(@"%s", __func__);
}


- (IBAction)start {
    
//   self.name = [SLTimer sl_excuteTask:^{
//        NSLog(@"开始定时器 %@", [NSThread currentThread]);
//    } start:0 interval:0 repeats:NO async:YES];
    
    self.name = [SLTimer sl_excuteTaskWithTarget:self
                                        selector:@selector(doTask)
                                           start:2
                                        interval:1
                                       isRepeats:YES
                                         isAsync:YES];
}

- (IBAction)stop {
    
    if (0 == self.name.length) return;
    [SLTimer sl_cancelTask:self.name];
    NSLog(@"%s", __func__);
}

- (void)doTask {
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)setName:(NSString *)name {
    if (_name == name) return;
    
    [SLTimer sl_cancelTask:_name];
    _name = name;
    
}
@end
