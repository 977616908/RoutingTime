//
//  MedicalOrderViewController.m
//  RoutingTime
//
//  Created by HXL on 14/11/10.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "DownUrlViewController.h"
#import "DownLoadViewController.h"
#import "LiveDownView.h"
#import "SearchViewController.h"
@interface DownUrlViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    LiveDownView *liveView;
    UIButton *btnDown;
    NSArray *arrUrl;
}
- (IBAction)onClick:(id)sender;
- (IBAction)onSelect:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfDownUrl;


@end

@implementation DownUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"下载";
 //   [self.view setBackgroundColor:[UIColor clearColor]];
     arrUrl=@[@"http://58.67.196.187:8083/ttopyd/homeVersionFiles/test.mp4",
              @"http://tv.sohu.com/20130320/n369471857.shtml",
              @"http://g.hiphotos.baidu.com/image/pic/item/11385343fbf2b2112db2144ec88065380cd78e16.jpg"];
    liveView=[[LiveDownView alloc]initWithFrame:CGRectMake(0, 0, 290, 0)];;
    typeof(self) weakSelf=self;
    liveView.liveDown= ^ (NSString * str) {
        [weakSelf setLiveDown:str];
    };
    [self.view addSubview:liveView];
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(onSearchClick), self);
    [sendBut alterNormalTitle:@"搜索"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    
    liveView.isHidden=YES;
    _tfDownUrl.delegate=self;
}

-(void)setLiveDown:(NSString *)str{
    _tfDownUrl.text=str;
    [liveView showHidden:YES];
}

-(void)onSearchClick{
    SearchViewController *searchController=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchController animated:YES];
}

- (IBAction)onClick:(id)sender {
    if (!_tfDownUrl.text||[_tfDownUrl.text isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入下载地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] show];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    liveView.frame=CGRectMake(10, textField.frame.origin.y+30, 300, 0);
    liveView.arrayList=arrUrl;
    [liveView showHidden:NO];
}

- (IBAction)onSelect:(UIButton *)sender {
    if (liveView.isHidden) {
        liveView.isHidden=NO;
    }else{
        liveView.isHidden=!liveView.isHidden;
    }

    liveView.frame=CGRectMake(10, sender.frame.origin.y+30, 300, 0);
    liveView.arrayList=arrUrl;
    [liveView showHidden:liveView.isHidden];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        NSString *url=self.tfDownUrl.text;
        PSLog(@"---%@",url);
        if (buttonIndex==1) {
            DownLoadViewController * downCtr = [[DownLoadViewController alloc] init];
            downCtr.url = url;
            [self.navigationController pushViewController:downCtr animated:YES];
        }
}


@end
