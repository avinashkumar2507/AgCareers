//
//  MyProfileSecondViewController.h
//  AgCareers
//
//  Created by Unicorn on 24/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileSecondViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate>{
    NSArray *arrayPickerData;
    APParser *jsonParser,*jsonParser2,*jsonParser3;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict,*JSONDictDetails;
    UIAlertView *alertForCheck;
    NSMutableDictionary *dictionaryCareer,*dictionaryIndustry;
    NSString *stringIdCareersMyProfile;
    NSString *stringIdIndustryMyProfile;
    
    NSString *stringCareerNames;
    NSString *stringIndutryNames;
}

@property (strong, nonatomic)NSString *strMemId;
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
