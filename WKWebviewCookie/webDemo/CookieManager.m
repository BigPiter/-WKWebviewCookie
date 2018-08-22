//
//  CookieManager.m
//  webDemo
//
//  Created by ZhangJitao on 2018/8/21.
//  Copyright © 2018年 web.demo. All rights reserved.
//

#import "CookieManager.h"

@implementation CookieManager

+ (instancetype)shareInstance {
    static CookieManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CookieManager alloc] init];
    });
    return manager;
}

#pragma mark - WKWebview
// iOS11
- (void)setWkCookie:(WKWebView *)wkWebview completionHandler:(nullable void (^)(void))comple {
    
    NSURL *cookieHost = [NSURL URLWithString:self.domain];
    // 设定 cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [cookieHost host], NSHTTPCookieDomain,
                             [cookieHost path], NSHTTPCookiePath,
                             self.cookieKey,  NSHTTPCookieName,
                             self.cookieValue, NSHTTPCookieValue,
                             //                             [NSDate dateWithTimeIntervalSinceNow:30*60*60],NSHTTPCookieExpires,
                             nil]];
    
    // 加入cookie
    //发送请求前插入cookie；
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = wkWebview.configuration.websiteDataStore.httpCookieStore;
        [cookieStore setCookie:cookie completionHandler:^{
            
            comple?comple():nil;
        }];
    } else {
        
        
    }
    
    //    WKHTTPCookieStore *cookieStore = self.webview.configuration.websiteDataStore.httpCookieStore;
    //    //get cookies
    //    [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
    //        NSLog(@"All cookies %@",cookies);
    //    }];
    //    [[wkhttp sharedHTTPCookieStorage] setCookie:cookie];
}

// JS携带cookie的形式
- (void)setWkJsCookie:(WKUserContentController *)userContentController {
    // 单个cookie，多个的话，再加上document.cookie ='%@=%@';一次
    NSString *cookieStr = [NSString stringWithFormat:@"document.cookie ='%@=%@';",self.cookieKey,self.cookieValue];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
}

// PHP携带cookie的形式
- (void)setWkPHPCookie:(NSMutableURLRequest *)request {
    //通过host关联cookie。
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    if ([cookieDic objectForKey:[CookieManager shareInstance].cookieKey]) {
        [cookieDic removeObjectForKey:[CookieManager shareInstance].cookieKey];
    }
    
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    
    [cookieValue appendString:[NSString stringWithFormat:@"%@ = %@;",self.cookieKey,self.cookieValue]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
}



#pragma mark - Webview
// 客户端添加cookie
- (void)setWebCookie {
    
    NSURL *cookieHost = [NSURL URLWithString:self.domain];
    // 设定 cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [cookieHost host], NSHTTPCookieDomain,
                             [cookieHost path], NSHTTPCookiePath,
                             self.cookieKey,  NSHTTPCookieName,
                             self.cookieValue, NSHTTPCookieValue,
                             nil]];
    // 加入cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}
@end
