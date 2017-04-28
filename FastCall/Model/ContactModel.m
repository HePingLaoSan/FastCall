//
//  ContactModel.m
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_contact_id forKey:@"contact_id"];
    [aCoder encodeObject:_contact_name forKey:@"contact_name"];
    [aCoder encodeObject:_contact_email forKey:@"contact_email"];
    [aCoder encodeObject:_contact_phoneNumber forKey:@"contact_phoneNumber"];
    [aCoder encodeObject:_contact_avatar forKey:@"contact_avatar"];
    [aCoder encodeObject:_contact_thumbnail forKey:@"contact_thumbnail"];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    _contact_id = [aDecoder decodeObjectForKey:@"contact_id"];
    _contact_name = [aDecoder decodeObjectForKey:@"contact_name"];
    _contact_email = [aDecoder decodeObjectForKey:@"contact_email"];
    _contact_phoneNumber = [aDecoder decodeObjectForKey:@"contact_phoneNumber"];
    _contact_avatar = [aDecoder decodeObjectForKey:@"contact_avatar"];
    _contact_thumbnail = [aDecoder decodeObjectForKey:@"contact_thumbnail"];
    return self;
}

@end
