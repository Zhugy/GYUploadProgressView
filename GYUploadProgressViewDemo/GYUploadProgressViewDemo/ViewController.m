//
//  ViewController.m
//  GYUploadProgressViewDemo
//
//  Created by zhugy on 2019/4/18.
//  Copyright © 2019 zhugy. All rights reserved.
//

#import "ViewController.h"
#import "GYProgressView.h"

@interface ViewController ()

@property (nonatomic, strong, nullable) NSTimer *timer;
@property (nonatomic, strong, nullable) GYProgressView *pv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)showAlertViewAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    self.pv = [GYProgressView gy_showProgressWithAlertStr:nil progressFinishedHandle:^{
        [weakSelf invalidate];
    }];
    
    [self creatTimer];
}


- (void)creatTimer {
    if (self.timer == nil) {
       __block CGFloat progress = 0.01;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
            progress += 0.01;
            if (progress > 1) {
                [self.pv gy_dismissView];
            } else {
                [self.pv setProgressWithPercentage:progress];
            }
        }];
    }
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

@end
