//
//  BaseUIViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BaseUIViewController ()

@end

@implementation BaseUIViewController

- (CGFloat)getStatusbarHeight{
    //状态栏高度
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)getNavigationbarHeight{
    //导航栏高度+状态栏高度
    CGFloat statusBarH = [self getStatusbarHeight];
    return self.navigationController.navigationBar.frame.size.height + statusBarH;
}

- (CGFloat)getTabbarHeight{
    //Tabbar高度
    return self.tabBarController.tabBar.bounds.size.height;
}

@end
