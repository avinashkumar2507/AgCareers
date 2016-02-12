//
//  SettingViewController.h
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIALinkedInHttpClient.h"

@interface SettingViewController : UIViewController{
    LIALinkedInHttpClient *client;
}

- (IBAction)buttonActionFacebook:(id)sender;
- (IBAction)buttonActionTwitter:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewJobs;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEmployers;


@end
