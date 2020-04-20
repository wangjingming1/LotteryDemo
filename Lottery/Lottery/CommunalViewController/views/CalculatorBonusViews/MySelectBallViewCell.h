//
//  MySelectBallViewCell.h
//  Lottery
//
//  Created by wangjingming on 2020/3/13.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LotteryWinningModel;

@interface MySelectBallViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *title;
+ (NSString *)redCellIdentifier;
+ (NSString *)blueCellIdentifier;
@end

NS_ASSUME_NONNULL_END
