//
//  webViewController.m
//  webDemo
//
//  Created by ZhangJitao on 2018/5/24.
//  Copyright © 2018年 web.demo. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}


@end
