//
//  PostViewController.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()
- (void)retrieveFrontPagePosts:(id)sender after:(NSString *)postId;
@property (nonatomic) CGRect originalFrame;
@end

@implementation PostViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.posts = [[NSMutableArray alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(42/255.0) green:(68/255.0) blue:(94/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Set status bar to have white text
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Set tab bar to have white text on dark background
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(42/255.0) green:(68/255.0) blue:(94/255.0) alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    UITabBar *tb = self.tabBarController.tabBar;
    
    NSLog(@"%f - %f", tb.frame.origin.y, tb.frame.size.height);
    self.originalFrame = CGRectMake(tb.frame.origin.x, tb.frame.origin.y - tb.frame.size.height - 15, tb.frame.size.width, tb.frame.size.height);

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.hidden = YES;

    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    [self retrieveFrontPagePosts:self after:nil];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self retrieveFrontPagePosts:self after: ((Post *)[self.posts objectAtIndex:(self.posts.count - 1)]).ID];
    }];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self retrieveFrontPagePosts:self after:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"Front Page";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITabBar *tb = self.tabBarController.tabBar;
    NSInteger yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        tb.frame = CGRectMake(tb.frame.origin.x, self.originalFrame.origin.y + yOffset, tb.frame.size.width, tb.frame.size.height);
    }
    if (yOffset < 1) tb.frame = self.originalFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)retrieveFrontPagePosts:(id)sender after:(NSString *)postId {
    NSString *apiEndpoint = @"http://www.reddit.com/.json";
    if (postId) {
        apiEndpoint = [NSString stringWithFormat:@"%@?count=25&after=%@", apiEndpoint, postId];
    }
    
    NSMutableArray *newPosts = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET: apiEndpoint parameters: nil success: ^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSArray *jsonPosts = [((NSDictionary *)[responseObject objectForKey:@"data"]) objectForKey:@"children"];
        for (NSDictionary *jsonPost in jsonPosts) {
            NSDictionary *jsonData = jsonPost[@"data"];
            Post *post = [[Post alloc] init];
            post.ID = jsonData[@"name"];
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
            [newPosts addObject:post];
        }
        
        if (postId) {
            // Continuous scrolling
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            int i = (int)self.posts.count;
            [self.posts addObjectsFromArray:newPosts];
            for (Post *post in newPosts) {
                [paths addObject:[NSIndexPath indexPathForRow:i++ inSection:0]];
            }
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [self.tableView.infiniteScrollingView stopAnimating];
        } else {
            self.posts = newPosts;
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        }
        
        self.activityIndicator.hidden = YES;
        self.tableView.hidden = NO;
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showLink"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Post *currentPost = [self.posts objectAtIndex:indexPath.row];
        [[segue destinationViewController] setCurrentPost:currentPost];
    }
}

@end
