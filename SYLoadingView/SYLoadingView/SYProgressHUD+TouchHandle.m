//
//  SYProgressHUD+TouchHandle.m
//  SYLoadingView
//
//  Created by sy on 2018/5/15.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYProgressHUD+TouchHandle.h"

@implementation SYProgressHUD (TouchHandle)

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGFloat navHeight = 64;
    if ([UIScreen mainScreen].bounds.size.height == 812) { // iphoneX
        navHeight = 88;
    }
    if (CGRectContainsPoint(CGRectMake(0, 0, 40, navHeight), point)) {
        UIViewController *viewCtr = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        if ([viewCtr isKindOfClass:[UINavigationController class]]) {
            return [viewCtr.view hitTest:point withEvent:event];
        }else if ([viewCtr isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabarVC = (UITabBarController*)viewCtr;
            UIViewController *selectVC = tabarVC.selectedViewController;
            if ([selectVC isKindOfClass:[UINavigationController class]]) {
                return [selectVC.view hitTest:point withEvent:event];
            }else{
                return [selectVC.navigationController.view hitTest:point withEvent:event];
            }
            
        }
        else{
            return [viewCtr.navigationController.view hitTest:point withEvent:event];
        }
    }
    return [super hitTest:point withEvent:event];
}


@end
