//
//  JCFlipPage.m
//  JCFlipPageView
//
//  Created by ThreegeneDev on 14-8-8.
//  Copyright (c) 2014年 JimpleChen. All rights reserved.
//

#import "JCFlipPage.h"
@interface JCFlipPage ()

@property(nonatomic,weak)UILabel *lbDate;

@end

@implementation JCFlipPage
@synthesize reuseIdentifier = _reuseIdentifier;

- (void)dealloc
{
}

- (void)prepareForReuse
{
    
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reuseIdentifier = reuseIdentifier;
        
//        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
//        image.bounds=self.bounds;
//        [self addSubview:image];
//        
        
        UIImage *img=[UIImage imageNamed:@"rt_end"];
        UIImageView *endImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        endImg.image=img;
        self.endImg=endImg;
        endImg.hidden=YES;
        [self addSubview:endImg];
  
        UIImage *imgs=[UIImage imageNamed:@"rt_start"];
        UIImageView *startImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-imgs.size.width, 0, imgs.size.width, imgs.size.height)];
        startImg.image=imgs;
        startImg.hidden=YES;
        self.startImg=startImg;
//        CCLabel *lbDate=CCLabelCreateWithNewValue(@"2016/6/20 - 2016/6/21", 11.0f, CGRectMake(0, CGRectGetHeight(startImg.frame)-50, CGRectGetWidth(startImg.frame), 20));
        
        UILabel *lbDate=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(startImg.frame)-50, CGRectGetWidth(startImg.frame), 20)];
        lbDate.textAlignment=NSTextAlignmentCenter;
        lbDate.backgroundColor=[UIColor clearColor];
        NSString *fontName=[[NSBundle mainBundle]pathForResource:@"TUNGAB.TTF" ofType:nil];
        lbDate.font=[UIFont fontWithName:fontName size:11.0f];
        lbDate.textColor=RGBCommon(167, 167, 167);
//        lbDate.text=@"2016/6/20 - 2016/6/21";
        self.lbDate=lbDate;
        [startImg addSubview:lbDate];
        [self addSubview:startImg];
    }
    return self;
}

-(void)setDateStr:(NSString *)dateStr{
    _dateStr=dateStr;
    self.lbDate.text=_dateStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
