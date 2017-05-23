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
#import <objc/runtime.h>
#import "FCDialViewController.h"

@interface TodayViewController () <NCWidgetProviding,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *dataSourcesArray;
    NSNumber *isInstalledExt;
    NSUserDefaults *userDefault;
    CGSize minimumSize;
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
-(void)update{
    NSString *systemV = [[UIDevice currentDevice]systemVersion];
    userDefault = [[NSUserDefaults alloc]initWithSuiteName:@"group.hepinglaosan.Kall"];
    isInstalledExt = [userDefault objectForKey:@"isInstalledExt"];
    if (isInstalledExt == nil) {
        _infoLabel.alpha = 0.0f;
        [userDefault setObject:@YES forKey:@"isInstalledExt"];
        [userDefault synchronize];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSparkAnimation];
            [UIView animateWithDuration:1 animations:^{
                _infoLabel.alpha = 1.0f;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopSparkAnimation];
            });
        });
    }else{
        [self refreshData];
    }
    if ([systemV floatValue]>=10) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
        
    }else{
        if (_myCollectionView.contentSize.height < minimumSize.height) {
            self.preferredContentSize = minimumSize;
        }else{
            self.preferredContentSize = _myCollectionView.contentSize;
        }
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    minimumSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);

    _emptyInfoLabel.hidden = YES;
    
    [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
    
    [self update];
   
}

//-(void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler{
//
//    
//    
//    completionHandler(NCUpdateResultNewData);
//}

/**
 *  该方法是用来设置Today Extension的偏移，默认会像左偏移
 *
 *  @param defaultMarginInsets UIEdgeInsets
 *
 *  @return UIEdgeInsets
 */
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    
    return UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *systemV = [[UIDevice currentDevice]systemVersion];
    if ([systemV floatValue]<=10) {
        [self update];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        if (_myCollectionView.contentSize.height < minimumSize.height) {
            self.preferredContentSize = minimumSize;
        }else{
            self.preferredContentSize = _myCollectionView.contentSize;
        }
    }else{
        self.preferredContentSize = CGSizeMake(CGRectGetWidth( _myCollectionView.frame), 100);
    }
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
    if (dataSourcesArray.count==0) {
        _emptyInfoLabel.hidden = NO;
    }else{
        _emptyInfoLabel.hidden = YES;
    }
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
    
    NSString *systemV = [[UIDevice currentDevice]systemVersion];
    if ([systemV floatValue]<=10) {
        cell.contactName.textColor = [UIColor colorWithWhite:255 alpha:0.6];
        cell.callImageView.layer.borderColor = [[UIColor colorWithWhite:255 alpha:0.6]CGColor];
        cell.callImageView.layer.backgroundColor = [[UIColor colorWithWhite:255 alpha:0.6]CGColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (dataSourcesArray.count==0){
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

- (IBAction)clickToHost:(UIButton *)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"FastCallExt://contact"] completionHandler:nil];
}

- (IBAction)clickToDialPage:(id)sender {
    
    FCDialViewController *dialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FCDialViewController"];
    dialViewController.view.frame = self.view.bounds;
    [self willMoveToParentViewController:nil];
    [self addChildViewController:dialViewController];
    [self.view addSubview:dialViewController.view];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [dialViewController didMoveToParentViewController:self];
    
}

@end
