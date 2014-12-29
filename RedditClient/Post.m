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
    NSString *fullPermalink = [NSString stringWithFormat:@"http://reddit.com%@", self.permalink];
    return [NSURL URLWithString:fullPermalink];
}

- (NSURL *)thumbnailUrl {
    return [NSURL URLWithString:self.thumbnail];
}
@end
