//
//  ZeroCenterViewCtr.m
//  RoutingTime
//
//  Created by HXL on 14-6-5.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WoEditViewController.h"
#import "CEButton.h"

#define BUTTONHEIGHT 75

@interface WoEditViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak)CCTableView *woTable;
@property (nonatomic,weak)CEButton *selectBtn;
@property (nonatomic,strong)UIImagePickerController *imagePicker;
@end

@implementation WoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

-(void)createView{
    CGFloat gh=44;
    if(is_iOS7()){
        gh+=20;
    }
    self.title=@"编辑信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onComplete)];
    CCTableView *woTable=CCTableViewCreateStyleGroup(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh), self);
    self.woTable=woTable;
    woTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:woTable];
}


-(void)onComplete{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_jiantou"]];
    }
    NSArray *arr=@[@"头像",@"昵称",@"性别"];
    NSInteger row=indexPath.row;
    cell.textLabel.text=arr[row];
    
    CEButton *btnContent=[[CEButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame)-35, CGRectGetHeight(cell.frame))];
    btnContent.tag=row;
    if (row==0) {
        [btnContent setImageName:@"hm_touxiang"];
    }else if(row==1){
        [btnContent setTitleName:@"可爱宝贝"];
    }else{
        [btnContent setTitleName:@"女"];
    }
    [btnContent addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnContent];
    return cell;
}

-(void)onClick:(CEButton *)sendar{
    self.selectBtn=sendar;
    UIActionSheet *action=nil;
    switch (sendar.tag) {
        case 0:
            action=[[UIActionSheet alloc]initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
            action.tag=0;
            [action showInView:self.view];
            break;
        case 1:{
            UIAlertView *dialog=[[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            dialog.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *textContent = [dialog textFieldAtIndex:0];
            textContent.font=[UIFont systemFontOfSize:16.0];
            textContent.textColor=RGBCommon(52, 52, 52);
            textContent.placeholder=@"请输入呢称";
            textContent.text=sendar.titleLabel.text;
            [dialog show];
        }
            break;
        case 2:
            action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"未知" otherButtonTitles:@"男",@"女", nil];
            action.tag=1;
            [action showInView:self.view];
            break;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70.0f;
    }else{
        return 44.0f;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     UITextField *textContent = [alertView textFieldAtIndex:0];
    if (buttonIndex==1) {
        [_selectBtn setTitleName:textContent.text];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    PSLog(@"---[%d]--[%d]-",buttonIndex,actionSheet.tag);
    NSInteger tag=actionSheet.tag;
    switch (buttonIndex) {
        case 0://未知
            if (tag==0) {//拍照
                [self openCamera];
            }else{
               [_selectBtn setTitleName:@"未知"];
            }
            break;
        case 1://男
            if (tag==0) {//选择相册
                [self openPics];
            }else{
                [_selectBtn setTitleName:@"男"];
            }
            
            break;
        case 2://女
            if(tag!=0)[_selectBtn setTitleName:@"女"];
            break;
    }
}

// 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (_imagePicker == nil) {
            _imagePicker =  [[UIImagePickerController alloc] init];
        }
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.showsCameraControls = YES;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

// 打开相册
- (void)openPics {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
    _imagePicker = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *theImage = nil;
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
            
        }
        [self.selectBtn setImage:theImage forState:UIControlStateNormal];
    }
}

@end
