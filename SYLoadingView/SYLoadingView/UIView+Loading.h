//
//  UIView+Loading.h
//  XPSPlatform
//
//  Created by sy on 2017/11/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SYHUDDismissCompletion)(void);

typedef enum : NSUInteger {
    LoadViewWhiteStyle = 0, // 白色分割
    LoadViewNone = 1, // 无loadview
    LoadViewClearStyle = 2, // 透明风格
    
} LoadViewStyle;



@interface UIView (Loading)


// 透明挡板 需要手动执行消息
+ (void)showLoadingClearMask;

// 白色挡板 一般用于进入新界面时数据，需要手动执行消息
+ (void)showLoadingWhiteMask;

// 成功提示
+ (void)dismissLoading;
+ (void)dismissLoadingWithDelay:(NSTimeInterval)delay;
+ (void)dismissLoadingWithDelay:(NSTimeInterval)delay complete:(SYHUDDismissCompletion)block;

// 成功提示 会自动消失，默认一秒
+ (void)showSuceessMsg:(NSString*)msg;

+ (void)showSuceessMsg:(NSString*)msg showTime:(NSTimeInterval)time finish:(SYHUDDismissCompletion)block;

// 错误提示 会自动消失，默认2秒
+ (void)showErrorMsg:(NSString*)msg;

@end
