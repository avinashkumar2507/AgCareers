//
//  MyProfileViewController.h
//  AgCareers
//
//  Created by Unicorn on 03/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"
#import "BRRequestUpload.h"
#import "CopyPasteTextField.h"
@interface MyProfileViewController :UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate>{
    APParser *jsonParser,*jsonParser2,*jsonParser3;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertLogOff,*alertForCheck,*alertPromt,*alertLogin;;
    UIActionSheet *myActionSheet;
    NSMutableDictionary *dictionaryState;
    BRRequestUpload *uploadFile;
    NSData *uploadData;
    NSMutableArray *selectedItems;
    NSArray *arrayPickerData;
}
@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
- (IBAction)buttonActionDone:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textfieldUsername;
@property (weak, nonatomic) IBOutlet CopyPasteTextField *textfieldPassword;


@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailConfirm;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswordConfirm;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonNext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCreateProfile;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCountry;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;
- (IBAction)buttonActionNext:(id)sender;
- (IBAction)buttonActionCountry:(id)sender;
- (IBAction)buttonActionState:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *myViewPassword;
- (IBAction)buttonActionUpdate:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *myView;

- (IBAction)buttonActionLogin:(id)sender;
- (IBAction)buttonActionCreateProfileOnView:(id)sender;
- (IBAction)buttonActionForgotPassword:(id)sender;



/*
UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITabBarControllerDelegate>{
    APParser *jsonParser11,*jsonParser3;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertLogOff;
    UIActionSheet *myActionSheet;
    BRRequestUpload *uploadFile;
    NSData *uploadData;
    UIAlertView *alertForLogin,*alertLogin,*alertPromt,*alertSaveTitle;
}
@property (weak, nonatomic) IBOutlet UIView *myView;
- (IBAction)buttonActionLoginToView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonResume;
-(IBAction)buttonResumeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMyProfile;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonLogOff;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
-(IBAction)buttonActionLogOff:(id)sender;
-(IBAction)buttonActionDone:(id)sender;

- (IBAction)buttonActionNext:(id)sender;

@property (strong,nonatomic)NSString *stringNumberOfExperience;
*/
@end
