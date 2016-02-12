//
//  ApplyProfileViewController.h
//  AgCareers
//
//  Created by Unicorn on 03/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CopyPasteTextField.h"
@interface ApplyProfileViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate>{
    APParser *jsonParser,*jsonParser3;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertLogOff,*alertForCheck,*alertPromt,*alertLogin;;
    UIActionSheet *myActionSheet;
    NSMutableDictionary *dictionaryState;
    NSData *uploadData;
    NSArray *arrayPickerData;
}
//@property (weak, nonatomic) IBOutlet CopyPasteTextField *textFieldEmail;

@property (weak, nonatomic) IBOutlet CopyPasteTextField *textFieldPassword;
@property (strong, nonatomic) NSString *stringEmailId;

@property (weak, nonatomic) IBOutlet UIView *viewPassword;

@property (nonatomic,strong)NSString *applyCondition;

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
- (IBAction)buttonActionDone:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailConfirm;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPasswordConfirm;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonNext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCreateProfile;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCountry;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;
- (IBAction)buttonActionNext:(id)sender;
- (IBAction)buttonActionCountry:(id)sender;
- (IBAction)buttonActionState:(id)sender;

- (IBAction)buttonActionUpdate:(id)sender;


@property (strong, nonatomic) NSString *stringJobTitleProfile;
@property (strong, nonatomic) NSString *stringJobIdProfile;

@end

