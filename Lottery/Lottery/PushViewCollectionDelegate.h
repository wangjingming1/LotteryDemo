//
//  PushViewCollectionDelegate.h
//  Lottery
//
//  Created by wangjingming on 2020/2/28.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PushViewCollectionDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
