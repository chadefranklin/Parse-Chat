//
//  ChatViewController.m
//  Parse-Chat
//
//  Created by chadfranklin on 7/6/20.
//  Copyright © 2020 chadfranklin. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (nonatomic, strong) NSArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}

- (IBAction)onSendPressed:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2020"];
    
    // Use the name of your outlet to get the text the user typed
    chatMessage[@"text"] = self.chatMessageField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatMessageField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 20;
    return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    PFObject *chatMessage = self.chats[indexPath.row];
    
    cell.chatLabel.text = chatMessage[@"text"];
    
    PFUser *user = chatMessage[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
        
    return cell;
}


- (void)onTimer {
   // Add code to be run periodically
    [self queryChat];
}

- (void)queryChat{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2020"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.chats = posts;
            [self.chatTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
