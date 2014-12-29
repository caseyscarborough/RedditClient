//
//  Post.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "Post.h"

@implementation Post
- (NSURL *)url {
    return [NSURL URLWithString:self.urlString];
}

- (NSURL *)permalinkUrl {
    return [NSURL URLWithString:self.permalink];
}

- (NSURL *)thumbnailUrl {
    return [NSURL URLWithString:self.thumbnail];
}
@end
