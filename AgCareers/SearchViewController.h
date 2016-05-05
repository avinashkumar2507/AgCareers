//
//  SearchViewController.h
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGTextField.h"
#import <CoreLocation/CoreLocation.h>


@interface SearchViewController : UIViewController <MPGTextFieldDelegate,CLLocationManagerDelegate,DBRestClientDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    NSMutableArray *data1;
    NSMutableDictionary *dictionarySectors;
    NSMutableDictionary *dictionaryTypes;
    NSMutableDictionary *dictionaryCareers;
    NSMutableArray *arraySectors;
    
    MBProgressHUD *HUD;
    NSDictionary *JSONDict3433;
    APParser *jsonParser;
    NSDictionary *JSON_Dict;
    NSDictionary *JSONDict;
    UIAlertView *alertForUpdate,*alertForCriticalUpdate;
}

@property (weak, nonatomic) IBOutlet UILabel *labelh;

@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKeyword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCareer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldType;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSector;
@property (nonatomic,retain)NSArray *arraySectors;
@property (nonatomic,strong)NSMutableDictionary *dictionarySectors;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewSearch;

@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet MPGTextField *textFieldEmployer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonTest;


- (IBAction)buttonActionLocation:(id)sender;
- (IBAction)buttonTestAction:(id)sender;
- (IBAction)buttonActionSector:(id)sender;
- (IBAction)buttonActionType:(id)sender;
- (IBAction)buttonActionCareer:(id)sender;

@end
