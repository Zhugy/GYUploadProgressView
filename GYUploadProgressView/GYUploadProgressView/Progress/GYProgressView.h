//
//  GYProgressView.h
//  GYUploadProgressView
//
//  Created by zhugy on 2019/4/18.
//  Copyright © 2019 zhugy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYProgressView : UIViewController

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


@end

NS_ASSUME_NONNULL_END
