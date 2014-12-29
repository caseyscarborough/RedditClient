//
//  SubredditSearchViewController.h
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "CustomUITableViewCell.h"
#import "AFNetworking.h"
#import "NSString+HTML.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PostTabBarViewController.h"

@interface SubredditSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *posts;
@end
