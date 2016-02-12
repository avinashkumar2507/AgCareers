//
//  GoogleDriveViewController.h
//  AgCareers
//
//  Created by Unicorn on 18/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrEditFileEditDelegate.h"
@interface GoogleDriveViewController : UIViewController<DrEditFileEditDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UIRefreshControl *refreshControl;
    UIAlertView *alertDownload;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;

- (IBAction)buttonActionCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *googleDriveTableView;
@end
