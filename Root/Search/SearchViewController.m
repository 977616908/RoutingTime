//
//  MedicalOrderViewController.m
//  RoutingTime
//
//  Created by HXL on 14/11/10.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import "WWTagsCloudView.h"
#import "SearchViewCell.h"
#import "CloudTvPlayViewController.h"
#import "CloudFilmViewController.h"
#import "CloudMessage.h"

@interface SearchViewController ()<WWTagsCloudViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *arrTag;
    NSMutableArray *_dataSource;
    NSInteger pageCount;
    MBProgressHUD *stateView;
}
@property (weak, nonatomic) UISearchBar *searchBar;

@property(nonatomic,weak)WWTagsCloudView *cloundView;
@property(nonatomic,weak)UIView *searchView;
@property(nonatomic,weak)UITableView *searchTable;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat gh=0;
    if(is_iOS7()){
        gh=20;
    }
    [self createNav:gh];
    [self createView:gh+44];
    [NSThread sleepForTimeInterval:.25];
    [_searchBar becomeFirstResponder];
}

- (void)createNav:(CGFloat)hg
{
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, 320, 44+hg) backgroundColor:RGBCommon(2, 137, 193)]; // RGBCommon(73, 170, 231)
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 7+hg, 255, 30)];
    searchBar.placeholder=@"请输入查询信息";
    searchBar.barStyle=UIBarStyleDefault;
    if(is_iOS7()){
        [searchBar setBackgroundColor:[UIColor whiteColor]];
        searchBar.barTintColor=[UIColor whiteColor];
        searchBar.layer.masksToBounds=YES;
        searchBar.layer.cornerRadius=14;
        searchBar.layer.borderWidth=0.5;
        searchBar.layer.borderColor=[RGBAlpha(186, 186, 186, 0.8) CGColor];
    }else{
        [searchBar setBackgroundColor:[UIColor clearColor]];
        [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
    }
    searchBar.delegate=self;
    self.searchBar=searchBar;
    [navTopView addSubview:searchBar];
    
    
    CCButton *btnCancel = CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(self.view.frame)-50, 12+hg, 40,20), @selector(exitCurrentController), self);
    [btnCancel alterNormalTitle:@"取消"];
    [btnCancel alterFontSize:16.0];
    [navTopView addSubview:btnCancel];
    [self.view addSubview:navTopView];
}

-(void)createView:(CGFloat)gh{
    //    NSArray* colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1], [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1], [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1], [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]];
    NSArray* colors=@[[UIColor blackColor]];
    NSArray* fonts = @[[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:16], [UIFont systemFontOfSize:20]];
    CGRect bgRect=CGRectMake(0,gh, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh);
    UIView *searchView=[[UIView alloc]init];
    searchView.frame=bgRect;
    WWTagsCloudView *tagView=[[WWTagsCloudView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)
                                                            andTags:arrTag
                                                       andTagColors:colors
                                                           andFonts:fonts
                                                    andParallaxRate:1.7
                                                       andNumOfLine:3];
    tagView.delegate=self;
    _cloundView=tagView;
    [searchView addSubview:tagView];
    
    UIButton *btnReflash=[UIButton buttonWithType:UIButtonTypeCustom];
    btnReflash.frame=CGRectMake(88, 210, 146, 42);
    [btnReflash setTitle:@"换一批" forState:UIControlStateNormal];
    btnReflash.backgroundColor=RGBCommon(46, 162, 228);
    [btnReflash addTarget:self action:@selector(onReflash:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btnReflash];
    self.searchView=searchView;
    [self.view addSubview:searchView];
    
    UITableView *table=[[UITableView alloc]initWithFrame:bgRect];
    table.backgroundColor=[UIColor clearColor];
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    table.dataSource=self;
    table.delegate=self;
    table.hidden=YES;
    self.searchTable=table;
    [self.view addSubview:table];
    
    
}

-(void)initBase{
//    arrTag = @[@"当幸福来敲门", @"海滩", @"如此的夜晚", @"锦绣缘", @"险地", @"姻缘订三生", @"死亡城", @"匆匆那年", @"老人与海", @"烽火异乡情", @"父亲离家时", @"无情大地补情天", @"以眼还眼", @"锦绣人生", @"修女传", @"第十三号", @"末代启示录", @"西北前线", @"西北区骑警", @"黄金广场大劫案", @"畸恋山庄", @"守夜", @"我们爱黑夜", @"恐怖夜校", @"夏尔洛结婚", @"特别的一夜", @"下一站格林威治村", @"升职记", @"恶夜之吻", @"木匠兄妹故事", ];
    _dataSource=[NSMutableArray array];
    arrTag=[NSMutableArray array];
    pageCount=1;
    [self getSearchPage:pageCount];
}

#pragma mark --网络视频请求
-(void)getSearchPage:(NSInteger)page{
    [self initPostWithURL:CLOUNDURL path:@"videoRecommend" paras:@{@"recommendation":@"search",@"page":@(page)} mark:@"searchPage" autoRequest:YES];
}


#pragma mark 成功返回数据处理 mark是标识 response结果
- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    //    PSLog(@"--%@--%@",mark,response);
//    [NSThread sleepForTimeInterval:1.0];
    if([mark isEqualToString:@"searchPage"]){
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            NSArray *data=[response objectForKey:@"data"];
            if (data) {
                for (int i=0; i<data.count; i++) {
                    NSDictionary *cloudData=data[i];
                    if (cloudData) {
                        CloudMessage *msg=[[CloudMessage alloc]initWithData:cloudData];
                        [arrTag addObject:msg.name];
                        [_dataSource addObject:msg];
                    }
                }
            }
            NSInteger counts=[[response objectForKey:@"counts"] integerValue]%9;
            if (pageCount<counts) {
                pageCount+=1;
            }else{
                pageCount=0;
            }
            [_cloundView reloadAllTags];
        }
    }else{
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        PSLog(@"--%@--%@",mark,response);
        if ([returnCode intValue]==200) {
            NSArray *data=[response objectForKey:@"data"];
            [_dataSource removeAllObjects];
            if (data) {
                for (int i=0; i<data.count; i++) {
                    NSDictionary *cloudData=data[i];
                    if (cloudData) {
                        CloudMessage *msg=[[CloudMessage alloc]initWithData:cloudData];
                        [_dataSource addObject:msg];
                    }
                }
            }
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            [_searchTable reloadData];
        }else{
            stateView.labelText=[response objectForKey:@"desc"];
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        }
        
    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    if ([mark isEqualToString:@"searchVedio"]) {
        stateView.labelText=@"查询失败!";
         [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            self.searchView.hidden=NO;
            self.searchTable.hidden=YES;
        }
    }];
}

-(void)tagClickAtIndex:(NSInteger)tagIndex
{
//    [self.view endEditing:YES];
    PSLog(@"%@",arrTag[tagIndex]);
    NSString *tag=arrTag[tagIndex];
    _searchBar.text=tag;
    [self startController:tagIndex];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [_dataSource removeAllObjects];
    NSString *tag=searchBar.text;
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.hidden=NO;
    self.searchView.hidden=YES;
    self.searchTable.hidden=NO;
    [self initPostWithURL:CLOUNDURL path:@"videoSearch" paras:@{@"tradeCode":@"1008",@"keyword":tag} mark:@"searchVedio" autoRequest:YES];
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)onReflash:(id)sendar{
    if (pageCount==0) {
        [_cloundView reloadAllTags];
    }else{
        [self getSearchPage:pageCount];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"CellID";
    SearchViewCell *searchCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!searchCell) {
        searchCell=[[SearchViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];;
    }
    CloudMessage *msg=_dataSource[indexPath.row];
    if (msg) {
        searchCell.searchTitle.text=msg.name;
        searchCell.searchName.text=msg.protagonist;
        searchCell.searchCome.text=msg.netFrom;
        searchCell.searchType.text=msg.plot;
        NSString *path=msg.middleSearchPicPath;
        //        [cell.imgView setImageWithURL:[path urlInstance]];
        if (hasCachedImageWithString(path)) {
            searchCell.searchImage.image=[UIImage imageWithContentsOfFile:pathForString(path)];
        }else{
            NSValue *size=[NSValue valueWithCGSize:CGSizeMake(98, 137)];
            NSDictionary *dict=@{@"url":path,@"imageView":searchCell.searchImage,@"size":size};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
    }
    searchCell.searchBtn.tag=indexPath.row;
    [searchCell.searchBtn addTarget:self action:@selector(onSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    return searchCell;
}


-(void)onSearchClick:(id)sendar{
    [self startController:[sendar tag]];
}


-(void)startController:(NSInteger)index{
    CloudMessage *msg=_dataSource[index];
    if ([msg.type hasPrefix:@"tv"]) {
        CloudTvPlayViewController *tvSeveralController=[[CloudTvPlayViewController alloc]init];
        tvSeveralController.title=msg.name;
        tvSeveralController.msg=msg;
        [self.navigationController pushViewController:tvSeveralController animated:YES];
    }else{
        CloudFilmViewController *filmController=[[CloudFilmViewController alloc]init];
        filmController.title=msg.name;
        filmController.msg=msg;
        [self.navigationController pushViewController:filmController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 162.0f;
}

-(void)exitCurrentController{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.type = kCATransitionPush;//101
    animation.subtype = kCATransitionFromBottom;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    if (![self.navigationController popViewControllerAnimated:NO]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

@end
