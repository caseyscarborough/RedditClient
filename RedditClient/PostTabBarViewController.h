//
//  PostTabBarViewController.h
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostTabBarViewController : UITabBarController
@property (strong, nonatomic) Post *currentPost;
@end
