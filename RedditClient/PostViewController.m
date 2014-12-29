//
//  PostViewController.m
//  RedditClient
//
//  Created by Casey Scarborough on 12/29/14.
//  Copyright (c) 2014 Casey Scarborough. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()
- (void)retrieveFrontPagePosts;
@end

@implementation PostViewController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Front Page";
    // Reddit navbar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(82/255.0) green:(138/255.0) blue:(220/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.hidden = YES;
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];
    [self retrieveFrontPagePosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retrieveFrontPagePosts {
    NSString *apiEndpoint = @"http://www.reddit.com/.json";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET: apiEndpoint parameters: nil success: ^(AFHTTPRequestOperation *operation, id responseObject){
        self.posts = [[NSMutableArray alloc] init];
        NSArray *jsonPosts = [((NSDictionary *)[responseObject objectForKey:@"data"]) objectForKey:@"children"];
        for (NSDictionary *jsonPost in jsonPosts) {
            NSDictionary *jsonData = jsonPost[@"data"];
            Post *post = [[Post alloc] init];
            post.title = jsonData[@"title"];
            post.thumbnail = jsonData[@"thumbnail"];
            post.upvotes = [jsonData[@"ups"] integerValue];
            post.comments = [jsonData[@"num_comments"] integerValue];
            [self.posts addObject:post];
        }
        [self.tableView reloadData];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd upvotes - %zd comments", post.upvotes, post.comments];
    if (![post.thumbnail isEqualToString:@""]) {
        CGSize itemSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [cell.imageView sd_setImageWithURL:post.thumbnailUrl placeholderImage:[UIImage imageNamed:@"reddit"]];
    }
    return cell;
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
