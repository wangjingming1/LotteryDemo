//
//  UIImageView+AddImage.m
//  Lottery
//
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "UIImageView+AddImage.h"
#import "UIImageView+AFNetworking.h"
#import "GlobalDefines.h"

@implementation UIImageView (AddImage)
- (void)setImageWithName:(NSString *)imageName{
    [self setImage:imageName placeholderImage:nil finish:nil];
}

- (void)setImageWithURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage{
    [self setImage:imageURL placeholderImage:placeholderImage finish:nil];
}

- (void)setImageWithURL:(NSString *)imageURL placeholderImage:(UIImage *)placeholderImage finish:(void (^)(UIImage *image, NSError *error))finish{
    [self setImage:imageURL placeholderImage:placeholderImage finish:finish];
}

- (void)setImage:(NSString *)imageName placeholderImage:(UIImage *)placeholderImage finish:(void (^)(UIImage *image, NSError *error))finish{
    if ([imageName hasPrefix:@"http"]){
        WS(weakSelf);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageName]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            weakSelf.image = image;
            if (finish) {
                finish(image, nil);
            }
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            if (finish) {
                finish(nil, error);
            }
        }];
    } else if ([imageName hasPrefix:kDocumentsPath]){
        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        if (image && finish) {
            finish(image, nil);
        } else if (finish) {
            NSError *error = [[NSError alloc] initWithDomain:NSFilePathErrorKey code:NSURLErrorCannotOpenFile userInfo:nil];
            finish(image, error);
        }
        self.image = image;
    } else {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image && finish){
            finish(image, nil);
        } else if (finish){
            NSError *error = [[NSError alloc] initWithDomain:@"NotFoundImage" code:NSURLErrorUnknown userInfo:nil];
            finish(image, error);
        }
        self.image = image;
    }
}
@end
