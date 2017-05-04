//
//  FCGifImageView.m
//  FastCall
//
//  Created by zhangyingjie on 2017/5/4.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCGifImageView.h"
#import <ImageIO/ImageIO.h>
@implementation FCGifImageView


-(void)configGif{
    self.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Intro" withExtension:@"gif"];//加载GIF图片
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
    size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
    NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
    for (size_t i=0; i < frameCout; i++){
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
        UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];//将图片加入数组中
        CGImageRelease(imageRef);
    }
    self.animationImages=frames;//将图片数组加入UIImageView动画数组中
    self.animationDuration=10;//每次动画时长

}

@end
