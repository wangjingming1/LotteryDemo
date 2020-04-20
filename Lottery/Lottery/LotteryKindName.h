//
//  LotteryKindName.h
//  Lottery
//
//  Created by wangjingming on 2020/2/26.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#ifndef LotteryKindName_h
#define LotteryKindName_h

#define kLotteryIdentifier_daletou        @"daletou"
#define kLotteryIdentifier_shuangseqiu    @"shuangseqiu"
#define kLotteryIdentifier_fucai3d        @"fucai3d"
#define kLotteryIdentifier_pailie3        @"pailie3"
#define kLotteryIdentifier_pailie5        @"pailie5"
#define kLotteryIdentifier_qixingcai      @"qixingcai"
#define kLotteryIdentifier_qilecai        @"qilecai"

#define kLotteryIsDaletou(identifier)       [identifier isEqualToString:kLotteryIdentifier_daletou]
#define kLotteryIsShuangseqiu(identifier)   [identifier isEqualToString:kLotteryIdentifier_shuangseqiu]
#define kLotteryIsFucai3d(identifier)       [identifier isEqualToString:kLotteryIdentifier_fucai3d]
#define kLotteryIsPailie3(identifier)       [identifier isEqualToString:kLotteryIdentifier_pailie3]
#define kLotteryIsPailie5(identifier)       [identifier isEqualToString:kLotteryIdentifier_pailie5]
#define kLotteryIsQixingcai(identifier)     [identifier isEqualToString:kLotteryIdentifier_qixingcai]
#define kLotteryIsQilecai(identifier)       [identifier isEqualToString:kLotteryIdentifier_qilecai]

#endif /* LotteryKindName_h */
