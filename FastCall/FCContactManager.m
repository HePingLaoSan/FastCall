//
//  FCContactManager.m
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import "FCContactManager.h"
#import <UIKit/UIKit.h>
#import <FCContactModel/FCContactModel.h>
//#import "ContactModel.h"

#define iOS10Above ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS9Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS8Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
@implementation FCContactManager

static FCContactManager *contactManager = nil;

+(instancetype)sharedInstance{
    if (contactManager==nil) {
        contactManager = [[FCContactManager alloc]init];
        contactManager->authorizationState = NO;
    }
    return contactManager;
}

-(void)checkAuth{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status != CNAuthorizationStatusAuthorized) {
        authorizationState = YES;
    }else{
        authorizationState = NO;
    }
}

-(void)fetchContactData{
    
}

-(void)showContactUI{
//    if (!authorizationState)return;
    
    if (iOS9Above) {
        CNContactPickerViewController *vc = [[CNContactPickerViewController alloc]init];
        vc.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [window.rootViewController presentViewController:vc animated:YES completion:nil];
    }else{
        ABPeoplePickerNavigationController * vc = [[ABPeoplePickerNavigationController alloc] init];
        vc.peoplePickerDelegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [window.rootViewController presentViewController:vc animated:YES completion:nil];
        
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    
}
// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
}
// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if ([_delegate respondsToSelector:@selector(didCloseContactController)]) {
        [_delegate didCloseContactController];
    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    if ([_delegate respondsToSelector:@selector(didCloseContactController)]) {
        [_delegate didCloseContactController];
    }
}
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    ContactModel *model = [[ContactModel alloc]init];
    model.contact_id = contact.identifier;
    model.contact_avatar = contact.imageData;
    model.contact_thumbnail = contact.thumbnailImageData;
    NSString *name = contact.givenName;
    if (contact.familyName.length>0) {
        name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    }
    model.contact_name = name;
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        model.contact_phoneNumber = phoneValue;
        if (phoneValue) {
            break;
        }
    }
    if ([_delegate respondsToSelector:@selector(didSelectContact:)]) {
        [_delegate didSelectContact:model];
    }
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
}



@end