//
//  UIImageView+AddImage.h
//  Lottery
//
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (AddImage)
- (void)setImageWithName:(NSString *)imageName;
- (void)setImageWithURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage;
- (void)setImageWithURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage finish:(void (^)(UIImage *image, NSError *error))finish;
@end

NS_ASSUME_NONNULL_END
