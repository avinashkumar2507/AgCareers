//
//  SearchEditViewController.h
//  AgCareers
//
//  Created by Unicorn on 28/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//
#import "MPGTextField.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface SearchEditViewController : UIViewController <MPGTextFieldDelegate,UIPickerViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

    NSMutableArray *data1;
    
    NSArray *arrayPickerData;
    APParser *jsonParser,*jsonParser2;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    NSMutableDictionary *dictionarySectors;
    NSMutableDictionary *dictionaryTypes;
    NSMutableDictionary *dictionaryCareers;
    NSMutableDictionary *dictionaryState;
    UIAlertView *alertUpdateSuccess,*alertUpdateError;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonRegion;
@property (weak, nonatomic) IBOutlet UIButton *buttonState;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewUpdate;
- (IBAction)buttonActionUpdate:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTital;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKeyword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLocation;
@property (weak, nonatomic) IBOutlet MPGTextField *textFieldEmployer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIndustrySector;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIndustryType;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCareerType;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCountry;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRegion;
@property (weak, nonatomic) IBOutlet UITextField *textFieldState;

@property (strong,nonatomic) NSString * stringIndustrySector;
@property (strong,nonatomic) NSString * stringIndustrySectorId;
@property (weak,nonatomic) NSString * stringIndustryType;
@property (strong,nonatomic) NSString * stringIndustryTypeId;
@property (strong,nonatomic) NSString * stringCarrersType;
@property (strong,nonatomic) NSString * stringCarrersTypeId;
@property (strong,nonatomic) NSString *stringCountryId;
@property (strong,nonatomic) NSString *stringRegionId;
@property (strong,nonatomic) NSString *stringStateId;
@property (strong,nonatomic) NSString *stringEmployerName;

@property (strong,nonatomic) NSString * stringCountry;
@property (strong,nonatomic) NSString * stringTitle;
@property (strong,nonatomic) NSString * stringKeword;
@property (strong,nonatomic) NSString * stringEmployerId;
@property (strong,nonatomic) NSString * stringRegion;
@property (strong,nonatomic) NSString * stringState;
@property (strong,nonatomic) NSString * stringSearchId;
@property (strong,nonatomic) NSString * stringLocation;

- (IBAction)buttonActionIndustrySector:(id)sender;
- (IBAction)buttonActionIndustryTypes:(id)sender;
- (IBAction)buttonActionCareerTypes:(id)sender;
- (IBAction)buttonActionCountry:(id)sender;
- (IBAction)buttonActionRegion:(id)sender;
- (IBAction)buttonActionState:(id)sender;

@end
