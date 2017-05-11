//
//  ViewController.m
//  FastCall
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import "FCBaseViewController.h"
#import "FCContactManager.h"
#import "AddContactCell.h"
#import "FastCallCell.h"
#import <FCContactModel/FCContactModel.h>
#import "FCCollectionLayout.h"
#import "FCDataManager.h"
#import "FCAddContactButton.h"
#import "RKDropdownAlert.h"
#import "FCContactCreationViewController.h"

@import FCContactModel;

@interface FCBaseViewController ()<FCCollectionLayoutDelegate,FCContactManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    FCDataManager *dataManager;
    BOOL inEditMode;
}
@end

@implementation FCBaseViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dataManager = [[FCDataManager alloc]init];
    inEditMode = NO;
    FCCollectionLayout *layout = (FCCollectionLayout *)_myCollectionView.collectionViewLayout;
    layout.delegate = self;
    _myCollectionView.alwaysBounceVertical = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addContactFromWidget) name:@"kAddContactNoti" object:nil];
}

#pragma mark - CollectionView Delegate & DataSources
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (dataManager.dataSourcesArray.count==0) {
        _emptyInfoLabel.hidden = NO;
    }else{
        _emptyInfoLabel.hidden = YES;
    }
    return dataManager.dataSourcesArray.count;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    FastCallCell *kallCell = (FastCallCell *)cell;
    [kallCell configViewInEdit:inEditMode];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    FastCallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FastCallCell" forIndexPath:indexPath];
    ContactModel *model = dataManager.dataSourcesArray[indexPath.row];
    [cell configModel:model];
    [cell.deleteBtn addTarget:self action:@selector(deleteItem:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FCContactCreationViewController *fcVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FCContactCreationViewController"];
    ContactModel *model = dataManager.dataSourcesArray[indexPath.row];
    fcVC.contactModel = model;
    [self.navigationController pushViewController:fcVC animated:YES];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    ContactModel *model = dataManager.dataSourcesArray[0];
//    FCContactCreationViewController *fcVC = segue.destinationViewController;
//    fcVC.contactModel = model;
//    [super prepareForSegue:segue sender:sender];
//}

#pragma mark - FCContactManagerDelegate
-(void)didCloseContactController:(UIViewController *)hostViewController{
    hostViewController.view.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hostViewController dismissViewControllerAnimated:NO completion:nil];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_addContactBtn resetAnimation];
    });
}

-(void)viewController:(UIViewController *)hostViewController didSelectContacts:(NSArray<ContactModel *> *)contactModels{
    for (ContactModel* contactModel in contactModels) {
        [self viewController:hostViewController didSelectContact:contactModel];
    }
}

-(void)viewController:(UIViewController *)hostViewController didSelectContact:(ContactModel *)contactModel{
    hostViewController.view.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hostViewController dismissViewControllerAnimated:NO completion:nil];
    });
    
    if ([dataManager isFirstTimeAddingContact]) {
        [dataManager completeAddingGuide];
        [RKDropdownAlert title:@"成功添加" message:@"长按联系人进行删除、排序" backgroundColor:nil textColor:nil time:20];
    }
    
    NSUInteger index = [dataManager.dataSourcesArray indexOfObjectPassingTest:^BOOL(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.contact_id isEqualToString:contactModel.contact_id]) {
            return YES;
        }
        return NO;
    }];
    if (contactModel.contact_avatar == nil) {
        //add default avatar
        contactModel.contact_avatar = UIImagePNGRepresentation([UIImage imageNamed:@"defaultAvatar"]);
    }
    if (contactModel.contact_thumbnail == nil) {
        contactModel.contact_thumbnail = UIImagePNGRepresentation([UIImage imageNamed:@"defaultAvatar"]);
    }
    if (index >= dataManager.dataSourcesArray.count) {
        [dataManager.dataSourcesArray addObject:contactModel];
        [dataManager saveToDisk];
    }else{
        //replace
        [dataManager.dataSourcesArray replaceObjectAtIndex:index withObject:contactModel];
        [dataManager saveToDisk];
    }
    [_myCollectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_addContactBtn resetAnimation];
    });
}

#pragma mark - FCCollectionLayoutDelegate
-(void)moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    [dataManager moveItemFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

-(void)didChangeEditState:(BOOL)inEditState{
    if (inEditState) {
        inEditMode = YES;
        [_myCollectionView performBatchUpdates:^{
        } completion:^(BOOL finished) {
        }];
    }else{
        inEditMode = NO;
        [self.myCollectionView reloadData];
    }
}

#pragma mark - Target Method

- (IBAction)clickInfoBtn:(id)sender {
    
}


- (void)clickAddBtn:(UIViewController *)presentedVC {
    [_addContactBtn startAnimation];
    //perform some animation
    FCContactManager *manager = [FCContactManager sharedInstance];
    manager.delegate = self;
    [manager showContactUIInView:presentedVC];
}

-(void)deleteItem:(UIButton *)deleteBtn event:(UIEvent *)event{
    //获取点击button的位置
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:_myCollectionView];
    NSIndexPath *indexPath = [_myCollectionView indexPathForItemAtPoint:currentPoint];
    if (indexPath.section == 0 && indexPath != nil) { //点击移除
        [_myCollectionView performBatchUpdates:^{
            [_myCollectionView deleteItemsAtIndexPaths:@[indexPath]];
            [dataManager deleteItemAtIndexPath:indexPath.row]; //删除
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_myCollectionView reloadData];
            });
        }];
    }
}

-(void)addContactFromWidget{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickAddBtn:nil];
    });
}

-(void)refresh{
    
    [dataManager refresh];
    [_myCollectionView reloadData];
}

@end
