//
//  ViewController.m
//  SYLoadingView
//
//  Created by sy on 2018/5/4.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Loading.h"

@interface ViewController (){
    
    IBOutlet UIButton *_button;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [_button removeFromSuperview];
    
    [self.navigationController.navigationBar addSubview:_button];
    
}

- (IBAction)pressButton:(id)sender{
    
    static int test = 0;
    test++;
    int random = test%3;
    if (random == 0) {
        
        [UIView showLoadingWhiteMask];
        
        
        
    }else if (random == 1) {
        //        [SYProgressHUD showWithSuccessStatus:@"评论成功" showTime:2 finish:^{
        //            NSLog(@"finish_One");
        //        }];
        //        NSLog(@"dismiss");
        //        [SYProgressHUD dismissLoadingWithDelay:2 complete:^{
        //            NSLog(@"dismissBlock");
        //        }];
        [UIView showLoadingClearMask];
        
    }else{
        //[UIView showErrorMsg:@"评论失败评论失败评论失"];
        
        [UIView showSuceessMsg:@"评论chengong" showTime:2 finish:^{
            NSLog(@"test");
        }];
    }
    
    //    [SYProgressHUD showWithSuccessStatus:@"评论成功" showTime:2 finish:^{
    //        NSLog(@"finish");
    //    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"touchBegan");
    
}



@end
