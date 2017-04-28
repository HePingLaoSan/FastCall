//
//  FCDataManager.m
//  FastCall
//
//  Created by zhangyingjie on 2017/4/28.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCDataManager.h"
#import "ContactModel.h"

@implementation FCDataManager


-(instancetype)init{
    self = [super init];
    
    NSData *dataLocal = [[[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.FastTool"] objectForKey:@"localData"];
    NSArray *contactsLocal = [NSKeyedUnarchiver unarchiveObjectWithData:dataLocal];
    if (contactsLocal==nil) {
        _dataSourcesArray = [@[] mutableCopy];
    }else{
        _dataSourcesArray = [contactsLocal mutableCopy];
    }
    
    
    
    return self;
}

-(void)deleteItemFromDisk:(ContactModel *)model{
    
    
    
    
    
}

-(void)deleteItemAtIndexPath:(NSInteger)indexPath{
    
    if (_dataSourcesArray.count >indexPath) {
        [self.dataSourcesArray removeObjectAtIndex:indexPath];
        NSData *storeData = [NSKeyedArchiver archivedDataWithRootObject:self.dataSourcesArray];
        NSUserDefaults *userDef = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.FastTool"];
        [userDef setObject:storeData forKey:@"localData"];
        [userDef synchronize];
    }

}

@end
