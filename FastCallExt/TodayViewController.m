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
    NSNumber *isInstalledExt;
    NSUserDefaults *userDefault;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) CAEmitterLayer *caELayer;
@end

@implementation TodayViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"");
    _infoLabel.alpha = 0.0f;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefault = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"];
    isInstalledExt = [userDefault objectForKey:@"isInstalledExt"];
    if (isInstalledExt == nil) {
        // Perform any setup necessary in order to update the view.
        _infoLabel.alpha = 0.0f;
        // If an error is encountered, use NCUpdateResultFailed
        // If there's no update required, use NCUpdateResultNoData
        // If there's an update, use NCUpdateResultNewData
        
        if (isInstalledExt==nil) {
            [userDefault setObject:@YES forKey:@"isInstalledExt"];
            [userDefault synchronize];
            //perform animation
        }else{
            //        [self refreshData];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSparkAnimation];
            [UIView animateWithDuration:3 animations:^{
                _infoLabel.alpha = 1.0f;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopSparkAnimation];
            });
        });
    }else{
        [self refreshData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _infoLabel.alpha = 0.0f;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _infoLabel.alpha = 0.0f;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _infoLabel.alpha = 0.0f;
}

//- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
//    _infoLabel.alpha = 0.0f;
//
//    completionHandler(NCUpdateResultNoData);
//}

-(void)refreshData{
    NSData *localData = [[[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"] objectForKey:@"localData"];
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
    return dataSourcesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)dealloc{
    NSLog(@"Ext Dealloc");
    _infoLabel.alpha = 0.0f;
}

-(void)performSparkAnimation{
    self.caELayer                   = [CAEmitterLayer layer];
//    self.caELayer.frame = CGRectMake(0, 30, 100, 50);
    // 发射源
    self.caELayer.emitterPosition   = CGPointMake(100, -10);
    // 发射源尺寸大小
    self.caELayer.emitterSize       = CGSizeMake(2, 0);
    // 发射源模式
    self.caELayer.emitterMode       = kCAEmitterLayerOutline;
    // 发射源的形状
    self.caELayer.emitterShape      = kCAEmitterLayerLine;
    // 渲染模式
    self.caELayer.renderMode        = kCAEmitterLayerAdditive;
    // 发射方向
    self.caELayer.velocity          = 1;
    // 随机产生粒子
    self.caELayer.seed              = (arc4random() % 100) + 1;
    
    // 爆炸
    CAEmitterCell *burst            = [CAEmitterCell emitterCell];
    // 粒子产生系数
    burst.birthRate                 = 1.0;
    // 速度
    burst.velocity                  = 0;
    // 缩放比例
    burst.scale                     = 1.2;
    // shifting粒子red在生命周期内的改变速度
    burst.redSpeed                  = -1.5;
    // shifting粒子blue在生命周期内的改变速度
    burst.blueSpeed                 = +1.5;
    // shifting粒子green在生命周期内的改变速度
    burst.greenSpeed                = +1.0;
    //生命周期
    burst.lifetime                  = 0.35;
    
    
    // 火花 and finally, the sparks
    CAEmitterCell *spark            = [CAEmitterCell emitterCell];
    //粒子产生系数，默认为1.0
    spark.birthRate                 = 400;
    //速度
    spark.velocity                  = 125;
    // 360 deg//周围发射角度
    spark.emissionRange             = 2 * M_PI;
    // gravity//y方向上的加速度分量
    spark.yAcceleration             = 75;
    //粒子生命周期
    spark.lifetime                  = 3;
    //是个CGImageRef的对象,既粒子要展现的图片
    spark.contents                  = (id)
    [[UIImage imageNamed:@"FFRing"] CGImage];
    //缩放比例速度
    spark.scaleSpeed                = -0.2;
    //粒子green在生命周期内的改变速度
    spark.greenSpeed                = -0.1;
    //粒子red在生命周期内的改变速度
    spark.redSpeed                  = 0.4;
    //粒子blue在生命周期内的改变速度
    spark.blueSpeed                 = -0.1;
    //粒子透明度在生命周期内的改变速度
    spark.alphaSpeed                = -0.25;
    //子旋转角度
    spark.spin                      = 2* M_PI;
    //子旋转角度范围
    spark.spinRange                 = 2* M_PI;
    
    CAEmitterCell *redCell = [self emitterCellWithColor:[UIColor redColor]];
    CAEmitterCell *greenCell = [self emitterCellWithColor:[UIColor greenColor]];
    CAEmitterCell *yellowCell = [self emitterCellWithColor:[UIColor yellowColor]];

    self.caELayer.emitterCells = [NSArray arrayWithObjects:redCell,greenCell,yellowCell,nil];
    redCell.emitterCells = [NSArray arrayWithObjects:burst, nil];
    yellowCell.emitterCells = [NSArray arrayWithObjects:burst, nil];
    greenCell.emitterCells = [NSArray arrayWithObjects:burst, nil];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:self.caELayer];
}

-(CAEmitterCell *)emitterCellWithColor:(UIColor *)color{
    CAEmitterCell *cell             = [CAEmitterCell emitterCell];
    // 速率
    cell.birthRate                  = 1.0;
    // 发射的角度
    cell.emissionRange              = 0.11 * M_PI;
    // 速度
    cell.velocity                   = 300;
    // 范围
    cell.velocityRange              = 150;
    // Y轴 加速度分量
    cell.yAcceleration              = 75;
    // 声明周期
    cell.lifetime                   = 2.04;
    //是个CGImageRef的对象,既粒子要展现的图片
    UIImage *cellImage = [UIImage imageNamed:@"FFRing"];
    cell.contents                   = (id)[cellImage CGImage];
    // 缩放比例
    cell.scale                      = 0.5;
    // 粒子的颜色
    cell.color                      = [color CGColor];
    if (color == [UIColor redColor]) {
        cell.greenRange		= 0.0;		// different colors
        cell.redRange       = 1.0;
        cell.blueRange		= 0.0;
    }else if (color == [UIColor greenColor]) {
        cell.greenRange		= 1.0;		// different colors
        cell.redRange       = 0.0;
        cell.blueRange		= 0.0;
    }else{
        cell.greenRange		= 0.0;		// different colors
        cell.redRange       = 0.0;
        cell.blueRange		= 1.0;
    }
    
    // 一个粒子的颜色green 能改变的范围
    // 子旋转角度范围
    cell.spinRange                  = M_PI;
    return cell;
}

-(void)stopSparkAnimation{
    [UIView animateWithDuration:0.25 animations:^{
       
    }];
    [self.caELayer removeAllAnimations];
    [self.caELayer removeFromSuperlayer];
    self.caELayer = nil;
}
@end
