//
//  FCCollectionLayout.h
//  FastCall
//
//  Created by zhangyingjie on 2017/4/28.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCCollectionLayoutDelegate <NSObject>

/**
 * 改变编辑状态
 */
- (void)didChangeEditState:(BOOL)inEditState;

/**
 * 更新数据源
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end


@interface FCCollectionLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, weak) id<FCCollectionLayoutDelegate> delegate;

@end
