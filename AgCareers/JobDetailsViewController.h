//
//  JobDetailsViewController.h
//  AgCareers
//
//  Created by Unicorn on 26/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"
#import <MessageUI/MessageUI.h>
@interface JobDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate>{
    APParser *jsonParser2,*jsonParser3,*jsonParser4,*jsonParser5,*jsonParser6,*jsonParser7;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict,*JSONDict11,*JSONDict22;
    UIActionSheet *myActionSheet;
    UIBarButtonItem *shareBarButton;
    UIAlertView *alertLogin,*alertPromt,*alertForOpenBrowser,*alertForBack,*alertForCheck,*alertForAlreadyApplied;
    UIWebView *webview;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonApply;

@property (nonatomic, strong) NSString *stringJobId;
@property (weak, nonatomic) IBOutlet UITableView *tableViewJobDetails;
@property (weak, nonatomic) IBOutlet UILabel *labelJobTitle;
- (IBAction)buttonActionApply:(id)sender;

@end
