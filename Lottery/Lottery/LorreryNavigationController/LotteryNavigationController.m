//
//  LotteryNavigationController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/1.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryNavigationController.h"
#import "UINavigationController+Cloudox.h"

@interface LotteryNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation LotteryNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //代理方法由分类实现UINavigationController+Cloudox
    self.delegate = self;
    //避免使用自定义leftBarButtonItem后, 侧滑手势失效
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
