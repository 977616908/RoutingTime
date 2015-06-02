//
//  HtmlViewController.h
//  FlowTT_Home
//
//  Created by HXL on 14-4-30.
//  Copyright (c) 2014年 HXL. All rights reserved.
//



@interface HtmlViewController : PiFiiBaseViewController<UIWebViewDelegate>
{
@private
    UIActivityIndicatorView *_avc;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong) NSString *url;

@property (strong, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UILabel *sourceName;
@property(strong,nonatomic)NSString * myTitle;
- (IBAction)downloadAction:(id)sender;
@end
