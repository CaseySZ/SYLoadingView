//
//  SYProgressHUD.m
//  SYLoadingView
//
//  Created by sy on 2018/5/4.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYProgressHUD.h"
#import "SVIndefiniteAnimatedView.h"

#define IsIphoneX_HUD ([UIScreen mainScreen].bounds.size.height == 812)

@interface SYProgressHUD (){
    
    NSBundle *_syHUDBundle;
}

@property (nonatomic, readonly)UIWindow *frontWindow;
@property (nonatomic, strong)UIView *backgroundView;

@property (nonatomic, strong)UIVisualEffectView *hudView;
@property (nonatomic, strong) UIView *indefiniteAnimatedView;


@end


@implementation SYProgressHUD

static SYProgressHUD* __shareView;

+ (SYProgressHUD*)sharedView{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shareView = [[SYProgressHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return __shareView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
       
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:@"SYHUD" withExtension:@"bundle"];
        if (url) {
            _syHUDBundle = [NSBundle bundleWithURL:url];
        }
        [self fadeOutAnimationAction];
        
    }
    return self;
}


- (void)setUserInteraction:(BOOL)userInteraction{
    
    self.userInteractionEnabled = userInteraction;
    self.backgroundView.userInteractionEnabled = userInteraction;
    self.whiteViewHUDBg.userInteractionEnabled = userInteraction;
}


- (void)updateViewHierarchy:(HUDStyle)style {
    
    UIView *containView = self.frontWindow;
    if (self.containView) {
        containView = self.containView;
        self.containView = nil;
    }
    
    if (!self.backgroundView.superview || self.backgroundView.superview != containView) {
        [self.backgroundView removeFromSuperview];
        [containView addSubview:self.backgroundView];
    }
    if (!self.whiteViewHUDBg.superview || self.whiteViewHUDBg.superview != containView) {
        [self.whiteViewHUDBg removeFromSuperview];
        [containView addSubview:self.whiteViewHUDBg];
    }
    
    if(!self.superview || self.superview != containView) {
        [self removeFromSuperview];
        [containView addSubview:self];
    }
    
    if (!self.hudView.superview) {
        [self addSubview:self.hudView];
    }
    
    self.userInteraction = YES;
    if (style == HUDStyleLoading) {
        [self.imageView removeFromSuperview];
        if (!self.indefiniteAnimatedView.superview) {
            [self.hudView.contentView addSubview:self.indefiniteAnimatedView];
        }
    }
    if (style == HUDStyleSuccessImply || style == HUDStyleErrorImply) {
       
        self.userInteraction = NO;
        [self.indefiniteAnimatedView removeFromSuperview];
        if (!self.imageView.superview) {
            [self.hudView.contentView addSubview:self.imageView];
        }
        
    }
    
    if (!self.statusLabel.superview) {
        [self.hudView.contentView addSubview:self.statusLabel];
    }
    
    
}

- (void)updateHUDFrame:(HUDStyle)style {
    
    self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (style == HUDStyleLoading) {
        // 加载状态
        [self LoadingStatusUI];
        
    }else if(style == HUDStyleSuccessImply){
        // 成功提示
        [self successStatusUI];
        
    }else if(style == HUDStyleErrorImply){
        // 错误提示
        [self errorStatusUI];
        
    }else{
        
    }
    
}


- (void)fadeInAnimationAction{

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.hudView.effect = blurEffect;
    self.hudView.backgroundColor = [self.backgroundColorForStyle colorWithAlphaComponent:0.6f];
    
    // Fade in views
    self.backgroundView.alpha = 1.0f;
    
    self.imageView.alpha = 1.0f;
    self.statusLabel.alpha = 1.0f;
    self.indefiniteAnimatedView.alpha = 1.0f;
    
}

- (void)fadeOutAnimationAction{
    
    self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3f, 1/1.3f);
    
    self.hudView.effect = nil;
    self.hudView.backgroundColor = [UIColor clearColor];
    self.backgroundView.alpha = 0.0f;
    self.imageView.alpha = 0.0f;
    self.statusLabel.alpha = 0.0f;
    self.indefiniteAnimatedView.alpha = 0.0f;
    
}

- (void)fadeOutOperation{
    
    if(self.backgroundView.alpha == 0.0f){
        
        [self.backgroundView removeFromSuperview];
        [self.hudView removeFromSuperview];
        [self.indefiniteAnimatedView removeFromSuperview];
        [self.whiteViewHUDBg removeFromSuperview];
        [self removeFromSuperview];
    }
}


#pragma mark - UI Status 不同状态的UI处理

// 加载状态
- (void)LoadingStatusUI{
    
    CGFloat maxHudWidth = 140;
    CGFloat maxHudHeight = 118;// 边距12 + 动画高度66 + 间距8 + 文本高度20 + 边距12
    
    CGFloat hudWidth = maxHudWidth;
    CGFloat hudHeight = maxHudHeight;
    
    CGFloat animationViewWidth = 120;
    CGFloat animationViewHeight = 66;
    
    self.hudView.frame = CGRectMake((self.frame.size.width-hudWidth)/2, (self.frame.size.height-hudHeight)/2, hudWidth, hudHeight);
    self.indefiniteAnimatedView.frame = CGRectMake((self.hudView.frame.size.width-animationViewWidth)/2, 12, animationViewWidth, animationViewHeight);
    self.statusLabel.frame = CGRectMake(16, CGRectGetMaxY(self.indefiniteAnimatedView.frame) + 8, self.hudView.frame.size.width-16*2, 20);
    
}

// 成功状态
- (void)successStatusUI{
    
    CGRect labelRect = CGRectZero;
    CGFloat labelHeight = 0.0f;
    CGFloat labelWidth = 0.0f;
    
    if(self.statusLabel.text) {
        CGSize constraintSize = CGSizeMake(300.0f, 300.0f);
        labelRect = [self.statusLabel.text boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.statusLabel.font}
                                                        context:NULL];
        labelHeight = ceilf(CGRectGetHeight(labelRect));
        labelWidth = ceilf(CGRectGetWidth(labelRect));
    }
    
    CGFloat normalWidth = 140;
    CGFloat normalHeight = 118;
    CGFloat maxHudWidth = self.frame.size.width - 64*2;
    
    CGFloat hudWidth = labelWidth + 16;//maxHudWidth;
    if (hudWidth < normalWidth) {
        hudWidth = normalWidth;
    }
    if (hudWidth > maxHudWidth) {
        hudWidth = maxHudWidth;
    }
    CGFloat hudHeight = normalHeight;
    
    
    CGFloat imageWidth = 36;
    CGFloat imageHeight = 36;
    
    self.hudView.frame = CGRectMake((self.frame.size.width-hudWidth)/2, (self.frame.size.height-hudHeight)/2, hudWidth, hudHeight);
    self.imageView.frame = CGRectMake((self.hudView.frame.size.width-imageWidth)/2, 22, imageWidth, imageHeight);
   
    self.statusLabel.frame = CGRectMake(8, CGRectGetMaxY(self.imageView.frame) + 15, self.hudView.frame.size.width-8*2, 20);
    
    
}

// 错误状态
- (void)errorStatusUI{
 
    CGRect labelRect = CGRectZero;
    CGFloat labelHeight = 0.0f;
    CGFloat labelWidth = 0.0f;
    
    if(self.statusLabel.text) {
        CGSize constraintSize = CGSizeMake(300.0f, 300.0f);
        labelRect = [self.statusLabel.text boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.statusLabel.font}
                                                        context:NULL];
        labelHeight = ceilf(CGRectGetHeight(labelRect));
        labelWidth = ceilf(CGRectGetWidth(labelRect));
    }
    
    CGFloat normalHeight = 38;
    CGFloat maxHudWidth = self.frame.size.width - 28*2;
    
    //边界16 + 图片宽度14 + 间距8 + 文本宽度 + 边界
    CGFloat hudWidth =  16 + 14 + 8 + labelWidth + 16;

    if (hudWidth > maxHudWidth) {
        hudWidth = maxHudWidth;
        labelWidth = hudWidth - 16 - 14 - 8 - 16;
    }
    CGFloat hudHeight = normalHeight;
    
    CGFloat imageWidth = 14;
    CGFloat imageHeight = 14;
    
    self.hudView.frame = CGRectMake((self.frame.size.width-hudWidth)/2, (self.frame.size.height-hudHeight)/2, hudWidth, hudHeight);
    self.imageView.frame = CGRectMake(16, (hudHeight-14)/2, imageWidth, imageHeight);
    
    self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 8, 0, labelWidth, hudHeight);
    
}



#pragma mark - lazy loading

- (UIView*)backgroundView{
    
    if(!_backgroundView){
        _backgroundView = [UIView new];
    }
    return _backgroundView;
}

- (UIWindow *)frontWindow {

    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}

- (UIVisualEffectView*)hudView {
    if(!_hudView) {
        _hudView = [UIVisualEffectView new];
        _hudView.layer.masksToBounds = YES;
        _hudView.layer.cornerRadius = 4;
    }
    return _hudView;
}

- (UILabel*)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:15];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        //_statusLabel.numberOfLines = 0;
        _statusLabel.textColor = self.foregroundColorForStyle;
    }
    return _statusLabel;
}

- (UIImageView*)imageView {
 

    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0, 0)];
    }
    if(!_imageView.superview) {
        [self.hudView.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

// 动画view
- (UIView*)indefiniteAnimatedView {
    
    
    if(!_indefiniteAnimatedView){
        _indefiniteAnimatedView = [[SVIndefiniteAnimatedView alloc] initWithFrame:CGRectZero];
    }
    
    // Update styling
    SVIndefiniteAnimatedView *indefiniteAnimatedView = (SVIndefiniteAnimatedView*)_indefiniteAnimatedView;
    indefiniteAnimatedView.strokeColor = self.foregroundColorForStyle;
    indefiniteAnimatedView.strokeThickness = 4.0f;
    indefiniteAnimatedView.radius = 26.0f;
  
    return _indefiniteAnimatedView;
}

- (UIView*)whiteViewHUDBg{
    if (!_whiteViewHUDBg) {
        
        CGFloat navHeight = 64;
        if (IsIphoneX_HUD) {
            navHeight = 88;
        }
        _whiteViewHUDBg = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-navHeight)];
    }
    return _whiteViewHUDBg;
}

- (UIImage*)successImage{
    
    if (_successImage) {
        return _successImage;
    }
    NSBundle *bundle = [NSBundle bundleForClass:[SYProgressHUD class]];
    NSURL *url = [bundle URLForResource:@"SYHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = nil;
    if (url) {
        imageBundle = [NSBundle bundleWithURL:url];
    }
    
    _successImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"success" ofType:@"png"]];
    _errorImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"error" ofType:@"png"]];
    
    return _successImage;
    
}

- (UIImage*)errorImage{
    
    if (_errorImage) {
        return _errorImage;
    }
    NSBundle *bundle = [NSBundle bundleForClass:[SYProgressHUD class]];
    NSURL *url = [bundle URLForResource:@"SYHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = nil;
    if (url) {
        imageBundle = [NSBundle bundleWithURL:url];
    }
    
    
    _successImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"success" ofType:@"png"]];
    _errorImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"error" ofType:@"png"]];
    
    return _errorImage;
}


- (UIColor*)foregroundColorForStyle{
    
    return [UIColor whiteColor];
    
}

- (UIColor*)backgroundColorForStyle {
    
    return [UIColor blackColor];
}

@end
