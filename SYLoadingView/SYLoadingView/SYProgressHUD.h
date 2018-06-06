//
//  SYProgressHUD.h
//  SYLoadingView
//
//  Created by sy on 2018/5/4.
//  Copyright © 2018年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HUDStyleLoading = 1,
    HUDStyleSuccessImply,
    HUDStyleErrorImply,
} HUDStyle;


typedef void (^SYHUDDismissCompletion)(void);

@interface SYProgressHUD : UIView


//containView默认是window上
@property (nonatomic, strong)UIView *containView;
@property (nonatomic, assign)BOOL userInteraction;

@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIView *whiteViewHUDBg;


@property (nonatomic, strong) UIImage *errorImage;
@property (nonatomic, strong) UIImage *successImage;
@property (nonatomic, strong) UIImage *infoImage;


@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, strong) SYHUDDismissCompletion finishBlock;


+ (SYProgressHUD*)sharedView;

- (void)updateViewHierarchy:(HUDStyle)style;
- (void)updateHUDFrame:(HUDStyle)style;


- (void)fadeInAnimationAction;
- (void)fadeOutAnimationAction;
- (void)fadeOutOperation;

@end
