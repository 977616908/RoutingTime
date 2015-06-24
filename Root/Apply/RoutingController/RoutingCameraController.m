//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingCameraController.h"
#import "ContentViewController.h"
#import "RTSlider.h"
#import "RoutingCamera.h"

@interface RoutingCameraController ()<UIPageViewControllerDataSource>{
    NSMutableArray *_arrCamera;
}

@property (weak, nonatomic) IBOutlet RTSlider *slider;
@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (nonatomic,weak)UIPageViewController *pageController;

- (IBAction)onClick:(id)sender;

- (IBAction)onSilderChange:(id)sender;

@end

@implementation RoutingCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self initBase];
    [self initView];
    
}

-(void)initBase{
    _arrCamera=[NSMutableArray array];
    for (int i=0; i<25; i++) {
        RoutingCamera *rc=[[RoutingCamera alloc]init];
        rc.rtContent=[NSString stringWithFormat:@"第%d条测试数据,hellow word!!!",i+1];
        rc.rtDate=@"2015-6-20";
        rc.rtPath=[NSString stringWithFormat:@"rt_test0%d",i%2];
        [_arrCamera addObject:rc];
    }
}

-(void)initView{
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 25;
    self.slider.value = 2;
    //    _steppedSlider.labelOnThumb.hidden = YES;
    self.slider.labelAboveThumb.font = [UIFont systemFontOfSize:16.0];
    self.slider.labelAboveThumb.hidden=YES;
    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey:UIPageViewControllerOptionSpineLocationKey];
    UIPageViewController *pageController=[[UIPageViewController alloc]initWithTransitionStyle:(UIPageViewControllerTransitionStylePageCurl) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:options];
    pageController.dataSource=self;
    pageController.view.frame=self.pageView.bounds;
    [pageController becomeFirstResponder];
    ContentViewController * initialViewController = [self viewCintrollerAtIndex:0];
    ContentViewController * endViewController = [self viewCintrollerAtIndex:1];
    
    NSArray *viewControllers=@[initialViewController,endViewController];
    [pageController setViewControllers:viewControllers direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    [self addChildViewController:pageController];
    self.pageController=pageController;
    [self.pageView addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)onClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onSilderChange:(id)sender {
    
    
}

#pragma mark 创建Controller

- (ContentViewController *)viewCintrollerAtIndex:(NSUInteger)index{
    if ([_arrCamera count] == 0 || (index >= [_arrCamera count]-1)) {
        return nil;
    }
    ContentViewController * dataViewController =[[ContentViewController alloc]init];
    dataViewController.dataObject = [_arrCamera objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(ContentViewController*)viewController{
    return  [_arrCamera indexOfObject:viewController.dataObject];
}

#pragma mark 翻页Controller

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index --;
    return [self viewCintrollerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [_arrCamera count]) {
        return nil;
    }
    return [self viewCintrollerAtIndex:index];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}



@end
