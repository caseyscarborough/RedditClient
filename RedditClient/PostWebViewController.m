//
//  PostWebViewController.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "PostWebViewController.h"

@interface PostWebViewController ()

@end

@implementation PostWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scalesPageToFit = YES;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    if (self.currentPost) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.currentPost.url];
        [self.webView loadRequest:urlRequest];
    }
    self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
