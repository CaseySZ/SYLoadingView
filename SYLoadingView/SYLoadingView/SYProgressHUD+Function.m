//
//  SYProgressHUD+Function.m
//  SYLoadingView
//
//  Created by sy on 2018/5/4.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYProgressHUD+Function.h"

static NSInteger successDefaultDuration = 1.5;
static NSInteger errorDefaultDuration = 2;

@implementation SYProgressHUD (Function)

#pragma mark - show loading

- (void)showWithLoadStatus:(NSString*)status{
    
    self.whiteViewHUDBg.backgroundColor = [UIColor clearColor];
    [self showImage:nil status:status duration:0 finish:nil];
}

- (void)showWithLoadInWhiteBG:(NSString*)status{
    
    self.whiteViewHUDBg.backgroundColor = [UIColor whiteColor];
    [self showImage:nil status:status duration:0 finish:nil];
}

- (void)showWithLoadStatus:(NSString*)status InView:(UIView*)view{
    
    self.whiteViewHUDBg.backgroundColor = [UIColor clearColor];
    self.containView = view;
    [self showImage:nil status:status duration:0 finish:nil];
    
}

#pragma mark - show success

- (void)showWithSuccessStatus:(NSString*)status{
    
    [self showWithSuccessStatus:status showTime:successDefaultDuration];
    
}

- (void)showWithSuccessStatus:(NSString*)status showTime:(NSTimeInterval)time{
    
    [self showWithSuccessStatus:status showTime:time finish:nil];
}

- (void)showWithSuccessStatus:(NSString*)status showTime:(NSTimeInterval)time finish:(SYHUDDismissCompletion)block{
    
    [self showImage:self.successImage status:status duration:time finish:block];
}


#pragma mark - show error
- (void)showErrorStatus:(NSString*)errorMsg{
    
    [self showImage:self.errorImage status:errorMsg duration:errorDefaultDuration finish:nil];
    
}


#pragma mark -  core

- (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration finish:(SYHUDDismissCompletion)block{
    
    
    self.imageView.image = image;
    self.statusLabel.text = status;
    
    HUDStyle style = HUDStyleLoading;
    if ([image isEqual:[SYProgressHUD sharedView].successImage]) {
        style = HUDStyleSuccessImply;
        self.whiteViewHUDBg.backgroundColor = [UIColor clearColor];
    }
    if ([image isEqual:[SYProgressHUD sharedView].errorImage]) {
        style = HUDStyleErrorImply;
        self.whiteViewHUDBg.backgroundColor = [UIColor clearColor];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateViewHierarchy:style];
        [self updateHUDFrame:style];
        
        [UIView animateWithDuration:0.15 animations:^{
            [self fadeInAnimationAction];
        } completion:^(BOOL finished) {
            
        }];
        
    });
    
    [self cleanTimer];
    if (duration > 0) {
        
        [self startTimer:duration block:block];
        
    }
    
}

- (void)startTimer:(NSTimeInterval)duration block:(SYHUDDismissCompletion)block{
    
    [self cleanTimer];
    
    self.fadeOutTimer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(exeTimerDelayOperation) userInfo:nil repeats:NO];
    self.finishBlock = block;
    [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
}

- (void)exeTimerDelayOperation{
    
    SYHUDDismissCompletion block = self.finishBlock;
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    self.finishBlock = nil;
    
    [self dismissDelay:0 finishBlock:block];
    
}

- (void)cleanTimer{
    
    if (self.fadeOutTimer) {
        
        [self.fadeOutTimer invalidate];
        self.fadeOutTimer = nil;
        if (self.finishBlock) {
            self.finishBlock();
            self.finishBlock = nil;
        }
    }
}



#pragma mark - dismiss

- (void)dismiss{
    
    [self dismissDelay:0 finishBlock:nil];
    
}


- (void)dismissWithBlock:(SYHUDDismissCompletion)block{
    
    [self dismissDelay:0 finishBlock:block];
    
}

- (void)dismissDelay:(NSTimeInterval)duration finishBlock:(SYHUDDismissCompletion)block{
    
    if (duration > 0) {
        
        [self startTimer:duration block:block];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.15 animations:^{
                
                [self fadeOutAnimationAction];
                
            } completion:^(BOOL finished) {
                
                [self fadeOutOperation];
                if (block) {
                    block();
                }
            }];
        });
    }
}





@end
