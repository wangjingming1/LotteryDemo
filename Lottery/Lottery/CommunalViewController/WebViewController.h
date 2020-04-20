//
//  WebViewController.h
//  Lottery
//  web展示页
//  Created by wangjingming on 2020/1/11.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : BaseUIViewController
@property (nonatomic, copy) NSString *urlStr;

- (void)reloadWebView;
@end

NS_ASSUME_NONNULL_END
