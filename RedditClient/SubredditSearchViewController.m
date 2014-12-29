//
//  SubredditSearchViewController.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "SubredditSearchViewController.h"

@interface SubredditSearchViewController () {
}
- (void)retrieveSubredditPosts:(id)sender forSubreddit:(NSString *)subreddit;
@end

@implementation SubredditSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.activityIndicator.hidden = YES;
    self.searchField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.currentSubreddit != nil) {
        self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"/r/%@", self.currentSubreddit];
        return;
    }
    self.navigationController.navigationBar.topItem.title = @"Search for Subreddit";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchField) {
        [self.searchField resignFirstResponder];
        [self retrieveSubredditPosts:self forSubreddit:self.searchField.text];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"subredditPostCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CustomUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"post"];
    }
    Post *post = [self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd upvotes - %zd comments - /r/%@", post.upvotes, post.comments, post.subreddit];
    if (![post.thumbnail isEqualToString:@""]) {
        CGSize itemSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [cell.imageView sd_setImageWithURL:post.thumbnailUrl placeholderImage:[UIImage imageNamed:@"reddit"]];
    }
    return cell;
}

- (void)retrieveSubredditPosts:(id)sender forSubreddit:(NSString *)subreddit {
    self.activityIndicator.hidden = NO;
    self.tableView.hidden = YES;
    self.errorLabel.hidden = YES;
    NSString *apiEndpoint = [NSString stringWithFormat:@"http://www.reddit.com/r/%@.json", subreddit];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET: apiEndpoint parameters: nil success: ^(AFHTTPRequestOperation *operation, id responseObject){
        self.posts = [[NSMutableArray alloc] init];
        NSArray *jsonPosts = [((NSDictionary *)[responseObject objectForKey:@"data"]) objectForKey:@"children"];
        if (jsonPosts.count == 0) {
            self.errorLabel.text = @"There are no posts in this subreddit.";
            self.errorLabel.hidden = NO;
        } else {
            for (NSDictionary *jsonPost in jsonPosts) {
                NSDictionary *jsonData = jsonPost[@"data"];
                Post *post = [[Post alloc] init];
                post.ID = jsonData[@"id"];
                post.title = [jsonData[@"title"] stringByDecodingHTMLEntities];
                post.thumbnail = jsonData[@"thumbnail"];
                post.upvotes = [jsonData[@"ups"] integerValue];
                post.comments = [jsonData[@"num_comments"] integerValue];
                post.subreddit = jsonData[@"subreddit"];
                post.urlString = jsonData[@"url"];
                post.isSelf = ([jsonData[@"is_self"] integerValue] == 1);
                post.permalink = jsonData[@"permalink"];
                if (!([jsonData objectForKey:@"selftext"] == (id)[NSNull null])) {
                    post.selfText = [jsonData objectForKey:@"selftext"];
                }
                [self.posts addObject:post];
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        self.activityIndicator.hidden = YES;
        self.currentSubreddit = subreddit;
        self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"/r/%@", subreddit];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.tableView.hidden = YES;
        self.activityIndicator.hidden = YES;
        self.errorLabel.text = @"Could not find that subreddit. Please try again.";
        self.errorLabel.hidden = NO;
        self.currentSubreddit = nil;
        self.navigationController.navigationBar.topItem.title = @"";
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showLink"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Post *currentPost = [self.posts objectAtIndex:indexPath.row];
        [[segue destinationViewController] setCurrentPost:currentPost];
    }
}

@end
