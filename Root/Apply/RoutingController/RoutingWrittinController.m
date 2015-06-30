//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingWrittinController.h"
#import "RTSlider.h"
#import "CCTextView.h"
#import "RoutingCamera.h"

@interface RoutingWrittinController ()
- (IBAction)onClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) CCTextView *txtContent;
@end

@implementation RoutingWrittinController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    CCTextView *txtContent=[[CCTextView alloc]initWithFrame:self.bgView.bounds];
    txtContent.placeholder=@"点击这里编辑文字...";
    txtContent.placeholderColor=RGBCommon(171, 171, 171);
    txtContent.textColor=RGBCommon(52, 52, 52);
    txtContent.font=[UIFont systemFontOfSize:16.0f];
    txtContent.alwaysBounceVertical=YES;
    [self.bgView addSubview:txtContent];
    if (![[self.dataObject rtContent]isEqualToString:@""]) {
        txtContent.text=[self.dataObject rtContent];
        [txtContent textDidChange];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}

#pragma -mark 网络请求
-(void)getRequest{
//    http://58.67.196.187:8080/platports/pifii/plat/timeRouter/addOrModifyDetails?story=写下这一天的故事&storyId=1&resId=0001
    NSString *content=self.txtContent.text;
    if (![content isEqualToString:@""]&&![content isEqualToString:[self.dataObject rtContent]]) {
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSDictionary *userData= [user objectForKey:USERDATA];
//        NSString *userPhone=userData[@"userPhone"];
//        if (userPhone&&![userPhone isEqualToString:@""]) {
//            
//        }
        [self initPostWithURL:ROUTINGTIMEURL path:@"addOrModifyDetails" paras:@{@"story":content,@"storyId":@(1)} mark:@"written" autoRequest:YES];
        
    }

    
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
   
    
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



- (IBAction)onClick:(id)sender {
    if ([sender tag]==2) {
        [self.dataObject setRtContent:@"已经编辑过了"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
