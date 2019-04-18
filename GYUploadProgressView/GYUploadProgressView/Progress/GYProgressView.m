//
//  GYProgressView.m
//  GYUploadProgressView
//
//  Created by zhugy on 2019/4/18.
//  Copyright © 2019 zhugy. All rights reserved.
//

#import "GYProgressView.h"

CGFloat kScreen_width(void) {
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat kScreen_height(void) {
    return [UIScreen mainScreen].bounds.size.height;
}

@interface GYProgressView ()


@property (nonatomic, strong, nullable) UIView *alertView;
@property (nonatomic, strong, nullable) UILabel *alertLabel;
@property (nonatomic, strong, nullable) UIView *bgProgressView;
@property (nonatomic, strong, nullable) UIView *progressView;
@property (nonatomic, strong, nullable) CAShapeLayer *bgProgressLayer;
@property (nonatomic, strong, nullable) CAShapeLayer *progressLayer;
@property (nonatomic, strong, nullable) UILabel *progressLabel;
@property (nonatomic, strong, nullable) UIView *bgView;
@property (nonatomic, copy, nullable) NSString *alertStr;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) CGFloat percentage;// 百分比

@property (nonatomic, assign) BOOL canRemoveTimer;// 是否可以销毁定时器

@property (nonatomic, copy, nullable) void (^progressFinishedHandle)(void);

@end

@implementation GYProgressView

+ (GYProgressView *)gy_showProgressWithAlertStr:(NSString *)alertStr progressFinishedHandle:(nonnull void (^)(void))progressFinishedHandle {
    GYProgressView *upload = [[GYProgressView alloc] init];
    upload.alertStr = alertStr;
    upload.canRemoveTimer = NO;
    upload.progressFinishedHandle = progressFinishedHandle;
    UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
    UIViewController* vc2 = vc.presentedViewController;
    [vc2?:vc presentViewController:upload animated:YES completion:nil];
    return upload;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.alertView];
    [self.alertView addSubview:self.alertLabel];
    [self.alertView addSubview:self.bgProgressView];
    [self.alertView addSubview:self.progressView];
    [self.alertView addSubview:self.progressLabel];
    
    [self setupLayer];
}

- (void)setupLayer {
    [self.view layoutIfNeeded];
    
    // 黑色的背景框
    CAShapeLayer *bordLayer = [CAShapeLayer layer];
    UIBezierPath *bordPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 148, 116) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    bordLayer.path = bordPath.CGPath;
    self.alertView.layer.mask = bordLayer;
    
    // 进度的底色
    UIBezierPath *bgRoundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:20 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.bgProgressLayer.path = bgRoundPath.CGPath;
    [self.bgProgressView.layer addSublayer:self.bgProgressLayer];
    
    // 进度的颜色
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:20 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI *2 clockwise:YES];
    self.progressLayer.path = roundPath.CGPath;
    [self.progressView.layer addSublayer:self.progressLayer];
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
}

- (void)setProgressWithPercentage:(CGFloat)percentage {
    self.percentage = percentage;
    if (self.timer == nil && !self.canRemoveTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updataUI) userInfo:nil repeats:YES];
    }
}

- (void)updataUI {
    _progressLayer.strokeEnd = _percentage;
    NSString *str = [NSString stringWithFormat:@"%.0f%%",_percentage*100];
    _progressLabel.text = str;
    if (_percentage >= 1) {
        [self invalidate];
    }
}

- (void)dismiss {
    _progressLayer.strokeEnd = 1;
    _progressLabel.text = @"100%";
    
    [self invalidate];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.progressFinishedHandle) {
            self.progressFinishedHandle();
        }
    }];
}

- (void)invalidate {
    self.canRemoveTimer = YES;
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)gy_dismissView {
    [self dismiss];
}

- (void)setAlertStr:(NSString *)alertStr {
    _alertStr = alertStr;
    if (alertStr.length > 0) {
        self.alertLabel.text = alertStr;
    }
}

#pragma mark - getter

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width(), kScreen_height())];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return _bgView;
}

- (UIView *)alertView {
    if (_alertView == nil) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_width()-148)/2, (kScreen_height()-116)/2, 148, 116)];
        _alertView.backgroundColor = [UIColor blackColor];
    }
    return _alertView;
}

- (UILabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, 148, 17)];
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.text = @"正在加载";
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:16];
    }
    return _alertLabel;
}

- (UILabel *)progressLabel {
    if (_progressLabel == nil) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 30, 40, 20)];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.text = @"0%";
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:12];
    }
    return _progressLabel;
}

- (UIView *)bgProgressView {
    if (_bgProgressView == nil) {
        _bgProgressView = [[UIView alloc] initWithFrame:CGRectMake(54, 20, 40, 40)];
    }
    return _bgProgressView;
}

- (UIView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(54, 20, 40, 40)];
    }
    return _progressView;
}

- (CAShapeLayer *)bgProgressLayer {
    if (_bgProgressLayer == nil) {
        _bgProgressLayer = [CAShapeLayer layer];
        _bgProgressLayer.strokeColor = [UIColor colorWithRed:144/255.0  green:144/255.0  blue:144/255.0  alpha:1/1.0].CGColor;
        _bgProgressLayer.fillColor = [UIColor clearColor].CGColor;
        _bgProgressLayer.lineWidth = 2;
    }
    return _bgProgressLayer;
}

- (CAShapeLayer *)progressLayer {
    if (_progressLayer == nil) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = 2;
    }
    return _progressLayer;
}

- (void)dealloc {
    [self invalidate];
}
@end
