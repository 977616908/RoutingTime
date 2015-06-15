//
//  FlashInView.m
//  PiFiiHome
//
//  Created by HXL on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ApplyView.h"

#define HEIGHT 166
@interface ApplyView()

@property(nonatomic,weak)UIScrollView *moveView;

@end
@implementation ApplyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =RGBAlpha(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelfView)];
        [self addGestureRecognizer:tap];
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, HEIGHT, 320, CGRectGetHeight(self.frame))];
        _moveView=scrollView;
        [self addSubview:scrollView];
        [self createApply];

    }
    return self;
}


-(void)createApply{
    UIView * childView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-HEIGHT, 320 , HEIGHT)];
    childView.backgroundColor=[UIColor whiteColor];
    [_moveView addSubview:childView];
}


-(void)moveTransiton:(BOOL)isAnimation{
    self.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        if (isAnimation) {
            _moveView.transform=CGAffineTransformMakeTranslation(0, -_moveView.frame.origin.y);
        }else{
            _moveView.transform=CGAffineTransformIdentity;
        }
    }completion:^(BOOL finished) {
        self.hidden=!isAnimation;
    }];
}

- (void)hiddenSelfView
{
    self.type(0);
}

-(void)goBind:(CCButton *)sendar
{

    
}

@end
