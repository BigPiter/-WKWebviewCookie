//
//  ViewController.m
//  webDemo
//
//  Created by ZhangJitao on 2018/5/24.
//  Copyright © 2018年 web.demo. All rights reserved.
//

#import "ViewController.h"
#import "webViewController.h"
#import "WkwebViewController.h"
#import "CookieManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CookieManager shareInstance].domain = @"http://wsq.demo.comsenz-service.com/";
    [CookieManager shareInstance].cookieKey = @"token";
    [CookieManager shareInstance].cookieValue = @"82130300-60a8b793cfd44f9183e9d341133b7e94";
    [[CookieManager shareInstance] setWebCookie];
    
    [[CookieManager shareInstance] setWkCookie:[WKWebView new] completionHandler:nil];
    
}

 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([[segue identifier] isEqualToString:@"webview"]) {
         webViewController *webVc = segue.destinationViewController;
         webVc.urlString = @"http://wsq.demo.comsenz-service.com/plugin.php?id=iwechat:index#!";
     } else if ([[segue identifier] isEqualToString:@"wkwebview"]) {
         WkwebViewController *wkwebVC = segue.destinationViewController;
         wkwebVC.urlString = @"http://wsq.demo.comsenz-service.com/plugin.php?id=iwechat:index#!";
         
     }

 }


@end
