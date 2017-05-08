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
    
    for (int i=0; i < 5; i++){
        NSString *imageName = [NSString stringWithFormat:@"intro_%d",i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        [currentImagesArray addObject:image];//将图片加入数组中
    }
    self.image = [currentImagesArray firstObject];
}

-(void)startPlayImages{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(switchImage) userInfo:nil repeats:YES];
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
