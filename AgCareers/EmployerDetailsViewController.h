//
//  EmployerDetailsViewController.h
//  AgCareers
//
//  Created by Unicorn on 14/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    APParser *jsonParser,*jsonParser1,*jsonParser2,*jsonParser3;
    MBProgressHUD *HUD,*HUD1;
    NSDictionary *JSONDict;
    NSArray *arrayJobsListing;
    UIActionSheet *myActionSheet;
    UIBarButtonItem *backButton,*saveButton;
    UIBarButtonItem *shareBarButton;
    UIAlertView *alertForNoDetails,*alertLogin,*alertPromt,*alertForCheck;
}

@property (strong,nonatomic)NSString *stringEmployerId;
@property (strong,nonatomic)NSString *stringEmpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelEmployerTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCurrentJobs;
@property (weak, nonatomic) IBOutlet UITextView *textFieldDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentJobsListing;

@end