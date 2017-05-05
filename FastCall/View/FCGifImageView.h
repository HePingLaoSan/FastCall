//
//  FCGifImageView.h
//  FastCall
//
//  Created by zhangyingjie on 2017/5/4.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCGifImageView : UIImageView
{
    NSMutableArray *currentImagesArray;
}


-(void)configGif;

-(void)startPlayImages;

-(void)stopPlayingImages;

@end
