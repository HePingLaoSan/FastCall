//
//  FCContactManager.h
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@class ContactModel;

@protocol FCContactManagerDelegate <NSObject>

@optional
-(void)didSelectContact:(ContactModel *)contactModel;

-(void)didCloseContactController;

@end

@interface FCContactManager : NSObject<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>
{
    BOOL authorizationState;
}

+(instancetype)sharedInstance;

@property (weak, nonatomic) id<FCContactManagerDelegate>delegate;

-(void)checkAuth;

-(void)fetchContactData;

-(void)showContactUI;
@end
