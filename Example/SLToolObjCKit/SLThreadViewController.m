//
//  SLThreadViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/29.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLThreadViewController.h"

#import <SLToolObjCKit/SLPermenantThread.h>

@interface SLThreadViewController ()

@property (strong, nonatomic) SLPermenantThread *myThread;

@end

@implementation SLThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myThread = [[SLPermenantThread alloc] init];
}

- (void)dealloc {
    [self stop];
    NSLog(@"%s", __func__);
}

- (IBAction)start {
    [self.myThread sl_executeTask:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
}

- (IBAction)stop {
    [self.myThread sl_stop];
    NSLog(@"%s", __func__);
    
}

@end

