//
//  MyProfileSubmitViewController.h
//  AgCareers
//
//  Created by Unicorn on 26/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRRequestUpload.h"
#import "BRRequestCreateDirectory.h"
#import "BRRequestListDirectory.h"
@interface MyProfileSubmitViewController : UIViewController <UIAlertViewDelegate,UIActionSheetDelegate> {
    APParser *jsonParser,*jsonParser11,*jsonParser3,*jsonParser2;
    MBProgressHUD *HUD, *HUD1;
    NSDictionary *JSONDict;
    NSDictionary *JSONDictResumeList;
    UIAlertView *alertLogOff;
    UIActionSheet *myActionSheet;
    BRRequestUpload *uploadFile;
    BRRequestCreateDirectory *createDir;
    BRRequestListDirectory *listDir;
    NSData *uploadData;
    UIAlertView *alertForLogin,*alertLogin,*alertPromt,*alertSaveTitle;
    
    NSArray *arrayPickerData;

    UIAlertView *alertForCheck,*alertSuccess;
    
    @private
    NSString *s;
    
    @protected // Default
    NSString *a;
    
    @public
    NSString *b;
}

@property (weak, nonatomic) IBOutlet UILabel *labelFirstNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelSecondNumber;

@property (weak, nonatomic) IBOutlet UIView *viewAccept;

@property (weak, nonatomic) IBOutlet UISwitch *switchResumeFrist;
@property (weak, nonatomic) IBOutlet UISwitch *switchResumeSecond;
@property (weak, nonatomic) IBOutlet UILabel *labelResumeFirst;
@property (weak, nonatomic) IBOutlet UILabel *labelResumeSecond;
- (IBAction)switchActionResumeFirst:(id)sender;
- (IBAction)switchActionResumeSecond:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switchAccept;
@property (strong, nonatomic) NSString *strMemIdSubmit;
@property (weak, nonatomic) IBOutlet UILabel *labelResumeName;
@property (weak, nonatomic) IBOutlet UILabel *labelCoverLetterName;
@property (weak, nonatomic) IBOutlet UIButton *buttonBrowse;
@property (weak, nonatomic) IBOutlet UIButton *buttonUpload;
@property (weak, nonatomic) IBOutlet UIButton *buttonBrowseCoverLetter;
@property (weak, nonatomic) IBOutlet UIButton *buttonUploadCoverLetter;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReferrence;
- (IBAction)switchActionAccept:(id)sender;
- (IBAction)buttonActionUpdate:(id)sender;

- (IBAction)buttonBrowseAction:(id)sender;
- (IBAction)buttonUploadAction:(id)sender;
- (IBAction)buttonActionUploadCoverLetter:(id)sender;
- (IBAction)buttonActionBrowseCoverLetter:(id)sender;
- (IBAction)buttonActionReferrence:(id)sender;

- (IBAction)buttonActionCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;

@end