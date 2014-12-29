//
//  PostCommentsViewController.h
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "NSString+HTML.h"
#import "AFNetworking.h"

@interface PostCommentsViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) Post *currentPost;
@end
