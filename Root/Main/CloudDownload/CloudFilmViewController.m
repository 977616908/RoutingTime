//
//  CloudTvPlayViewController.m
//  RoutingTime
//
//  Created by HXL on 15/3/18.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloudFilmViewController.h"
#import "SeveralViewCell.h"
#import "CloudDownViewController.h"

@interface CloudFilmViewController ()<UIAlertViewDelegate>{
    MBProgressHUD *stateView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lbFilmName;

@property (weak, nonatomic) IBOutlet UILabel *lbNetFrom;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbContents;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArr;

@property (weak, nonatomic) IBOutlet UILabel *tvIntroduction;

- (IBAction)onClick:(id)sender;


@end

@implementation CloudFilmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    CGRect rect=[[UIScreen mainScreen]bounds];
    CGFloat contentHeight=rect.size.height-64;
    _rootScrollView.frame=CGRectMake(0, 0, CGRectGetWidth(rect), contentHeight);
    CGRect textRect=_tvIntroduction.frame;
    CGSize textSize=[GlobalShare sizeWithText:_tvIntroduction.text font:_tvIntroduction.font maxSize:CGSizeMake(CGRectGetWidth(textRect), MAXFLOAT)];
    textRect.size=textSize;
    _tvIntroduction.frame=textRect;
    _rootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(_tvIntroduction.frame)+15);
}

-(void)initBase{
    NSArray *contents=@[_msg.protagonist,_msg.director,_msg.region,_msg.year];
    for (int i=0; i<contents.count; i++) {
        ((UILabel *)self.lbContents[i]).text=contents[i];
    }
    _lbFilmName.text=_msg.name;
    _lbNetFrom.text=_msg.netFrom;
    _tvIntroduction.text=_msg.introduction;
    NSArray *imgArr=@[_msg.bigPicPath,_msg.smallPicPath];
    for (int i=0; i<imgArr.count; i++) {
        NSString *path=imgArr[i];
        UIImageView *img=_imgArr[i];
        CGSize size=CGSizeMake(65, 90);
        if (i==0)size=CGSizeMake(320, 175);
        if (hasCachedImageWithString(path)) {
            img.image=[UIImage imageWithContentsOfFile:pathForString(path)];
        }else{
            NSValue *value=[NSValue valueWithCGSize:size];
            NSDictionary *dict=@{@"url":path,@"imageView":img,@"size":value};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
    }
}


- (IBAction)onClick:(id)sender {
    NSString *msg=[NSString stringWithFormat:@"确定下载(%@)?",self.msg.name];
    [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        CloudDownViewController *downController=[[CloudDownViewController alloc]init];
        [self.navigationController pushViewController:downController animated:YES];
    }
}

-(void)requestDown{
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.labelText=@"添加下载...请稍候!";
    stateView.hidden=NO;
    NSDictionary *param=@{@"tradeCode":@1012,
                          @"id":@"0001",
                          @"download_amount":@"1",
                          @"download_url":@"",
                          @"type":@"download"};
    [self initPostWithURL:CLOUNDURL path:@"moreCloudDown" paras:param mark:@"cloudDown" autoRequest:YES];
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    stateView.labelText=@"添加失败";
    [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
