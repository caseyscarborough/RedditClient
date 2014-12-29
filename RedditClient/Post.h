//
//  Post.h
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property (strong, nonatomic) NSString *subreddit;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *permalink;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger createdUtc;
@property (assign, nonatomic) NSInteger upvotes;
@property (assign, nonatomic) NSInteger comments;
- (NSURL *) url;
- (NSURL *) permalinkUrl;
@end