//
//  RoutingTimeController.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingFootprintController.h"
#import "FontprintCell.h"
#import "AlbumInstallController.h"
#import "RoutingCameraController.h"

#define DEVICE @"APPDEVICE"

@interface RoutingFootprintController ()<UITableViewDataSource,UITableViewDelegate,PiFiiBaseViewDelegate>
@property(nonatomic,weak)CCTableView *table;


@end

@implementation RoutingFootprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataBase];
    [self initView];

}

-(void)initView{
    self.title=@"时光脚印";
    CGFloat gh=44;
    if(is_iOS7()){
        gh+=20;
    }
    CCTableView *table=CCTableViewCreateStylePlain(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh), self, YES);
    table.backgroundColor=[UIColor clearColor];
    self.table=table;
    [self.view addSubview:table];
}

-(void)dataBase{
    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:DEVICE];
    if (![arr containsObject:@(2)]) {
        AlbumInstallController  *albumController=[[AlbumInstallController alloc]init];
        albumController.pifiiDelegate=self;
        [self.navigationController pushViewController:albumController animated:YES];
    }
    else{
        RoutingCameraController *routingController;
        if (ScreenHeight()>480) {
            routingController=[[RoutingCameraController alloc]initWithNibName:@"RoutingCameraController" bundle:nil];
        }else{
            routingController=[[RoutingCameraController alloc]initWithNibName:@"RoutingCameraController640x960" bundle:nil];
        }
        routingController.arrCamera=[NSMutableArray array];
        //            routingController.dateStr=sb;
        [self presentViewController:routingController animated:YES completion:nil];
    }
}


#pragma -mark 传递数据处理
-(void)pushViewDataSource:(id)dataSource{
    NSInteger count=[dataSource integerValue];
    if(count!=0){
        [self saveDevice:dataSource];
    }
    
}

-(void)saveDevice:(id)data{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSArray *arr=[ud objectForKey:DEVICE];
    if (!arr) {
        arr=@[data];
    }else{
        if (![arr containsObject:data]) {
            NSMutableArray *ar=[NSMutableArray arrayWithArray:arr];
            [ar addObject:data];
            arr=ar;
        }
    }
    [ud setObject:arr forKey:DEVICE];
    [ud synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FontprintCell *cell=[FontprintCell cellWithTarget:self tableView:tableView];
    if (indexPath.row%2==0) {
        cell.isDouble=YES;
    }else{
        cell.isDouble=NO;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138.0f;
}


@end
