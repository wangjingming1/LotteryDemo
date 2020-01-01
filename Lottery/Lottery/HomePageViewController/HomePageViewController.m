//
//  HomePageViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "HomePageViewController.h"
#import "Masonry.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat navigationbarHeight = [self getNavigationbarHeight];
    CGFloat tabbarH = [self getTabbarHeight];
    UIView *v = [[UIView alloc] init];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor redColor];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(navigationbarHeight);
        make.bottom.mas_equalTo(-tabbarH);
    }];
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
