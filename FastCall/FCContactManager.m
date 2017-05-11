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
#import "UIImage+Extension.h"

#define iOS10Above ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS9Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS8Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6Above  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
@implementation FCContactManager{
    UIViewController *hostViewController;
}

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

-(void)showContactUIInView:(id)viewcontroller{
    
    if (viewcontroller == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window)
        {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        viewcontroller = window.rootViewController;
        
    }
    hostViewController = viewcontroller;
    if (iOS9Above) {
        CNContactPickerViewController *vc = [[CNContactPickerViewController alloc]init];
        vc.delegate = self;

        [viewcontroller presentViewController:vc animated:YES completion:nil];
        
    }else{
        ABPeoplePickerNavigationController * vc = [[ABPeoplePickerNavigationController alloc] init];
        vc.peoplePickerDelegate = self;

        [viewcontroller presentViewController:vc animated:YES completion:nil];
        
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
    
}
// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
}

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if ([_delegate respondsToSelector:@selector(didCloseContactController:)]) {
        [_delegate didCloseContactController:hostViewController];
    }
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    if ([_delegate respondsToSelector:@selector(didCloseContactController:)]) {
        [_delegate didCloseContactController:hostViewController];
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
    if ([_delegate respondsToSelector:@selector(viewController:didSelectContact:)]) {
        [_delegate viewController:hostViewController didSelectContact:model];
    }
}

-(UIImage *)getResizedImageWithData:(NSData *)imageData{
    UIImage *orignalImage = [UIImage imageWithData:imageData];
    UIImage *resizeImage = [orignalImage clipWithImageRect:CGRectMake(0, 0, MIN(orignalImage.size.width, orignalImage.size.height), MIN(orignalImage.size.width, orignalImage.size.height)) clipImage:orignalImage];
    return resizeImage;
}

-(NSData *)getResizedImageData:(NSData *)imageData{
    UIImage *orignalImage = [UIImage imageWithData:imageData];
    UIImage *resizeImage = [orignalImage clipWithImageRect:CGRectMake(0, 0, MIN(orignalImage.size.width, orignalImage.size.height), MIN(orignalImage.size.width, orignalImage.size.height)) clipImage:orignalImage];
    return UIImagePNGRepresentation(resizeImage);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contact{

    NSMutableArray *resultArray = [NSMutableArray array];
    for (CNContact *eachContact in contact) {
        
        ContactModel *model = [[ContactModel alloc]init];
        model.contact_id = eachContact.identifier;
        model.contact_avatar = [self getResizedImageData:eachContact.imageData];
        model.contact_thumbnail = [self getResizedImageData:eachContact.thumbnailImageData];
        NSString *name = eachContact.givenName;
        if (eachContact.familyName.length>0) {
            name = [NSString stringWithFormat:@"%@%@",eachContact.familyName,eachContact.givenName];
        }
        model.contact_name = name;
        NSArray *phoneNums = eachContact.phoneNumbers;
        for (CNLabeledValue *labeledValue in phoneNums) {
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            model.contact_phoneNumber = phoneValue;
            if (phoneValue) {
                break;
            }
        }
        [resultArray addObject:model];
    }
    if ([_delegate respondsToSelector:@selector(viewController:didSelectContacts:)]) {
        [_delegate viewController:hostViewController didSelectContacts:resultArray];
    }
}



@end
