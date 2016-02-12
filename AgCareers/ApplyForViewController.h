//
//  ApplyForViewController.h
//  AgCareers
//
//  Created by Unicorn on 03/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyForViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>{
    APParser *jsonParser,*jsonParser1,*jsonParser2,*jsonParser7;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertCommon,*alertForAlreadyApplied;
}

@property (strong, nonatomic) NSString *stringJobId;
@property (strong, nonatomic) NSString *stringJobTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;
@property (weak, nonatomic) IBOutlet UIView *viewCreateProfile;
@property (weak, nonatomic) IBOutlet UIView *viewContinue;

- (IBAction)buttonActionContinue:(id)sender;
- (IBAction)buttonActionForgotPassword:(id)sender;
- (IBAction)buttonActionLogin:(id)sender;
- (IBAction)buttonActionWithoutLogin:(id)sender;
- (IBAction)buttonActionCreateProfile:(id)sender;
- (IBAction)buttonActionWithoutCreating:(id)sender;

@end
