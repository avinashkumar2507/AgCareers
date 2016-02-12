//
//  SavedJobsViewController.h
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedJobsViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    Parser *jsonParser;
    MBProgressHUD *HUD;
    UIAlertView *alertLogout,*alertForLogin;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonLogOff;

- (IBAction)buttonActionLogOff:(id)sender;


@end
