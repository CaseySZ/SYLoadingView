//
//  UIView+Loading.m
//  XPSPlatform
//
//  Created by sy on 2017/11/16.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "UIView+Loading.h"
#import "SYProgressHUD+Function.h"


@interface UIView ()


@end

@implementation UIView (Loading)


+ (void)showLoadingClearMask{
    
    [[SYProgressHUD sharedView] showWithLoadStatus:@"加载中"];
    
}

+ (void)showLoadingWhiteMask{
    
    [[SYProgressHUD sharedView] showWithLoadInWhiteBG:@"加载中"];
}

// 状态提示
+ (void)showInfoWithStatus:(NSString*)msg{
    
    [[SYProgressHUD sharedView] showErrorStatus:msg];
    
}

+ (void)showSuceessMsg:(NSString*)msg{
  
    [[SYProgressHUD sharedView] showWithSuccessStatus:msg];

}

+ (void)showSuceessMsg:(NSString*)msg showTime:(NSTimeInterval)time{
    
    [self showSuceessMsg:msg showTime:time finish:nil];
   
}


+ (void)showSuceessMsg:(NSString*)msg showTime:(NSTimeInterval)time finish:(SYHUDDismissCompletion)block{
    
   [[SYProgressHUD  sharedView] showWithSuccessStatus:msg showTime:time finish:block];
}

+ (void)showErrorMsg:(NSString*)msg{
    
    [[SYProgressHUD sharedView] showErrorStatus:msg];
}

+ (void)dismissLoading{
  
    [self dismissLoadingWithDelay:0];
}

+ (void)dismissLoadingWithDelay:(NSTimeInterval)delay{
    
    [self dismissLoadingWithDelay:delay complete:nil];
}

+ (void)dismissLoadingWithDelay:(NSTimeInterval)delay complete:(SYHUDDismissCompletion)block {
   
    [[SYProgressHUD sharedView] dismissLoadingWithDelay:delay complete:block];
}

@end
