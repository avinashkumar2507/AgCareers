//
//  ApplySubmitViewController.h
//  AgCareers
//
//  Created by Unicorn on 08/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRRequestUpload.h"
@interface ApplySubmitViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate> {
    APParser *jsonParser,*jsonParser11,*jsonParser3,*jsonParser2,*jsonParser4;
    MBProgressHUD *HUD, *HUD1;
    NSDictionary *JSONDict;
    NSDictionary *JSONDictResumeList;
    UIAlertView *alertLogOff;
    UIActionSheet *myActionSheet;
    BRRequestUpload *uploadFile1;
    NSData *uploadData;
    UIAlertView *alertForLogin,*alertLogin,*alertPromt,*alertSaveTitle;
    NSArray *arrayPickerData;
    UIAlertView *alertForCheck,*alertSuccess,*alertSuccessApply;
}

@property (weak, nonatomic) IBOutlet UISwitch *switchResumeFrist;
@property (weak, nonatomic) IBOutlet UISwitch *switchResumeSecond;
@property (weak, nonatomic) IBOutlet UILabel *labelResumeFirst;
@property (weak, nonatomic) IBOutlet UILabel *labelResumeSecond;
- (IBAction)switchActionResumeFirst:(id)sender;
- (IBAction)switchActionResumeSecond:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewHowDid;
@property (weak, nonatomic) IBOutlet UIView *viewAcceptTOS;
@property (nonatomic,strong)NSString *applyConditionSumit;
@property (strong, nonatomic)NSString *stringIdCareersApply;
@property (strong, nonatomic)NSString *stringIdIndustryApply;


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
