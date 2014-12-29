//
//  PostTabBarViewController.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "PostTabBarViewController.h"

@interface PostTabBarViewController ()

@end

@implementation PostTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(42/255.0) green:(68/255.0) blue:(94/255.0) alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    for (UIViewController* controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(setCurrentPost:)]) {
            [controller performSelector:@selector(setCurrentPost:) withObject:self.currentPost];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
