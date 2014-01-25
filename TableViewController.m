//
//  TableViewController.m
//  BlogReader
//
//  Created by Amit Bijlani on 12/6/12.
//  Copyright (c) 2012 Amit Bijlani. All rights reserved.
//

#import "TableViewController.h"
#import "BlogPost.h"
#import "WebViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    PFObject *gameScore = [PFObject objectWithClassName:@"posts"];
    gameScore[@"id"] = @22901;
    gameScore[@"title"] = @"Why You Should Use Continuous Integration and Continuous Deployment";
    gameScore[@"author"] = @"Florian Motlik";
    gameScore[@"thumbnail"] = @"http://blog.teamtreehouse.com/wp-content/uploads/2014/01/idea-execution-150x150.png";
    gameScore[@"date"] = @"2014-01-24 09:00:49";
    gameScore[@"url"] = @"http://blog.teamtreehouse.com/use-continuous-integration-continuous-deployment";
    [gameScore saveInBackground];
     */
    
    PFQuery *query = [PFQuery queryWithClassName:@"posts"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            //NSLog(@"%@", objects);
            //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:objects];
           
            //NSArray *keys = [NSArray arrayWithObjects:@"key",nil];
            //NSLog(@"%@", keys);
            //NSArray *object = [NSArray arrayWithObjects:objects,nil];
            //NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
            //NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:object options:0 error:&error];
            //NSLog(@"%@", dataDictionary);
            self.blogPosts = [NSMutableArray array];
            
            //NSArray *blogPostsArray = [dataDictionary objectForKey:@"posts"];
            //NSLog(@"%@", blogPostsArray);
            
            for (NSDictionary *bpDictionary in objects) {
                NSLog(@"%@", [NSURL URLWithString:[bpDictionary objectForKey:@"url"]]);
                BlogPost *blogPost = [BlogPost blogPostWithTitle:[bpDictionary objectForKey:@"title"]];
                blogPost.author = [bpDictionary objectForKey:@"author"];
                blogPost.thumbnail = [bpDictionary objectForKey:@"thumbnail"];
                blogPost.date = [bpDictionary objectForKey:@"date"];
                blogPost.url = [NSURL URLWithString:[bpDictionary objectForKey:@"url"]];
                [self.blogPosts addObject:blogPost];
                [self.tableView reloadData];
            }
            // Do something with the found objects
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
            }
            //**refresh
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //NSURL *blogURL = [NSURL URLWithString:@"http://blog.teamtreehouse.com/api/get_recent_summary/"];
    
    //NSData *jsonData = [NSData dataWithContentsOfURL:blogURL];
    
    //NSLog(@"json file = %@", jsonData);
    
    //NSError *error = nil;
    
    //NSArray *keys = [NSArray arrayWithObjects:@"key1", @"key2", nil];
    //NSArray *objects = [NSArray arrayWithObjects:@"value1", @"value2", nil];
    //NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           //forKeys:keys];
    
    //NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    //NSLog(@"%@",dataDictionary);
    
    /*
    self.blogPosts = [NSMutableArray array];
    
    NSArray *blogPostsArray = [dataDictionary objectForKey:@"posts"];
    
    for (NSDictionary *bpDictionary in blogPostsArray) {
        BlogPost *blogPost = [BlogPost blogPostWithTitle:[bpDictionary objectForKey:@"title"]];
        blogPost.author = [bpDictionary objectForKey:@"author"];
        blogPost.thumbnail = [bpDictionary objectForKey:@"thumbnail"];
        blogPost.date = [bpDictionary objectForKey:@"date"];
        blogPost.url = [NSURL URLWithString:[bpDictionary objectForKey:@"url"]];
        [self.blogPosts addObject:blogPost];
    }
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.blogPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"table view begin");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
    NSLog(@"%@", blogPost);

    if ( [blogPost.thumbnail isKindOfClass:[NSString class]]) {
        NSData *imageData = [NSData dataWithContentsOfURL:blogPost.thumbnailURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        cell.imageView.image = image;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"treehouse.png"];
    }
    cell.textLabel.text = blogPost.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",blogPost.author,[blogPost formattedDate]];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSLog(@"preparing for segue: %@",segue.identifier);
    
    if ( [segue.identifier isEqualToString:@"showBlogPost"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
        WebViewController *wbc = (WebViewController *)segue.destinationViewController;
        wbc.blogPostURL = blogPost.url;

    }
}







@end
