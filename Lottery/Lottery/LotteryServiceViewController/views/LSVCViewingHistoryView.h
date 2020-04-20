//
//  LSVCViewingHistoryView.h
//  Lottery
//
//  Created by wangjingming on 2020/3/16.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSVCViewingHistoryView : UIView
@property (nonatomic, copy)void(^selectOneLottery)(NSString *identifier);
- (void)setViewingHistory:(NSArray <NSString *> *) identifierArray;
@end

NS_ASSUME_NONNULL_END
