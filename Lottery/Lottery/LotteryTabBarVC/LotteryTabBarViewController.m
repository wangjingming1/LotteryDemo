//
//  LotteryTabbarViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "LotteryTabBarViewController.h"
#import "LotteryNavigationController.h"
#import "HomePageViewController.h"
#import "LotteryServiceViewController.h"
#import "MineViewController.h"
#import "GamesViewController.h"
#import "GlobalDefines.h"

@interface LotteryTabBarViewController ()
@property (nonatomic, strong)NSArray <Class>* classArray;
@end

@implementation LotteryTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabbar背景色
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    [self.tabBar setBackgroundColor:[UIColor commonBackgroundColor]];
//    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    
    //显示文字自定义颜色, 不被系统默认渲染
    self.tabBar.tintColor = UIColor.commonSelectedTintTextColor;//选中颜色
    self.tabBar.unselectedItemTintColor = UIColor.commonUnselectedTintTextColor;//默认颜色
    
    [self initTabbars];
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

- (void)initTabbars{
    self.classArray = @[
        [HomePageViewController class],
        [LotteryServiceViewController class],
        [GamesViewController class],
        [MineViewController class],
    ];
    
    for (Class class in self.classArray){
        BaseUIViewController *vc = [[class alloc] init];
        NSString *title = [self getTheDataINeed:@"title" class:class];
        NSString *imageName = [self getTheDataINeed:@"imageName" class:class];
        NSString *selectImageName = [self getTheDataINeed:@"selectImageName" class:class];
        [self setViewcontroller:vc title:title imageName:imageName selectImageName:selectImageName];
    }
}


- (NSString *)getTheDataINeed:(NSString *)type class:(Class)class{
    if ([class isEqual:[HomePageViewController class]]){
        if ([type isEqualToString:@"title"]){
            return @"首页";
        }
        if ([type isEqualToString:@"imageName"]){
            return @"shouye";
        }
        if ([type isEqualToString:@"selectImageName"]){
            return @"shouye_selected";
        }
    } else if ([class isEqual:[GamesViewController class]]){
        if ([type isEqualToString:@"title"]){
            return @"娱乐";
        }
        if ([type isEqualToString:@"imageName"]){
            return @"youxi";
        }
        if ([type isEqualToString:@"selectImageName"]){
            return @"youxi_selected";
        }
    } else if ([class isEqual:[LotteryServiceViewController class]]){
        if ([type isEqualToString:@"title"]){
            return @"开奖服务";
        }
        if ([type isEqualToString:@"imageName"]){
            return @"lotteryService";
        }
        if ([type isEqualToString:@"selectImageName"]){
            return @"lotteryService_selected";
        }
    } else if ([class isEqual:[MineViewController class]]){
        if ([type isEqualToString:@"title"]){
            return @"我的";
        }
        if ([type isEqualToString:@"imageName"]){
            return @"mine";
        }
        if ([type isEqualToString:@"selectImageName"]){
            return @"mine_selected";
        }
    }
    return @"";
}

- (void)setViewcontroller:(BaseUIViewController *)viewCollectionView title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName{
    static NSInteger index = 0;
    viewCollectionView.tabBarItem.title = title;
//    viewCollectionView.title = title;
    viewCollectionView.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    viewCollectionView.tabBarItem.tag = index;
    
    //设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
    viewCollectionView.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewCollectionView.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    LotteryNavigationController *nav = [[LotteryNavigationController alloc] initWithRootViewController:viewCollectionView];
    nav.navigationBar.barTintColor = UIColor.commonNavigationControllerBarTintColor;//[UIColor redColor];
    [self addChildViewController:nav];
    index++;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    for (LotteryNavigationController *navVC in self.viewControllers){
        if (![navVC isKindOfClass:[LotteryNavigationController class]]) continue;
        for (UIViewController *vc in navVC.viewControllers){
            if ([self.classArray indexOfObject:[vc class]] == NSNotFound) continue;
            NSString *imageName = [self getTheDataINeed:@"imageName" class:[vc class]];
            NSString *selectImageName = [self getTheDataINeed:@"selectImageName" class:[vc class]];
            vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
}
@end
