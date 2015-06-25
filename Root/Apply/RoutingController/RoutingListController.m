//
// REPhotoCollectionController.m
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RoutingListController.h"
#import "REPhotoThumbnailsCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define BARHEIGHT 44


@interface RoutingListController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *tableImg;
    NSMutableArray *_photoArr;
    NSMutableArray *_datasource;
    NSMutableOrderedSet  *_upArray;
    MBProgressHUD   *stateView;
}

@property(nonatomic,weak)CCButton *btnSelect;

@end

@implementation RoutingListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];

}

-(void)initView{
    CGFloat gh=44;
    if (is_iOS7()) {
        gh+=20;
    }
    tableImg=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    tableImg.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableImg.showsVerticalScrollIndicator=NO;
    tableImg.delegate=self;
    tableImg.dataSource=self;
    [self.view addSubview:tableImg];
    self.title=@"选择照片";
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark 网络请求
- (void)getRequest{
    if(!stateView){
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        stateView.removeFromSuperViewOnHide=YES;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userData= [user objectForKey:USERDATA];
    NSString *userPhone=userData[@"userPhone"];
    [self initPostWithURL:ROUTINGTIMEURL path:@"getAllPhotosByUserName" paras:@{@"username":userPhone} mark:@"routing" autoRequest:YES];
}


- (void)reloadData
{
    _photoArr=[NSMutableArray array];
    _upArray=[NSMutableOrderedSet orderedSet];
 
    NSMutableArray *arrType=[NSMutableArray array];
    for (REPhoto *photo in arrType) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.photoDate];
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in _photoArr) {
                if (group.month == month && group.year == year)
                    return group;
            }
            return nil;
        }();
        if (group == nil) {
            group = [[REPhotoGroup alloc] init];
            group.month=month;
            group.year=year;
            [group.items addObject:photo];
            [_photoArr addObject:group];
        }else {
            [group.items addObject:photo];
        }
    }
    [tableImg reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_photoArr count] == 0) return 0;
    if ([self tableView:tableImg numberOfRowsInSection:[_photoArr count] - 1] == 0) {
        return [_photoArr count] - 1;
    }
    return [_photoArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:section];
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.superController=self;
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:indexPath.section];
    if (group) {
        NSArray *array=group.items;
        int startIndex = indexPath.row * 4;
        int endIndex = startIndex + 4;
        if (endIndex > [array count])
            endIndex = [array count];
        [cell removeAllPhotos];
        for (int i = startIndex; i < endIndex; i++) {
            REPhoto *photo = [group.items objectAtIndex:i];
            [cell addPhoto:photo];
        }
        cell.arryGroup=array;
        cell.photoType=REPhotoSelect;
        cell.selectOrder=_upArray;
        
        [cell refresh];
        //        [cell addPhotoWithArray:group.itemAll];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_photoArr objectAtIndex:section];
    NSString *content=[NSString stringWithFormat:@"%d年%d月 共%d张",group.year,group.month,[group.items count]];
    return content;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
