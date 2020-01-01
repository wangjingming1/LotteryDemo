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
#import "NewsViewController.h"
#import "MineViewController.h"


@interface LotteryTabBarViewController ()

@end

@implementation LotteryTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabbar颜色
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
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
    NSArray <Class>* classArray = @[
        [HomePageViewController class],
        [NewsViewController class],
        [MineViewController class],
    ];
    
    for (Class class in classArray){
        UIViewController *vc = [[class alloc] init];
        NSString *title = [self getTheDataINeed:@"title" class:class];
        NSString *imageName = [self getTheDataINeed:@"imageName" class:class];
        NSString *selectImageName = [self getTheDataINeed:@"selectImageName" class:class];
        [self setViewcontroller:vc title:title imageName:imageName selectImageName:selectImageName];
    }
}


- (NSString *)getTheDataINeed:(NSString *)type class:(Class)class{
    if ([class isEqual:[HomePageViewController class]]){
        if ([type isEqualToString:@"title"]){
            return @"主页";
        }
        if ([type isEqualToString:@"imageName"]){
            return @"shouye";
        }
        if ([type isEqualToString:@"selectImageName"]){
            return @"shouye_selected";
        }
    } else if ([class isEqual:[NewsViewController class]]){
        if ([type isEqualToString:@"title"]){
                   return @"资讯";
               }
               if ([type isEqualToString:@"imageName"]){
                   return @"news";
               }
               if ([type isEqualToString:@"selectImageName"]){
                   return @"news_selected";
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

- (void)setViewcontroller:(UIViewController *)viewCollectionView title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName{
    static NSInteger index = 0;
    viewCollectionView.tabBarItem.title = title;
    viewCollectionView.title = title;
    viewCollectionView.tabBarItem.image = [UIImage imageNamed:imageName];
    viewCollectionView.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    viewCollectionView.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    viewCollectionView.tabBarItem.tag = index;
    
    LotteryNavigationController *nav = [[LotteryNavigationController alloc] initWithRootViewController:viewCollectionView];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    [self addChildViewController:nav];
    index++;
}
@end
