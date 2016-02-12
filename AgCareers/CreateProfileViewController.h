//
//  CreateProfileViewController.h
//  AgCareers
//
//  Created by Unicorn on 04/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"
#import "BRRequestUpload.h"
#import "CopyPasteTextField.h"
@interface CreateProfileViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate>{
    APParser *jsonParser;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertLogOff,*alertForCheck;
    UIActionSheet *myActionSheet;
    NSMutableDictionary *dictionaryState;
    BRRequestUpload *uploadFile;
    NSData *uploadData;
    
    NSArray *arrayPickerData;
    
    
    NSMutableArray *selectedItems;

}

@property (strong, nonatomic)NSString *stringEmailIDCreateProfile;

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
@property (weak, nonatomic) IBOutlet CopyPasteTextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet CopyPasteTextField *textFieldPasswordConfirm;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonNext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewCreateProfile;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCountry;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;
- (IBAction)buttonActionNext:(id)sender;
- (IBAction)buttonActionCountry:(id)sender;
- (IBAction)buttonActionState:(id)sender;

@end
