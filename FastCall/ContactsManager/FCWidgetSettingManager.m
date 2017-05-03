//
//  FCWidgetSettingManager.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/3.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCWidgetSettingManager.h"

@implementation FCWidgetSettingManager


+(BOOL)checkWidgetInstalled{
    NSUserDefaults *userDef = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"];
    NSNumber *isInstalled = [userDef objectForKey:@"isInstalledExt"];
    if ([isInstalled boolValue]) {
        return YES;
    }
    return NO;
}


@end
