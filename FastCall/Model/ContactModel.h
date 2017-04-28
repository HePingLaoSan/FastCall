//
//  ContactModel.h
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject<NSCoding>


@property (strong, nonatomic) NSString *contact_id;

@property (strong, nonatomic) NSString *contact_name;

@property (strong, nonatomic) NSString *contact_email;

@property (strong, nonatomic) NSString *contact_phoneNumber;

@property (strong, nonatomic) NSData *contact_avatar;

@property (strong, nonatomic) NSData *contact_thumbnail;




@end
