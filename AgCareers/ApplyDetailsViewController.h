//
//  ApplyDetailsViewController.h
//  AgCareers
//
//  Created by Unicorn on 07/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyDetailsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate,UIAlertViewDelegate>{
    NSArray *arrayPickerData;
    APParser *jsonParser,*jsonParser2,*jsonParser3,*jsonParser4;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertForCheck,*alertSuccessApply;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonApplyOnline;
- (IBAction)buttonActionApplyOnline:(id)sender;

//@property (weak, nonatomic) IBOutlet UIView *viewPreferredCareer;
//@property (weak, nonatomic) IBOutlet UIView *viewPreferredIndustry;

@property (nonatomic,strong)NSString *applyConditionDetails;

@property (weak, nonatomic) IBOutlet UITextField *textFieldExperience;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOccupation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMinimumEducation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMejorEducation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCareerType;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIndustryType;

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
- (IBAction)buttonActionDone:(id)sender;

- (IBAction)buttonActionNumberOfYears:(id)sender;
- (IBAction)buttonActionOccupation:(id)sender;
- (IBAction)buttonActionMinimumEducation:(id)sender;
- (IBAction)buttonActionMajorEducation:(id)sender;
- (IBAction)buttonActionCareerType:(id)sender;
- (IBAction)buttonActionIndustryType:(id)sender;
- (IBAction)buttonActionUpdate:(id)sender;

- (IBAction)buttonActionNext:(id)sender;


@end
