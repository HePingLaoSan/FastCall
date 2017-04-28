//
//  FCDataManager.h
//  FastCall
//
//  Created by zhangyingjie on 2017/4/28.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactModel;

@interface FCDataManager : NSObject

@property (nonatomic , strong) NSMutableArray *dataSourcesArray;


-(void)deleteItemAtIndexPath:(NSInteger)indexPath;

@end
