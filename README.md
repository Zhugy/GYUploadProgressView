# GYUploadProgressView
iOS 加载进度之圆形加载

### 效果图
![ezgif.com-video-to-gif.gif](https://upload-images.jianshu.io/upload_images/2728258-67b407010f34e59b.gif?imageMogr2/auto-orient/strip)

### 使用方法

```
/**
 * 提示文案
 * 默认 正在加载
 */
+ (nonnull GYProgressView *)gy_showProgressWithAlertStr:(NSString *_Nullable)alertStr progressFinishedHandle:(void(^)(void))progressFinishedHandle;

/**
 * 设置进度
 */
- (void)setProgressWithPercentage:(CGFloat)percentage;

/**
 * 销毁页面
 */
- (void)gy_dismissView;

```

### 核心代码
 - 1、绘制圆
 
```
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

```
- 2、设置进度

```
_progressLayer.strokeEnd = _percentage;
NSString *str = [NSString stringWithFormat:@"%.0f%%",_percentage*100]; 
_progressLabel.text = str;

```
###  注意事项

 为防止 外界set 值过快， 导致 实际显示跟 值有差值，设定一个定时器定时去取值
 
```
- (void)setProgressWithPercentage:(CGFloat)percentage {
    self.percentage = percentage;
    if (self.timer == nil && !self.canRemoveTimer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updataUI) userInfo:nil repeats:YES];
    }
}

```

### 使用

pod 'GYUploadProgressView'
