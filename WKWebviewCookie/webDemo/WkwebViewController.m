//
//  WkwebViewController.m
//  webDemo
//
//  Created by ZhangJitao on 2018/5/25.
//  Copyright © 2018年 web.demo. All rights reserved.
//

#import "WkwebViewController.h"
#import <WebKit/WebKit.h>
#import "CookieManager.h"

@interface WkwebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webview;
@end

@implementation WkwebViewController

- (void)loadView {
    [super loadView];
    
    WKUserContentController* userContentController = WKUserContentController.new;
    // JS携带cookie的形式
    [[CookieManager shareInstance] setWkJsCookie:userContentController];
    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    webViewConfig.userContentController = userContentController;
    
    self.webview = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webViewConfig];
    self.webview.navigationDelegate = self;
    self.view = self.webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cookieandRequest];
}

- (void)cookieandRequest {
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    if (@available(iOS 11.0, *)) {
        [[CookieManager shareInstance] setWkCookie:self.webview completionHandler:^{
            [weakSelf.webview loadRequest:request];
        }];
    } else {
        // PHP携带cookie的形式
        [[CookieManager shareInstance] setWkPHPCookie:request];
        [self.webview loadRequest:request];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStore setCookie:cookie];
        }
    });
   decisionHandler(WKNavigationResponsePolicyAllow);
}


@end
