//
//  CloundView.m
//  RoutingTime
//
//  Created by HXL on 15/3/18.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloundView.h"

@implementation CloundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

-(void)layoutSubviews{
    
}

-(void)createView{
    CGFloat wh=CGRectGetWidth(self.frame);
    
    UIImageView *imgTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wh, 175)];
    imgTitle.image=[UIImage imageNamed:@"hm_banner"];
    [self addSubview:imgTitle];
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgTitle.frame), wh, 53)];
    CCLabel *lbTitle=CCLabelCreateWithNewValue(@"锦绣缘", 18.0f, CGRectMake(10, 10, 200, 25));
    [lbTitle alterFontColor:RGBCommon(38, 38, 38)];
    [titleView addSubview:lbTitle];
    CCLabel *lbJiShu=CCLabelCreateWithNewValue(@"更新至13集/全40集", 16.0f, CGRectMake(10,CGRectGetMaxY(lbTitle.frame),200,16));
    [lbJiShu alterFontColor:RGBCommon(105, 105, 105)];
    [titleView addSubview:lbJiShu];
    CCButton *btnDown=CCButtonCreateWithValue(CGRectMake(240, 8, 35, 35), @selector(onClick:), self);
    [btnDown alterNormalBackgroundImage:@""];
    btnDown.tag=1;
    [titleView addSubview:btnDown];
    CCButton *btnZuiJu=CCButtonCreateWithValue(CGRectMake(280, 8, 35, 35), @selector(onClick:), self);
    [btnZuiJu alterNormalBackgroundImage:@""];
    btnZuiJu.tag=1;
    [titleView addSubview:btnZuiJu];
    [self addSubview:titleView];
    
    UIView *bgLine=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), wh, 0.5)];
    bgLine.backgroundColor=RGBCommon(197, 197, 197);
    [self addSubview:bgLine];
    
    UIView *jqView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgLine.frame), wh, 103)];
    CCLabel *lbjuQi=CCLabelCreateWithNewValue(@"剧集", 18.0f, CGRectMake(10, 15, 30, 25));
    [lbjuQi alterFontColor:RGBCommon(38, 38, 38)];
    [jqView addSubview:lbjuQi];
    CCLabel *lblaiY=CCLabelCreateWithNewValue(@"来源:http://www.2345.com", 16.0f, CGRectMake(120,10,200,16));
    [lblaiY alterFontColor:RGBCommon(105, 105, 105)];
    [jqView addSubview:lblaiY];
    for (int i=0; i<5; i++) {
        CCButton *btnjq=CCButtonCreateWithFrame(CGRectMake(10+(51+10)*i, 37, 51, 51));
        [btnjq alterNormalBackgroundImage:@"hm_spxz001"];
        [btnjq alterNormalTitle:[NSString stringWithFormat:@"0%d",i+1]];
        [jqView addSubview:btnjq];
    }
    [self addSubview:jqView];
    
    UIView *bgLine1=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(jqView.frame), wh, 0.5)];
    bgLine1.backgroundColor=RGBCommon(197, 197, 197);
    [self addSubview:bgLine1];
    
    CCLabel *lbjx=CCLabelCreateWithNewValue(@"简介", 18.0f, CGRectMake(15, CGRectGetMaxY(bgLine1.frame)+10, 30, 25));
    [lbjx alterFontColor:RGBCommon(38, 38, 38)];
    [self addSubview:lbjuQi];
    
//    UIView *jxView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbjx.frame), wh, <#CGFloat height#>)]
    
}

-(void)onClick:(id)sendar{
    
}

@end
