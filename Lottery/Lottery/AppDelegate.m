//
//  AppDelegate.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalDefines.h"
#import "LotteryTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)createFiles{
    [self homePageCreateFiles];
}

- (void)homePageCreateFiles{
    //轮播图片文件夹
    NSLog(@"%@", kDocumentsPath);
    NSString *documentsPath = kDocumentsPath;
    NSString *bannerPath = [NSString stringWithFormat:@"%@/homePage/banner/", documentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:bannerPath isDirectory:&isDir];
    if (!isDir && !existed) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:bannerPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self createFiles];
    if(@available(iOS 13, *)){
        
    } else {
//        self.window.backgroundColor = UIColor.commonBackgroundColor;// [UIColor whiteColor];
        self.window.rootViewController = [[LotteryTabBarViewController alloc] initWithNibName:@"LotteryTabBarViewController" bundle:nil];
    }
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
