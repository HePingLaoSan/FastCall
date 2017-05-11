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
    
    [self refresh];
    
    return self;
}


-(void)saveToDisk{
    NSData *storeData = [NSKeyedArchiver archivedDataWithRootObject:self.dataSourcesArray];
    NSUserDefaults *userDef = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"];
    [userDef setObject:storeData forKey:@"localData"];
    [userDef synchronize];
}

-(void)deleteItemAtIndexPath:(NSInteger)indexPath{
    
    if (_dataSourcesArray.count >indexPath) {
        [self.dataSourcesArray removeObjectAtIndex:indexPath];
        [self saveToDisk];
    }
}

-(void)moveItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    ContactModel *model = self.dataSourcesArray[fromIndex];
    [self.dataSourcesArray removeObject:model];
    [self.dataSourcesArray insertObject:model atIndex:toIndex];
    [self saveToDisk];
}

-(BOOL)isFirstTimeAddingContact{
    NSUserDefaults *userDef = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"];
    NSNumber *isFirstTimeAddingContact = [userDef objectForKey:@"isFirstTimeAddingContact"];
    return [isFirstTimeAddingContact boolValue];
}

-(void)completeAddingGuide{
    NSUserDefaults *userDef = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"];
    [userDef setObject:@YES forKey:@"isFirstTimeAddingContact"];
    [userDef synchronize];
}

-(void)refresh{
    NSData *dataLocal = [[[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"] objectForKey:@"localData"];
    NSArray *contactsLocal = [NSKeyedUnarchiver unarchiveObjectWithData:dataLocal];
    if (contactsLocal==nil) {
        _dataSourcesArray = [@[] mutableCopy];
    }else{
        _dataSourcesArray = [contactsLocal mutableCopy];
    }
}
@end
