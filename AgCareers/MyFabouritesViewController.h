//
//  MyFabouritesViewController.h
//  AgCareers
//
//  Created by Unicorn on 17/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"
#import "CopyPasteTextField.h"
@interface MyFabouritesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    APParser *jsonParser33,*jsonParser331,*jsonParser332,*jsonParser334,*jsonParser335,*jsonParser336,*jsonParser3,*jsonParser2;
    MBProgressHUD *HUD1,*HUD2,*HUD3,*HUD4,*HUD5,*HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertDeleteJobs,*alertDeleteEmployer,*alertDeleteSearches,*alertPromt,*alertLogin,*alertCommon;
    NSMutableArray *arrayFavouriteJobs,*arrayFavouriteEmployer,*arrayFavouriteSearches;
    int segmentCount;
    
    UIRefreshControl *refreshControlJob,*refreshControlEmployer,*refreshControlSearches;
}

- (IBAction)buttonActionForgotPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet CopyPasteTextField *textfieldPassword;

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControllFavourites;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearches;
- (IBAction)segmentActionFavourites:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewJobs;
- (IBAction)buttonActionLoginOnView:(id)sender;
- (IBAction)buttonActionCreateProfileOnView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEmployers;
@end
