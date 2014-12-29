//
//  PostWebViewController.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "LinkWebViewController.h"

@interface LinkWebViewController ()

@end

@implementation LinkWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    if (self.currentPost) {
        if (self.currentPost.isSelf) {
            self.tabBarController.tabBar.hidden = YES;
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.currentPost.url];
        [self.webView loadRequest:urlRequest];
    }
    self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}

@end
