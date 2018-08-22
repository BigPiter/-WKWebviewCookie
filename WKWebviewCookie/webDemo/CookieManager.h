//
//  CookieManager.h
//  webDemo
//
//  Created by ZhangJitao on 2018/8/21.
//  Copyright © 2018年 web.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface CookieManager : NSObject

@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *cookieKey;
@property (nonatomic, strong) NSString *cookieValue;


+ (instancetype)shareInstance;

#pragma mark - WKWebview
// iOS11
- (void)setWkCookie:(WKWebView *)wkWebview completionHandler:(nullable void (^)(void))comple;

// iOS11之前
// JS携带cookie的形式
- (void)setWkJsCookie:(WKUserContentController *)userContentController;

// PHP携带cookie的形式
- (void)setWkPHPCookie:(NSMutableURLRequest *)request;

#pragma mark - Webview
// 客户端添加cookie
- (void)setWebCookie;


@end
