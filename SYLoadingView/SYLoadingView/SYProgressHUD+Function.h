//
//  SYProgressHUD+Function.h
//  SYLoadingView
//
//  Created by sy on 2018/5/4.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYProgressHUD.h"

@interface SYProgressHUD (Function)

- (void)showWithLoadStatus:(NSString*)status;
- (void)showWithLoadInWhiteBG:(NSString*)status;

- (void)showWithLoadStatus:(NSString*)status InView:(UIView*)view;

- (void)showWithSuccessStatus:(NSString*)status;
- (void)showWithSuccessStatus:(NSString*)status showTime:(NSTimeInterval)time;
- (void)showWithSuccessStatus:(NSString*)status showTime:(NSTimeInterval)time finish:(SYHUDDismissCompletion)block;

- (void)showErrorStatus:(NSString*)errorMsg;

- (void)dismiss;
- (void)dismissLoadingWithDelay:(NSTimeInterval)delay complete:(SYHUDDismissCompletion)block;


@end
