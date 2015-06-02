//
//  PiFiiViewController.m
//  RoutingTime
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MoPiiViewController.h"
#import "PiFiiSiderView.h"
#import "REPhotoController.h"
#import "MediaCenterView.h"
#import "MediaCenterViewController.h"
#import "LoginRegisterController.h"
#import "BindView.h"
#import "NetSaveViewController.h"
#import "NetWorkViewController.h"
#import "ScannerViewController.h"
#import "CloudMessage.h"

#define BACKUPCOUNT @"BackupCount"

typedef void(^BoundPiFiiRounter)(BOOL isBound);
@interface MoPiiViewController ()<CCScrollViewTouchDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,ScannerMacDelegate>{
    MediaCenterView         *_centerView;
    PiFiiSiderView          *_siderView;
    UIView                  *bgRoot;
    CCScrollView            *_rootScrollView;
    MBProgressHUD           *stateView;
    NSMutableArray          *_dataImgArr;
    NSMutableArray          *_dataVedioArr;
    NSMutableOrderedSet     *_saveSet;
    NSMutableArray          *_uploadArr;
    BOOL isLogin;
    NSString *pathArchtive;
    BOOL isPause;
    BOOL isMacBounds;
    NSInteger   backupCount;
}

@property (nonatomic,strong) BoundPiFiiRounter boundRounter;
@property (nonatomic,weak)   CCLabel *wifiiTitle;
@property (nonatomic,weak) BindView *bindView;
@property (nonatomic,strong)DeviceEcho    *echo;
@end

@implementation MoPiiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PSLog(@"-----viewDidLoad----");
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    isPause=NO;
//    [self judgeWithLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initWithBase];
    [self getRequestVedio];
    self.navigationController.navigationBarHidden=YES;
    isMacBounds=[GlobalShare isBindMac];
    [_siderView setBindMac:isMacBounds];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    isLogin = [[userDefaultes objectForKey:ISLOGIN] boolValue];
    if (isMacBounds){
        NSString *pifiiTitle=[[NSUserDefaults standardUserDefaults] objectForKey:ROUTERNAME];
        _wifiiTitle.text=pifiiTitle;
    }
}

-(void)judgeWithLogin
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    isLogin = [[userDefaultes objectForKey:ISLOGIN] boolValue];
    if (!isLogin)[self onWifiiClick];
}

- (void)addControl
{
    //弹出绑定提示
    CGFloat gap = 0;
    if (is_iOS7()) {
        
        gap = 20;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    __weak typeof(self) weakSelf = self;
    _rootScrollView = CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 0, 320, ScreenHeight()-20+gap), self, YES);
    _rootScrollView.touchDelegate=self;
    _rootScrollView.bounces = NO;
    _rootScrollView.contentSize = CGSizeMake(320+256, 0);
    [self.view addSubview:_rootScrollView];
    
    CGFloat hf = 457;
    CCScrollView *mediaScrollView = CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 44+gap, 320, CGRectGetHeight(_rootScrollView.frame)-47-44-gap), nil, NO);
    _centerView = [[MediaCenterView alloc]initWithFrame:CGRectMake(0, 0, 320, hf)];
    _centerView.superController=self;
    _centerView.backup=^(NSInteger index){
        [weakSelf backupImageWithIndex:index];
    };
    mediaScrollView.contentSize = CGSizeMake(0, hf);
    [mediaScrollView addSubview:_centerView];
    [_rootScrollView addSubview:mediaScrollView];
    if (!_siderView) {
        _siderView = [[PiFiiSiderView alloc] initWithFrame:CGRectMake(320, 0, 256, CGRectGetHeight(_rootScrollView.frame))];
//        _siderView = [[PiFiiSiderView alloc]initWithFrame:CGRectMake(0, 0, 320, hf)];
//        [setScrollView addSubview:_siderView];
//        [self initGetWithPath:@"phoneServlet" paras:@{@"tradeCode": @(1107),@"method":@(5)} mark:@"AppId" autoRequest:YES];
    }
    _siderView.pushStepViewController = ^(NSInteger index) {
      
        [weakSelf  pushStepViewController:index];
    };
    
    [_rootScrollView addSubview:_siderView];
    
    
    
    CCView *bgTop=[CCView createWithFrame:CGRectMake(0, CGRectGetHeight(_rootScrollView.frame)-47, 320, 47) backgroundColor:RGBCommon(2, 133, 188)];
    CGFloat wx=CGRectGetWidth(self.view.frame)/2;
    CCButton *btnMedia=[CCButton createWithFrame:CGRectMake(0, 0, wx, 47)];
    [btnMedia setImage:[UIImage imageNamed:@"hm_mtzx"] forState:UIControlStateNormal];
    btnMedia.tag=1;
    [btnMedia addTarget:self action:@selector(onMediaClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgTop addSubview:btnMedia];
    
    CCButton *btnNetWork=[CCButton createWithFrame:CGRectMake(wx*2, 0, wx, 47)];
    [btnNetWork setImage:[UIImage imageNamed:@"hm_aqsw"] forState:UIControlStateNormal];
    btnNetWork.tag=2;
    [btnNetWork addTarget:self action:@selector(onMediaClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgTop addSubview:btnNetWork];
    
    [_rootScrollView addSubview:bgTop];
    [self createNav:gap];
    
    bgRoot=[[UIView alloc]initWithFrame:_rootScrollView.frame];
    bgRoot.backgroundColor=[UIColor clearColor];
    bgRoot.hidden=YES;
    [_rootScrollView addSubview:bgRoot];
    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.hidden=YES;
 }

- (void)createNav:(CGFloat)hg
{
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, CGRectGetWidth(_rootScrollView.frame), 44+hg) backgroundColor:RGBCommon(2, 137, 193)]; // RGBCommon(73, 170, 231)
    [navTopView addSubview:CCImageViewCreateWithNewValue(@"hm_wifi", CGRectMake(10, 11.75+hg, 21, 15))];
    NSString *pifiiTitle  = @"未绑定";
    CCLabel *_labTitle = CCLabelCreateWithNewValue(pifiiTitle, 16, CGRectMake(35, hg, 200, 44));
    _labTitle.textColor = RGBWhiteColor();
    _labTitle.backgroundColor = RGBClearColor();
    _wifiiTitle=_labTitle;
    [navTopView addSubview:_labTitle];
    
    CCButton *wifiiBut = CCButtonCreateWithValue(CGRectMake(10, 10+hg, 50, 20), @selector(onMediaClick:), self);
    wifiiBut.backgroundColor=[UIColor clearColor];
    wifiiBut.tag=4;
    [navTopView addSubview:wifiiBut];

    
    CCButton *setBut = CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(_rootScrollView.frame)-35, 7+hg, 30,30), @selector(onMediaClick:), self);
    setBut.tag=3;
    [setBut setImage:[UIImage imageNamed:@"hm_shezhi"] forState:UIControlStateNormal];
    [navTopView addSubview:setBut];
    [_rootScrollView addSubview:navTopView];
}


-(void)initWithBase{
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    _dataImgArr = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    REPhoto *photo = [[REPhoto alloc] init];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
                    NSString *fileName=[[result defaultRepresentation]filename];
                    if ([_saveSet containsObject:fileName]) {
                        photo.isBackup=YES;
                    }
                    photo.imageName=fileName;
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
                    [_dataImgArr addObject:photo];
                }else if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
                    REPhoto *photo = [[REPhoto alloc] init];
                    photo.image = [UIImage imageWithCGImage:result.thumbnail];
                    NSString *fileName=[[result defaultRepresentation]filename];
                    if ([_saveSet containsObject:fileName]) {
                        photo.isBackup=YES;
                    }
                    photo.imageName=fileName;
                    photo.imageUrl=[NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    photo.photoDate = [result valueForProperty:ALAssetPropertyDate];
                    photo.isVedio=YES;
                    NSTimeInterval duration=[[result valueForProperty:ALAssetPropertyDuration] doubleValue];
                    int hours=((int)duration)%(3600*24)/3600;
                    int minus=((int)duration)%(3600*24)/60;
                    int mt=((int)duration)%(3600*24)%60;
                    if (hours==0) {
                        photo.duration=[NSString stringWithFormat:@"%d:%02d",minus,mt];
                    }else{
                        photo.duration=[NSString stringWithFormat:@"%d%d:%02d",hours,minus,mt];
                    }
                    PSLog(@"--[%@]--",fileName);
                    [_dataImgArr addObject:photo];
                }
            }];
        } else {
            [_dataImgArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                REPhoto *item1=(REPhoto *)obj1;
                REPhoto *item2=(REPhoto *)obj2;
                return [item2.photoDate compare:item1.photoDate];
            }];
            [_centerView setError:NO];
            [_centerView setImagePhoto:_dataImgArr];
        }
    } failureBlock:^(NSError *error) {
        for (int i=0; i<3; i++) {
            REPhoto *photo = [[REPhoto alloc] init];
//            photo.image=[UIImage imageNamed:[NSString stringWithFormat:@"hm_qxtb0%d",i+1]];
            photo.image=[UIImage imageNamed:@"hm_qxtb"];
            photo.imageName=@"shezhi";
            photo.isBackup=YES;
            photo.imageUrl=@"hm_tupian";
            photo.photoDate = [NSDate date];
            [_dataImgArr addObject:photo];
        }
        [_centerView setError:YES];
        [_centerView setImagePhoto:_dataImgArr];
    }];
    backupCount=-1;
}


-(void)onMediaClick:(CCButton *)sendar{
    PSLog(@"---%d---",sendar.tag);
    switch (sendar.tag) {
        case 1:{
            MediaCenterViewController *centerController=[[MediaCenterViewController alloc]init];
            centerController.title=@"媒体中心";
            [self.navigationController pushViewController:centerController animated:YES];
            [self setMacBounds];
        }
            break;
        case 2:
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            id password=[user objectForKey:NETPASSWORD];
            if ([password length]>0) {
                NetSaveViewController *saveController=[[NetSaveViewController alloc]init];
                [self.navigationController pushViewController:saveController animated:YES];
            }else{
                NetWorkViewController *workController=[[NetWorkViewController alloc]init];
                [self.navigationController pushViewController:workController animated:YES];
            }
            [self setMacBounds];
        }
            break;
        case 3:
            [self showSider];
            break;
        case 4:
            [self onWifiiClick];
            break;
        default:
            break;
    }
    
}

-(void)onWifiiClick{
    [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:YES] forKey:@"animation"];
    //推入
    LoginRegisterController *loginController=[[LoginRegisterController alloc]init];
    [loginController setCustomAnimation:YES];
    [self.navigationController pushViewController:loginController animated:NO];
    
}



#pragma mark -弹出控制器(Sider)
- (void)pushStepViewController:(NSInteger)index
{
    if (index==2) {
//        if (!isLogin)return;
        if (!_bindView) {
            BindView *bindView=[[BindView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
            self.bindView=bindView;
            [self.view addSubview:bindView];
        }
        _bindView.isBind=isMacBounds;
        [_bindView moveTransiton:YES];
        _bindView.type=^(NSInteger tag,NSString *statue){
            switch (tag) {
                case 1://扫一扫
                {
                    [self.navigationController.view.layer addAnimation:[self customAnimation1:self.view upDown:YES] forKey:@"animation1"];
                    ScannerViewController *svc = [[ScannerViewController alloc]init];
                    svc.type=ScannerMac;
                    svc.delegate=self;
                    [self.navigationController pushViewController:svc animated:NO];
                }
                    break;
                case 2://绑定
                    if (!_echo) {
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请扫一扫要绑定路由设备" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                        return;
                    }
                    [_bindView moveTransiton:NO];
                    [self routerBind:NO Statue:nil];
               
                    break;
                case 3://解绑
                    [_bindView moveTransiton:NO];
                    [self routerBind:YES Statue:statue];
                    break;
                default:
                    [_bindView moveTransiton:NO];
                    break;
            }
            
        };
    }else if(index==3){
        [[[UIAlertView alloc]initWithTitle:@"注销" message:@"注销并返回登录界面?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil]show];
    }else{
        NSArray *pushControllers = @[@"SetupViewController",@"NetSetViewController",@"",@"",@"FeedBackViewController"];
        id  vcInstance = [[pushControllers objectAtIndex:index] instance];
        [self.navigationController.view.layer addAnimation:[self customAnimation:self.view upDown:YES] forKey:@"animation"];
        [vcInstance setCustomAnimation:YES];
        [self.navigationController pushViewController:vcInstance animated:NO];
        [self setMacBounds];
    }
    

}

#pragma mark -绑定与解绑
-(void)routerBind:(BOOL)isBind Statue:(NSString *)statue{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    stateView.hidden=NO;
    if (isBind) { //解绑
        stateView.labelText=[NSString stringWithFormat:@"正在解绑...请稍候!"];
        [self initPostWithPath:@"routerUnBind"
                         paras:@{@"tradeCode": @(1006),
                                 @"user":userPhone,
                                 @"password":statue
                                 }
                          mark:@"unBind"
                   autoRequest:YES];
    }else{ //绑定
         stateView.labelText=[NSString stringWithFormat:@"正在绑定...请稍候!"];
        NSString *mac=[[self.echo.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""]uppercaseString];
        [self initPostWithPath:@"routerBind"
                         paras:@{@"tradeCode": @(1005),
                                 @"user":userPhone,
                                 @"mac":mac,
                                 @"wifiname":self.echo.name
                                 }
                          mark:@"bind"
                   autoRequest:YES];
    }

}

-(void)scannerMacWithDeviceEcho:(DeviceEcho *)echo{
    PSLog(@"-----[%@]-",echo);
    if (echo) {
        self.echo=echo;
        [_bindView.btnScanner setImage:[UIImage imageNamed:@"hm_wifiblack"] forState:UIControlStateNormal];
        [_bindView.btnScanner setTitle:[NSString stringWithFormat:@" %@",echo.name] forState:UIControlStateNormal];
    }
}

#pragma mark -备份图片
-(void)backupImageWithIndex:(NSInteger )index{
    if (index==-1) {
        if (![self setMacBounds])return;
        if(isPause){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否取消备份至媒体中心" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil]show];
        }else{
            _uploadArr=[NSMutableArray array];
            for (REPhoto *photo in _dataImgArr) {
                if (![_saveSet containsObject:photo.imageName]) {
                    [_uploadArr addObject:photo];
                }
            }
            backupCount=_uploadArr.count;
            UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"备份至媒体中心(%d张)",backupCount] otherButtonTitles:nil];
            [action showInView:self.view];
        }
    }else{
        // 1.创建请求管理对象
        if (![self setMacBounds])return;
        stateView.hidden=NO;
        stateView.labelText=[NSString stringWithFormat:@"正在备份...请稍候!"];
        [self uploadWithPhoto:_dataImgArr[index]];
    }

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (backupCount==0) {
            isPause=NO;
            [_centerView.btnMessage alterNormalTitle:@"备份完成"];
        }else{
            isPause=YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backupWithUpdate:) name:BACKUPCOUNT object:nil];
            [_centerView.btnMessage alterNormalTitle:[NSString stringWithFormat:@"备份中...(0/%d)",backupCount]];
            [self uploadWithPhoto:_uploadArr[0]];
        }
//        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        });
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *msg=[alertView buttonTitleAtIndex:buttonIndex];
    if ([msg isEqualToString:@"是"]) {
        isPause=NO;
        [_uploadArr removeAllObjects];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:BACKUPCOUNT object:nil];
        [_centerView.btnMessage alterNormalTitle:[NSString stringWithFormat:@"备份至媒体中心(%d张)",_uploadArr.count]];
    }else if([msg isEqualToString:@"注销"]){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:NETPASSWORD];
        [self onWifiiClick];
    }else{
        [self exitCurrentController];
    }
}

-(void)uploadWithPhoto:(REPhoto *)photo{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:photo.imageUrl] resultBlock:^(ALAsset *asset)
     {
         //在这里使用asset来获取图片
         if (photo.isVedio) {//上传视频
             ALAssetRepresentation *rep = [asset defaultRepresentation];
             PSLog(@"[%lld]",rep.size);
             const int bufferSize = 1024 * 1024;
             Byte *buffer=(Byte *)malloc(bufferSize);
             NSUInteger read=0,offSet=0;
             NSError *error=nil;
             NSMutableData *data=[NSMutableData data];
             if (rep.size!=0) {
                 do {
                     read = [rep getBytes:buffer fromOffset:offSet length:bufferSize error:&error];
                     [data appendBytes:buffer length:read];
                     offSet += read;
                 } while (read!=0&&!error);
             }
             
             // 释放缓冲区，关闭文件
             free(buffer);
             buffer = NULL;
//             if (is_iOS7()&&!stateView.isHidden) {
//                 [self uploadWithVedio:data Photo:photo];
//             }else{
//                 [self uploadWithImage:nil Vedio:data Photo:photo];
//             }
             [self uploadWithVedio:data Photo:photo];
         }else{ // 上传图片
              UIImage *image = [[UIImage alloc]initWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
//              if (image) {
//                  [self uploadWithImage:image Vedio:nil Photo:photo];
//              }
             [self uploadWithVedio:UIImageJPEGRepresentation(image, 1) Photo:photo];
         }
     }
            failureBlock:^(NSError *error)
     {}];
}

-(void)uploadWithImage:(UIImage *)image Vedio:(NSData *)data Photo:(REPhoto *)photo{
    // 1.创建对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"overwrite"] = @"false";
    params[@"token"] = [GlobalShare getToken];
    NSString *url=ROUTER_FILE_UPDOWN;
    if (photo.isVedio) {
        url=ROUTER_FILE_UPVEDIO;
    }
    // 3.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 在发送请求之前调用这个block
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"image/jpeg"];
            }
        }else{
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"video/mp4"];
            }
        }
       
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PSLog(@"--%@--",responseObject);
//        [_dataImgArr removeObject:photo];
//        [_centerView setImagePhoto:_dataImgArr];
        photo.isBackup=YES;
        [_saveSet addObject:photo.imageName];
        [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:pathArchtive];
        [_centerView setImagePhoto:_dataImgArr];
        if(stateView&&!stateView.isHidden){
            stateView.labelText=@"备份成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
        }else{
            [_uploadArr removeObject:photo];
            if (_uploadArr.count==0) {
                isPause=NO;
            }else{
                [self uploadWithPhoto:_uploadArr[0]];
            }
            NSDictionary *param=@{@"count":@(_uploadArr.count),
                                  @"totalCount":@(backupCount),
                                 @"statue":@(isPause)};//备份状态：0代表完成,1代表进行,2表示错误
            [[NSNotificationCenter defaultCenter]postNotificationName:BACKUPCOUNT object:nil userInfo:param];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PSLog(@"--%@--",error);
        if(!stateView.isHidden){
            stateView.labelText=@"备份失败";
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        }else{
            isPause=NO;
            NSDictionary *param=@{@"count":@(_uploadArr.count),
                                  @"totalCount":@(backupCount),
                                  @"statue":@(2)};
            [[NSNotificationCenter defaultCenter]postNotificationName:BACKUPCOUNT object:nil userInfo:param];
        }
    }];
}

#pragma -mark 备份视频
-(void)uploadWithVedio:(NSData *)data Photo:(REPhoto *)photo{
//    NSString *url=ROUTER_FILE_UPVEDIO;
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"overwrite"] = @"false";
    params[@"token"] = [GlobalShare getToken];
    NSString *url=ROUTER_FILE_UPDOWN;
    if (photo.isVedio) {
        url=ROUTER_FILE_UPVEDIO;
    }
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (photo.isVedio) {
            [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"video/mp4"];
        }else{
            [formData appendPartWithFileData:data name:@"file" fileName:photo.imageName mimeType:@"image/jpeg"];
        }
    } error:nil];
    AFURLSessionManager *managers = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [managers uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            PSLog(@"Error: %@", error);
            stateView.labelText=@"备份失败";
            [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
        } else {
            photo.isBackup=YES;
            [_saveSet addObject:photo.imageName];
            [NSKeyedArchiver archiveRootObject:_saveSet.array toFile:pathArchtive];
            [_centerView setImagePhoto:_dataImgArr];
            stateView.labelText=@"备份成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
            PSLog(@"%@ %@--[%@]", response, responseObject,progress);
        }
    }];
    [progress addObserver:self
               forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
    [uploadTask resume];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSProgress *progress = object;
        CGFloat fraction= progress.fractionCompleted;
        NSString *localized=progress.localizedDescription;
        NSString *additional=progress.localizedAdditionalDescription;
        int progressDuration=fraction*100;
        stateView.labelText=[NSString stringWithFormat:@"正在备份...(%d%%)",progressDuration];
        PSLog(@"[%f]--[%@]--[%@]",fraction,localized,additional);
    }];
}


-(void)backupWithUpdate:(NSNotification *)noti{
    NSDictionary *param=noti.userInfo;
    NSInteger count=[param[@"count"] integerValue];
    NSInteger totalCount=[param[@"totalCount"] integerValue];
    NSInteger statue=[param[@"statue"] integerValue];
    if (statue==1) {
        [_centerView.btnMessage alterNormalTitle:[NSString stringWithFormat:@"备份中...(%d/%d)",totalCount-count,totalCount]];
    }else{
        if (statue==0) {
           [_centerView.btnMessage alterNormalTitle:@"备份完成"];
        }else{
           [_centerView.btnMessage alterNormalTitle:@"备份失败,网络异常!"];
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self name:BACKUPCOUNT object:nil];
    }
   
}

//-(BOOL)setMacBounds{
//    __weak typeof(self) weakSelf=self;
//    __block BOOL isBound=NO;
//    self.boundRounter=^(BOOL isBounds){
//        if (!isBounds) {
//            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常或未绑定PiFii路由" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//            isBound=YES;
//        }else{
//            BOOL isConnect=[[[NSUserDefaults standardUserDefaults]objectForKey:ISCONNECT]boolValue];
//            if (!isConnect) {
//                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"未连接绑定PiFii路由" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//                isBound=YES;
//            }
//        }
//    };
//    self.boundRounter(isMacBounds);
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --网络视频请求
-(void)getRequestVedio{
    [self initPostWithURL:CLOUNDURL path:@"mainPageVideo" paras:@{@"recommendation":@"mainpage"} mark:@"cloud" autoRequest:YES];
}


#pragma mark 成功返回数据处理 mark是标识 response结果
- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
//    PSLog(@"--%@--%@",mark,response);
    if([mark isEqualToString:@"cloud"]){
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            _dataVedioArr=[NSMutableArray array];
            NSArray *data=[response objectForKey:@"data"];
            if (data) {
                for (int i=0; i<data.count; i++) {
                    NSDictionary *cloudData=data[i];
                    if (cloudData) {
                        CloudMessage *msg=[[CloudMessage alloc]initWithData:cloudData];
                        [_dataVedioArr addObject:msg];
                    }
                }
            }
            [_centerView setCloudVedio:_dataVedioArr];
            PSLog(@"--%@--%d",_dataVedioArr[0],_dataVedioArr.count);
        }
    }else if ([mark isEqualToString:@"bind"]) {
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            [self bindMac:YES DeviceEcho:self.echo];
            stateView.labelText=@"绑定成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:1.5];
        }else{
            NSString *msg=[response objectForKey:@"desc"];
            if (isNIL(msg)) {
                msg=@"网络异常，请检查网络!";
            }
            stateView.labelText=msg;
            [self performSelector:@selector(setStateView:) withObject:@"error" afterDelay:0.5];
        }
    }else if([mark isEqualToString:@"unBind"]){
        NSNumber *returnCode=[response objectForKey:@"returnCode"];
        if ([returnCode intValue]==200) {
            [self bindMac:NO DeviceEcho:nil];
            stateView.labelText=@"解绑成功";
            [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:1.5];
        }else{
            NSString *msg=[response objectForKey:@"desc"];
            if (isNIL(msg)) {
                msg=@"网络异常，请检查网络!";
            }
            stateView.labelText=msg;
            [self performSelector:@selector(setStateView:) withObject:@"error" afterDelay:0.5];
        }
    }
    
}

- (void)handleRequestFail:(NSError *)error mark:(NSString *)mark
{
    NSDictionary *param=error.userInfo;
    if ([mark isEqualToString:@"bind"]) {
        stateView.labelText=[NSString stringWithFormat:@"%@,绑定失败",param[@"error"]];
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }else if([mark isEqualToString:@"unBind"]){
        stateView.labelText=[NSString stringWithFormat:@"%@,解绑失败",param[@"error"]];
        [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
    }
    PSLog(@"失败: %@",error);
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:0.3 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            //            [self exitCurrentController];
        }
        
    }];
}


#pragma mark 滑动界面的显示
- (void)showSider
{
    CGFloat offset = 256;
    if (_rootScrollView.contentOffset.x==256)offset = 0;
    [self scrollViewWithOffset:offset];
}

-(void)scrollViewWithOffset:(CGFloat)move{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    if (move==256) {
        bgRoot.hidden=NO;
    }else{
        bgRoot.hidden=YES;
    }
    _rootScrollView.contentOffset = CGPointMake(move, 0);
    [UIView commitAnimations];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_rootScrollView.contentOffset.x==256) {
        bgRoot.hidden=NO;
    }else{
        bgRoot.hidden=YES;
    }
}


-(void)scrollViewWithTouch:(NSSet *)touches withEvent:(UIEvent *)event scrollView:(id)scrollView{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.view];
    CGRect rect=CGRectMake(0, 0, 64, 568);
    if (CGRectContainsPoint(rect, point)&&_rootScrollView.contentOffset.x==256) {
        [self scrollViewWithOffset:0];
        return;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;
}


-(CATransition *)customAnimation1:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    animation.type = @"oglFlip";//101
    if (boolUpDown) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    return animation;
}

-(CATransition *)customAnimation2:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //display mode, slow at beginning and end
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //过渡效果
    animation.type = @"pageUnCurl";
    //过渡方向
    animation.subtype = kCATransitionFromRight;
    //暂时不知,感觉与Progress一起用的,如果不加,Progress好像没有效果
    animation.fillMode = kCAFillModeBackwards;
    //动画开始(在整体动画的百分比).
    animation.startProgress = 0.3;
    if (boolUpDown) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    return animation;
}

-(CATransition *)customAnimation3:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //display mode, slow at beginning and end
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //过渡效果
    animation.type = kCATransitionMoveIn;
    //过渡方向
    animation.subtype = kCATransitionFromTop;
    if (boolUpDown) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    return animation;
}

-(void)bindMac:(BOOL)isBind DeviceEcho:(DeviceEcho *)deviceEcho{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (isBind) {
        _wifiiTitle.text=deviceEcho.name;
        [user setObject:deviceEcho.token forKey:TOKEN];
        [user setObject:deviceEcho.hostIP forKey:ROUTERIP];
        [user setObject:deviceEcho.macAddr forKey:ROUTERMAC];
        [user setObject:deviceEcho.name forKey:ROUTERNAME];
        [user setObject:@YES forKey:BOUNDMAC];
        [user setObject:@YES forKey:ISCONNECT];
        [user synchronize];
    }else{
        _wifiiTitle.text=@"未绑定";
        [user removeObjectForKey:TOKEN];
        [user removeObjectForKey:ROUTERIP];
        [user removeObjectForKey:ROUTERMAC];
        [user removeObjectForKey:ROUTERNAME];
        [user removeObjectForKey:BOUNDMAC];
    }
    isMacBounds=isBind;
    [_siderView setBindMac:isMacBounds];
//    [self getImg];//获取绑定的图片
}

@end
