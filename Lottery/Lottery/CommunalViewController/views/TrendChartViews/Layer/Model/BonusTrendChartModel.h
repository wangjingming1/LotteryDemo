//
//  BonusTrendChartModel.h
//  Lottery
//
//  Created by wangjingming on 2020/3/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class UIColor;

@interface BonusTrendChartDataModel : NSObject
@property (nonatomic, copy) NSString *footnote;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *unit;
@end

@interface BonusTrendChartModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *footnote;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIColor *footNoteColor;
@property (nonatomic) UIColor *nodeColor;
@property (nonatomic) UIColor *lineColor;

@property (nonatomic, strong) NSArray <BonusTrendChartDataModel *> * trendChartDataModelArray;
@end

NS_ASSUME_NONNULL_END
