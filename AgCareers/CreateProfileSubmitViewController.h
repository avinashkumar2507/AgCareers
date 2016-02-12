//
//  CreateProfileSubmitViewController.h
//  AgCareers
//
//  Created by Unicorn on 19/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRRequestUpload.h"
#import "BRRequestCreateDirectory.h"
#import "BRRequestListDirectory.h"

@interface CreateProfileSubmitViewController : UIViewController <UIAlertViewDelegate,UIActionSheetDelegate> {
    APParser *jsonParser11,*jsonParser3;
    MBProgressHUD *HUD, *HUD1;
    NSDictionary *JSONDict;
    UIAlertView *alertLogOff,*alertSuccess;
    UIActionSheet *myActionSheet;
    BRRequestUpload *uploadFile;
    NSData *uploadData;
    UIAlertView *alertForLogin,*alertLogin,*alertPromt,*alertSaveTitle,*alertForApplySucess;
    
    NSArray *arrayPickerData;
    APParser *jsonParser,*jsonParser2;
    UIAlertView *alertForCheck;
    BRRequestCreateDirectory *createDir;
}

@property (weak, nonatomic) IBOutlet UISwitch *switchAccept;
@property (strong, nonatomic)NSString *strMemIdSubmit;
@property (weak, nonatomic) IBOutlet UILabel *labelResumeName;
@property (weak, nonatomic) IBOutlet UILabel *labelCoverLetterName;
@property (weak, nonatomic) IBOutlet UIButton *buttonBrowse;
@property (weak, nonatomic) IBOutlet UIButton *buttonUpload;
@property (weak, nonatomic) IBOutlet UIButton *buttonBrowseCoverLetter;
@property (weak, nonatomic) IBOutlet UIButton *buttonUploadCoverLetter;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReferrence;
@property (strong, nonatomic)NSString *stringIdCareersSubmit;
@property (strong, nonatomic)NSString *stringIdIndustrySubmit;
@property (strong, nonatomic)NSString *stringResumeId;
- (IBAction)switchActionAccept:(id)sender;

- (IBAction)buttonBrowseAction:(id)sender;
- (IBAction)buttonUploadAction:(id)sender;
- (IBAction)buttonActionUploadCoverLetter:(id)sender;
- (IBAction)buttonActionBrowseCoverLetter:(id)sender;
- (IBAction)buttonActionReferrence:(id)sender;

- (IBAction)buttonActionCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;

- (IBAction)buttonActionSubmit:(id)sender;

@end
