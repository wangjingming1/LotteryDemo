//
//  GlobalDefines.h
//  Lottery
//  为保持界面统一性,这里定义了一些默认值及通用宏
//  Created by wangjingming on 2020/1/1.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#ifndef GlobalDefines_h
#define GlobalDefines_h

/**重要提示，用于对代码中较重要的注释做标记，方便以后查找*/
#define kImportantReminder(x)

/**默认圆角*/
#define kCornerRadius           10
/**边距10*/
#define kPadding10              10
/**边距15*/
#define kPadding15              15
/**边距20*/
#define kPadding20              20

/**weakSelf*/
#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
 
/**获取Documents路径*/
#define kDocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

/**10进制的RGB*/
#define kUIColorFromRGB10(r,g,b)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
/**10进制的RGBA*/
#define kUIColorFromRGBA10(r,g,b,a)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
/**16进制的RGB*/
#define kUIColorFromRGB16(rgbValue)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**默认的分割线颜色*/
#define kDividingLineColor  kUIColorFromRGB10(193, 194, 195)

/**获取一个随机颜色*/
#define kUIColorFromRandomRBG               UIColorFromRGB10(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


/**系统默认字号*/
#define kSystemFontOfSize                   [UIFont systemFontSize]
/**小提示文字大小*/
#define kSubTipsFontOfSize                  12

//屏幕宽和高
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height


//默认的时间格式2020.01.01
#define kDefaultDateFormat     @"yyyy.MM.dd"

//本地化字符串
#define kLocalizedString(str)     str

#endif /* GlobalDefines_h */
