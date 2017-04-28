//
//  TodayViewController.m
//  FastCallExt
//
//  Created by zhangyingjie on 2016/11/28.
//  Copyright © 2016年 zhangyingjie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AddContactCell.h"
#import <FCContactModel/FCContactModel.h>
#import "FastCallCell.h"


@interface TodayViewController () <NCWidgetProviding,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *dataSourcesArray;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated{
//    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self refreshData];
    completionHandler(NCUpdateResultNewData);
}

-(void)refreshData{
    NSData *localData = [[[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.FastTool"] objectForKey:@"localData"];
    NSArray *contactsLocal = [NSKeyedUnarchiver unarchiveObjectWithData:localData];
    if (contactsLocal==nil) {
        dataSourcesArray = [@[] mutableCopy];
    }else{
        dataSourcesArray = [contactsLocal mutableCopy];
    }
    [_myCollectionView reloadData];
}


#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataSourcesArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == dataSourcesArray.count) {
        AddContactCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddContactCell" forIndexPath:indexPath];
        return cell;
    }
    FastCallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FastCallCell" forIndexPath:indexPath];
    ContactModel *model = dataSourcesArray[indexPath.row];
    UIImage *image = [UIImage imageWithData:model.contact_thumbnail];
    cell.callImageView.image = image;
    cell.contactName.text = model.contact_name;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (dataSourcesArray.count==0){
        return;
    }
    if (indexPath.item == dataSourcesArray.count) {
        [self.extensionContext openURL:[NSURL URLWithString:@"FastCallExt://"] completionHandler:nil];
        return;
    }
    ContactModel *model = dataSourcesArray[indexPath.row];
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.contact_phoneNumber]] completionHandler:nil];
}
@end
