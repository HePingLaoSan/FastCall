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

static NSTimer *timer = nil;


-(void)configGif{
    currentImagesArray = [NSMutableArray array];
    self.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Intro" withExtension:@"gif"];//加载GIF图片
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
    size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
    for (size_t i=0; i < frameCout; i++){
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
        UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
        [currentImagesArray addObject:imageName];//将图片加入数组中
        CGImageRelease(imageRef);
    }
    self.image = [currentImagesArray firstObject];
}

-(void)startPlayImages{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
    }
    [timer fire];
}

-(void)stopPlayingImages{
    [timer invalidate];
}

-(void)dealloc{
    timer = nil;
}

-(void)switchImage{
    UIImage *currentImage = self.image;
    NSUInteger index = [currentImagesArray indexOfObject:currentImage];
    index = (index + 1) % [currentImagesArray count];
    
    [UIView transitionWithView:self duration:3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.image = currentImagesArray[index];
    } completion:nil];
}

@end
