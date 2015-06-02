//
//  CloudDownViewController.m
//  RoutingTime
//
//  Created by HXL on 15/3/17.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloudDownViewController.h"
#import "CloudMessage.h"
#import "CloudDownCell.h"

#define CELLID @"CLOUND"
#define BARHEIGHT 44

@interface CloudDownViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *arrTv;
    NSMutableArray *arrFilm;
    UIView         *_toolbar;
    BOOL           _isSelect;
    NSMutableOrderedSet *selectSet;
}
@property(nonatomic,weak)UITableView *tableDown;
@property(nonatomic,weak)CCButton *btnDelete;
@property(nonatomic,weak)CCButton *btnSelect;

@end

@implementation CloudDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"正在下载";
    _isSelect=NO;
    [self createView];
    [self createTool];
}

-(void)createView{
    self.view.backgroundColor=RGBCommon(234, 234, 234);
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, BARHEIGHT)];
    bgView.layer.borderWidth=0.5;
    bgView.layer.borderColor=[RGBCommon(197, 197, 197) CGColor];
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    CCButton *btnPause=CCButtonCreateWithValue(CGRectMake(0, 0, 159.5, BARHEIGHT), @selector(onDownClick:), self);
    btnPause.tag=1;
    btnPause.backgroundColor=[UIColor whiteColor];
    [btnPause alterFontSize:18.0f];
    [btnPause alterNormalTitle:@"全部暂停"];
    [btnPause alterNormalTitleColor:RGBCommon(38, 38, 38)];
    [bgView addSubview:btnPause];
    
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(160, 0, 160, BARHEIGHT), @selector(onDownClick:), self);
    btnStart.tag=2;
    btnStart.backgroundColor=[UIColor whiteColor];
    [btnStart alterFontSize:18.0f];
    [btnStart alterNormalTitle:@"全部开始"];
    [btnStart alterNormalTitleColor:RGBCommon(38, 38, 38)];
    [bgView addSubview:btnStart];
    
    CGFloat hg=64;
    hg=[UIScreen mainScreen].bounds.size.height-hg-37;
    UITableView *tableDown=[[UITableView alloc]initWithFrame:CGRectMake(0, BARHEIGHT, 320, hg)];
    tableDown.backgroundColor=[UIColor clearColor];
    tableDown.dataSource=self;
    tableDown.delegate=self;
    tableDown.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableDown=tableDown;
    [self.view addSubview:tableDown];
    
}


-(void)createTool{
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(upDownListener:), self);
    [sendBut alterNormalTitle:@"编辑"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    
    _toolbar=[[UIView alloc]init];
    _toolbar.backgroundColor=[UIColor clearColor];
    _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), BARHEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    CCButton *btnSelect=CCButtonCreateWithValue(CGRectMake(0, 0, 159.5, BARHEIGHT), @selector(onDownClick:), self);
    btnSelect.tag=3;
    btnSelect.backgroundColor=[UIColor whiteColor];
    [btnSelect alterFontSize:18.0f];
    [btnSelect setImage:[UIImage imageNamed:@"hm_quanxuan"] forState:UIControlStateNormal];
    [btnSelect alterNormalTitle:@"全选"];
    [btnSelect alterNormalTitleColor:RGBCommon(105, 105, 105)];
    self.btnSelect=btnSelect;
    [_toolbar addSubview:btnSelect];
    
    CCButton *btnDelete=CCButtonCreateWithValue(CGRectMake(160, 0, 160, BARHEIGHT), @selector(onDownClick:), self);
    btnDelete.tag=4;
    btnDelete.backgroundColor=[UIColor whiteColor];
    [btnDelete alterFontSize:18.0f];
    [btnDelete setImage:[UIImage imageNamed:@"hm_coundsc02"] forState:UIControlStateNormal];
    [btnDelete alterNormalTitleColor:RGBCommon(180, 180, 180)];
    [btnDelete alterNormalTitle:@"删除"];
    self.btnDelete=btnDelete;
    [_toolbar addSubview:btnDelete];
    
    [self.view addSubview:_toolbar];
}


-(void)upDownListener:(CCButton *)sendar{
    selectSet=[NSMutableOrderedSet orderedSet];
    if ([sendar.titleLabel.text isEqualToString:@"编辑"]) {
        [sendar alterNormalTitle:@"取消"];
        [self toolBarWithAnimation:NO];
        _isSelect=YES;
    }else{
        [sendar alterNormalTitle:@"编辑"];
        _isSelect=NO;
        [self toolBarWithAnimation:YES];
    }
    [_tableDown reloadData];

}

-(void)toolBarWithAnimation:(BOOL)isHidden{
    CGFloat barY=0;
    if (isHidden) {
        barY=CGRectGetHeight(self.view.frame);
    }else{
        barY=CGRectGetHeight(self.view.frame)-BARHEIGHT;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _toolbar.frame = CGRectMake(0, barY, CGRectGetWidth(self.view.frame), BARHEIGHT);
    }];
}


-(void)initBase{
    arrTv=[NSMutableArray array];
    arrFilm=[NSMutableArray arrayWithArray:_arrCount];
    for (int i=0; i<10; i++) {
        CloudDownMessage *msg=[[CloudDownMessage alloc]init];
        msg.titleImg=@"hm_chakan";
        msg.titleName=[NSString stringWithFormat:@"锦绣缘（第%02d集）",i+1];
        if(i!=0){
            msg.titleProgress=0.25;
            msg.titleLength=@"89.5M";
        }
        msg.titleCome=@"来源:http://www.2345.com";
        [arrTv addObject:msg];
    }
    
}


-(void)onDownClick:(CCButton *)sendar{
    PSLog(@"--%d--",sendar.tag);
    switch (sendar.tag) {
        case 1://全部暂停
            
            break;
        case 2://全部开始
            
            break;
        case 3://全选
            if (selectSet.count==arrTv.count) {
                [selectSet removeAllObjects];
                [self cloudWithSelect:YES];
            }else{
                [selectSet addObjectsFromArray:arrTv];
                [self cloudWithSelect:NO];
            }
            [_tableDown reloadData];
            break;
        case 4://删除
            [_btnDelete setImage:[UIImage imageNamed:@"hm_coundsc02"] forState:UIControlStateNormal];
            [_btnDelete alterNormalTitleColor:RGBCommon(180, 180, 180)];
            if (selectSet.count>0) {
                for (int i=0; i<selectSet.count; i++) {
                    [arrTv removeObject:selectSet[i]];
                }
                [_tableDown reloadData];
            }
            break;
        default:
            break;
    }
}

-(void)cloudWithSelect:(BOOL)isSelect{
    if (isSelect) {
        [_btnSelect setImage:[UIImage imageNamed:@"hm_quanxuan"] forState:UIControlStateNormal];
        [_btnSelect alterNormalTitle:@"全选"];
        [_btnDelete setImage:[UIImage imageNamed:@"hm_coundsc02"] forState:UIControlStateNormal];
        [_btnDelete alterNormalTitleColor:RGBCommon(180, 180, 180)];
    }else{
        [_btnSelect setImage:[UIImage imageNamed:@"hm_qxqx"] forState:UIControlStateNormal];
        [_btnSelect alterNormalTitle:@"取消全选"];
        [_btnDelete setImage:[UIImage imageNamed:@"hm_coundsc"] forState:UIControlStateNormal];
        [_btnDelete alterNormalTitleColor:RGBCommon(105, 105, 105)];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrTv.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"CELLID";
    CloudDownCell *downCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!downCell) {
        downCell=[[CloudDownCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    CloudDownMessage *msg=arrTv[indexPath.row];
    if (msg) {
        downCell.titleImg.image=[UIImage imageNamed:msg.titleImg];
        downCell.titleName.text=msg.titleName;
        if (msg.titleProgress==0) {
            downCell.titleProgress.hidden=YES;
            downCell.titleLength.hidden=YES;
            downCell.titleCount.hidden=YES;
        }else{
            downCell.titleProgress.progress=msg.titleProgress;
            downCell.titleLength.text=msg.titleLength;
        }
    }
    if (_isSelect) {
        downCell.selectImg.hidden=NO;
        if([selectSet containsObject:msg]){
            downCell.selectImg.image=[UIImage imageNamed:@"hm_xuanze02"];
        }else{
            downCell.selectImg.image=[UIImage imageNamed:@"hm_xuanze01"];
        }
    }else{
        downCell.selectImg.hidden=YES;
    }
    return downCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CloudDownCell *downCell=(CloudDownCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (_isSelect) {
        CloudDownMessage *msg=arrTv[indexPath.row];
        if ([selectSet containsObject:msg]) {
            downCell.selectImg.image=[UIImage imageNamed:@"hm_xuanze01"];
            [selectSet removeObject:msg];
        }else{
            downCell.selectImg.image=[UIImage imageNamed:@"hm_xuanze02"];
            [selectSet addObject:msg];
        }
        if (selectSet.count>0) {
            [_btnDelete setImage:[UIImage imageNamed:@"hm_coundsc"] forState:UIControlStateNormal];
            [_btnDelete alterNormalTitleColor:RGBCommon(105, 105, 105)];
            if(selectSet.count==arrTv.count){
                [_btnSelect setImage:[UIImage imageNamed:@"hm_qxqx"] forState:UIControlStateNormal];
                [_btnSelect alterNormalTitle:@"取消全选"];
            }else{
                [_btnSelect setImage:[UIImage imageNamed:@"hm_quanxuan"] forState:UIControlStateNormal];
                [_btnSelect alterNormalTitle:@"全选"];
            }
        }else{
            [self cloudWithSelect:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
