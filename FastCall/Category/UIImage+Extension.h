//
//  UIImage+Extension.h
//  FastCall
//
//  Created by zhangyingjie on 2017/5/11.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


+ (NSData *)zipImageWithImage:(UIImage *)image;


+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth;

- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

@end
