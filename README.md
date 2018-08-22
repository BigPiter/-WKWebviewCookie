# WKWebviewCookie

#### 项目介绍
webview和WKWebview传递cookie的方法


#### 使用说明

1. Webview通过NSHTTPCookieStorage 直接传递cookie；
2. WKWebview三个处理步骤：

    （1）.iOS11，WKHTTPCookieStore 直接传递。（如果是只支持iOS11，下面两步可以不做）；
    （2）.iOS8-iOS10， js注入；
    （3）.PHP携带cookie方式。具体见demo
