//
//  FCContactCreationViewController.m
//  FastCall
//
//  Created by 和平老三 on 2017/5/8.
//  Copyright © 2017年 zhangyingjie. All rights reserved.
//

#import "FCContactCreationViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "FCContactCreationHeaderView.h"
#import "FCContactCreationCell.h"
#import "FCDataManager.h"
#import "NSString+Extension.h"
#import "UIImage+Extension.h"

static CGFloat headerViewHeight = 190.0f;

static NSString *const kFCContactCreationCellIdentifier = @"FCContactCreationCellIdentifier";

@interface FCContactCreationViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    FCDataManager *dataManager;
    
    FCContactCreationHeaderView *headerView;
    
    NSArray *dataSources;
    
    NSMutableArray *infoArray;
}

@end

@implementation FCContactCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self configHeaderView];
    
    UINib *nib = [UINib nibWithNibName:@"FCContactCreationCell" bundle:nil];
    [_myTableView registerNib:nib forCellReuseIdentifier:kFCContactCreationCellIdentifier];
    
    dataSources = @[@"姓名",@"电话",@"电子邮件"];
    [self configInfoArray];

    dataManager = [[FCDataManager alloc]init];
    
    [self initNavItems];
    
    if (_contactModel == nil) {
        self.title = NSLocalizedString(@"New Contact", @"New Contact");
        _contactModel = [[ContactModel alloc]init];
        _contactModel.contact_id = @"0";
    }else{
        self.title = NSLocalizedString(@"Modify Contact", @"Modify Contact");
    }
}

-(void)configHeaderView{
    headerView = [[[NSBundle mainBundle]loadNibNamed:@"FCContactCreationHeaderView" owner:self options:nil]firstObject];
    headerView.backGroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_myTableView.frame), headerViewHeight);
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar)];
    [headerView.headerImageView addGestureRecognizer:tapG];
    
    
    _myTableView.tableHeaderView = headerView;
    _myTableView.sectionHeaderHeight = headerViewHeight;
    if (_contactModel.contact_avatar) {
        UIImage *image = [UIImage imageWithData:_contactModel.contact_avatar];
        headerView.headerImageView.image = image;
        headerView.backGroundImageView.image = image;
    }
}

-(void)configInfoArray{
    infoArray = [NSMutableArray array];
    [infoArray addObject:_contactModel.contact_avatar?:@""];
    [infoArray addObject:_contactModel.contact_name?:@""];
    [infoArray addObject:_contactModel.contact_phoneNumber?:@""];
    [infoArray addObject:_contactModel.contact_email?:@""];
}

-(void)initNavItems{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(closeMe) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(saveContact) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 40, 30);
    [rightButton setTitle:NSLocalizedString(@"Save", @"Save") forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:18.0f/255.0f green:150.0f/255.0f  blue:219.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - tableview delegate & datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSources.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FCContactCreationCell *cell = [tableView dequeueReusableCellWithIdentifier:kFCContactCreationCellIdentifier forIndexPath:indexPath];
    cell.myTextField.placeholder = dataSources[indexPath.section];
    cell.myTextField.tag = 1000 + indexPath.section +1; //1000留给头像
    cell.myTextField.delegate = self;
    cell.myTextField.text = infoArray[indexPath.section+1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FCContactCreationCell *fccell = (FCContactCreationCell *)cell;
        [fccell performAnimation];
    });

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat oriHeight = headerViewHeight;
    
    
    headerView.backGroundImageView.frame = CGRectMake(0, 0 + offsetY, CGRectGetWidth(_myTableView.frame), oriHeight - offsetY);
    
}
#pragma mark - Change Avatar

- (void)changeAvatar
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:NSLocalizedString(@"Set User Picture", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                              destructiveButtonTitle:nil
                              otherButtonTitles:NSLocalizedString(@"Choose from Camera Roll", nil), NSLocalizedString(@"Take Photo", nil),nil];
    mySheet.backgroundColor = [UIColor clearColor];
    [mySheet showInView:self.view];
}

#pragma mark ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self takePhoto];
            break;
        case 0:
            [self localPhoto];
            break;
        default:

            break;
    }
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)localPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
    
    
    [headerView updateAvatar:image];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _contactModel.contact_avatar = UIImagePNGRepresentation(image);
        UIImage *compressImage = [UIImage compressImage:image newWidth:100];
        _contactModel.contact_thumbnail = [UIImage zipImageWithImage:compressImage];

        [infoArray replaceObjectAtIndex:0 withObject:_contactModel.contact_avatar];
    });
}

#pragma mark - navibar method
-(void)closeMe{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(contactCreationViewControllerdidCancelCreationContact:)]) {
            [_delegate contactCreationViewControllerdidCancelCreationContact:self];
        }
    }];
}

-(BOOL)checkInfoAvailable{
    NSString *nameString = infoArray[1];
    NSString *phonenumber = infoArray[2];
    if (nameString.length==0 || phonenumber.length==0) {
        return NO;
    }
    return YES;
}

-(void)saveContact{
    [self.view endEditing:YES];
    

    NSString *nameString = infoArray[1];
    NSString *phonenumber = infoArray[2];
    NSString *email = infoArray[3];
    if (![self checkInfoAvailable]) {
        return;
    }
    
    NSData *avatarData = [infoArray firstObject];
    if (avatarData == nil) {
        avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"defaultAvatar"]);
        _contactModel.contact_avatar = avatarData;
        _contactModel.contact_thumbnail = avatarData;
    }
    _contactModel.contact_name = nameString;
    _contactModel.contact_phoneNumber = phonenumber;
    _contactModel.contact_email = email;
    
    NSInteger indexModel = [dataManager.dataSourcesArray indexOfObjectPassingTest:^BOOL(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.contact_id isEqualToString:_contactModel.contact_id]) {
            return YES;
        }
        return NO;
    }];
    if (indexModel == NSNotFound) {
        [dataManager.dataSourcesArray addObject:_contactModel];
    }else{
        [dataManager.dataSourcesArray replaceObjectAtIndex:indexModel withObject:_contactModel];
    }
        
    
    [dataManager saveToDisk];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(contactCreationViewControllerdidFinishCreationContact:)]) {
            [_delegate contactCreationViewControllerdidFinishCreationContact:self];
        }
    }];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [infoArray replaceObjectAtIndex:(textField.tag - 1000) withObject:textField.text];
}

@end
