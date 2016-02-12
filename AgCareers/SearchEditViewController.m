//
//  SearchEditViewController.m
//  AgCareers
//
//  Created by Unicorn on 28/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "SearchEditViewController.h"
#import "EditIndustrySectorViewController.h"
#import "SelectTypesViewController.h"
#import "SelectSectorsViewController.h"
#import "SelectCareersViewController.h"
#import <AddressBook/AddressBook.h>
#import "CountrySelectionViewController.h"
#import "RegionViewController.h"
#import <Google/Analytics.h>
@interface SearchEditViewController ()

@end

@implementation SearchEditViewController
@synthesize stringCarrersType,stringCountry,stringIndustrySector,stringIndustryType,stringRegion,stringState,stringCarrersTypeId,stringEmployerId,stringIndustrySectorId,stringIndustryTypeId,stringKeword,stringTitle,stringSearchId,stringCountryId,stringRegionId,stringStateId,stringEmployerName;
@synthesize textFieldIndustrySector,textFieldCareerType,textFieldCountry,textFieldIndustryType,textFieldRegion,textFieldState;
@synthesize myPicker,scrollViewUpdate;

@synthesize textFieldEmployer,textFieldKeyword,textFieldLocation,buttonRegion,buttonState,textFieldTital,stringLocation;

BOOL flagGetRegions = FALSE;
BOOL flagGetCountry = FALSE;

NSString *_postalCodeUpdate          = @"";
NSString *_countryUpdate             = @"";
NSString *_administrativeAreaUpdate  = @"";
NSString *currentLatUpdate           = @"";
NSString *currentLogUpdate           = @"";

int heightForScrollViewUpdate = 480;

- (void)viewDidLoad {
    [super viewDidLoad];
    dictionarySectors = [[NSMutableDictionary alloc]init];
    dictionaryTypes = [[NSMutableDictionary alloc]init];
    dictionaryCareers = [[NSMutableDictionary alloc]init];
    dictionaryState = [[NSMutableDictionary alloc]init];
    
    myPicker.hidden = YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
    
    [textFieldTital setText:stringTitle];
    [textFieldLocation setText:stringLocation];
    [textFieldKeyword setText:stringKeword];
    if ([stringEmployerName length]>0) {
        [textFieldEmployer setText:stringEmployerName];
    }else{
        textFieldEmployer.placeholder = @"All";
    }
    
    [textFieldIndustrySector setText:[stringIndustrySector stringByReplacingOccurrencesOfString:@"#" withString:@","]];
    [textFieldIndustryType setText:[stringIndustryType stringByReplacingOccurrencesOfString:@"#" withString:@","]];
    [textFieldCareerType setText:[stringCarrersType stringByReplacingOccurrencesOfString:@"#" withString:@","]];
    [textFieldCountry setText:[stringCountry stringByReplacingOccurrencesOfString:@"#" withString:@","]];
    [textFieldRegion setText:[stringRegion stringByReplacingOccurrencesOfString:@"#" withString:@","]];
    [textFieldState setText:[stringState stringByReplacingOccurrencesOfString:@"#" withString:@","]];
    
    ////////////////////////////////////////////////////////////////////
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    [CLLocationManager locationServicesEnabled];
    // Check for iOS 8. and request location when App is in use
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    //[locationManager startUpdatingLocation];
    //////////////////////////////////////////////////////////////////////
    
    textFieldEmployer.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    flagGetRegions = FALSE;
    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Search Criteria Edit Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        
        if (self.tabBarController.selectedIndex == 1) {
            
        }else{
            
        }
    }else {
        //User is not logged in
        [self.navigationController popViewControllerAnimated:YES];
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:NO completion:NULL];
    }
}

-(void)viewDidLayoutSubviews{
    
}

- (void) keyboardWillShow:(NSNotification *)note {
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    frame.origin.y = -50;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    // move the view back to the origin
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [scrollViewUpdate setContentSize:CGSizeMake(300, heightForScrollViewUpdate)];
    }else{
        [scrollViewUpdate setContentSize:CGSizeMake(300, heightForScrollViewUpdate)];
    }
}

-(void)updateData{
    
}

// Picker view single tap
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        if (flagGetCountry == TRUE) {
            [textFieldCountry setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringCountryId = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            stringRegionId = @"0";
            textFieldRegion.text = @"";
            textFieldState.text = @"";
            [myPicker setHidden:YES];
        }
        if (flagGetRegions == TRUE) {
            
            [textFieldRegion setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringRegionId = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            textFieldState.text = @"";
            [myPicker setHidden:YES];
        }
        flagGetCountry = FALSE;
        flagGetRegions = FALSE;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

#pragma mark PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrayPickerData count] ;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[arrayPickerData objectAtIndex:row]valueForKey:@"Name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueEditIndustrySector"]) {
        SelectSectorsViewController *selectSectorsViewController = [segue destinationViewController];
        selectSectorsViewController.delegateSectors = self;
        selectSectorsViewController.stringValues = stringIndustrySector;//textFieldIndustrySector.text;
        //        [strIndustrySector substringToIndex:strIndustrySector.length-(strIndustrySector.length>0)];
        //        selectSectorsViewController.stringId = stringIndustrySectorId;
        selectSectorsViewController.stringId = stringIndustrySectorId;
    }
    if ([segue.identifier isEqualToString:@"segueEditIndustryTypes"]) {
        SelectTypesViewController *selectTypesViewController = [segue destinationViewController];
        selectTypesViewController.delegateTypes = self;
        selectTypesViewController.stringValues = stringIndustryType; //textFieldIndustryType.text;
        selectTypesViewController.stringId = stringIndustryTypeId;
    }
    if ([segue.identifier isEqualToString:@"segueEditCarrersTypes"]) {
        SelectCareersViewController *selectCareersViewController = [segue destinationViewController];
        selectCareersViewController.delegateCareers = self;
        selectCareersViewController.stringValues = stringCarrersType;//textFieldCareerType.text;
        selectCareersViewController.stringId = stringCarrersTypeId;
    }
    if ([segue.identifier isEqualToString:@"SegueStates"]) {
        EditIndustrySectorViewController *editIndustrySectorViewController = [segue destinationViewController];
        editIndustrySectorViewController.stringCountryId = stringCountryId;
        editIndustrySectorViewController.stringRegionId = stringRegionId;
        editIndustrySectorViewController.delegateStates = self;
    }
    if ([segue.identifier isEqualToString:@"SegueCountrySelection"]) {
        CountrySelectionViewController *countrySelectionViewController = [segue destinationViewController];
        countrySelectionViewController.delegateCountry = self;
    }
    if ([segue.identifier isEqualToString:@"SegueRegionSelection"]) {
        RegionViewController *regionViewController = [segue destinationViewController];
        regionViewController.stringCoutnryId = stringCountryId;
        regionViewController.delegateRegion = self;
    }
}

#pragma mark Edit industry Sector delegate method
-(void)sendSectorDictionary : (NSMutableDictionary *)sectorsDictionary{
    NSString *stringNew = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    dictionarySectors = sectorsDictionary;
    stringIndustrySectorId = [[dictionarySectors objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
    
    stringIndustrySector = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    
    [textFieldIndustrySector setText:stringNew];
}

#pragma mark Edit industry Types delegate method
-(void)sendTypesDictionary : (NSMutableDictionary *) typesDictionary{
    NSString *stringNew = [[typesDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    dictionaryTypes = typesDictionary;
    stringIndustryTypeId = [[dictionaryTypes objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
    
    stringIndustryType = [[typesDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    
    [textFieldIndustryType setText:stringNew];
}

#pragma mark Edit Careers Types delegate method
-(void)sendCareersDictionary : (NSMutableDictionary *) careersDictionary {
    NSString *stringNew = [[careersDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    dictionaryCareers = careersDictionary;
    stringCarrersTypeId = [[dictionaryCareers objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
    
    stringCarrersType = [[careersDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    
    [textFieldCareerType setText:stringNew];
}

#pragma mark Edit Careers Types delegate method
-(void)sendStatesDictionary : (NSMutableDictionary *) dictionaryStates {
    NSString *stringNew = [[dictionaryStates objectForKey:@"arrayTypeName"] componentsJoinedByString:@","];
    dictionaryState = dictionaryStates;
    stringStateId = [[dictionaryState objectForKey:@"arrayTypeIds"] componentsJoinedByString:@","];
    [textFieldState setText:stringNew];
}

#pragma mark Country selection delegate method
-(void)sendCountryDictionary : (NSMutableDictionary *) dictionaryCountry {
    [textFieldCountry setText:[[dictionaryCountry objectForKey:@"arrayTypeName"]objectAtIndex:0]];
    stringCountryId = [[dictionaryCountry objectForKey:@"arrayTypeIds"]objectAtIndex:0];
    
    if ([stringCountryId isEqualToString:@"243"]) {
        stringRegionId = 0;
        stringStateId = @"";
        buttonRegion.userInteractionEnabled = FALSE;
        buttonState.userInteractionEnabled = FALSE;
        textFieldRegion.userInteractionEnabled = FALSE;
        textFieldState.userInteractionEnabled = FALSE;
    }else {
        buttonRegion.userInteractionEnabled = TRUE;
        buttonState.userInteractionEnabled = TRUE;
        textFieldRegion.userInteractionEnabled = TRUE;
        textFieldState.userInteractionEnabled = TRUE;
    }
    [textFieldRegion setText:@""];
    [textFieldState setText:@""];
    
    stringRegionId = @"0";
    stringStateId = @"";
}

#pragma mark Region selection delegate method
-(void)sendRegionDictionary : (NSMutableDictionary *) dictionaryRegion{
    [textFieldRegion setText:[[dictionaryRegion objectForKey:@"arrayTypeName"]objectAtIndex:0]];
    stringRegionId = [[dictionaryRegion objectForKey:@"arrayTypeIds"]objectAtIndex:0];
    [textFieldState setText:@""];
    stringStateId = @"";
}


- (IBAction)buttonActionIndustrySector:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        [self performSegueWithIdentifier:@"segueEditIndustrySector" sender:self];
    }
}

- (IBAction)buttonActionIndustryTypes:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        [self performSegueWithIdentifier:@"segueEditIndustryTypes" sender:self];
    }
}

- (IBAction)buttonActionCareerTypes:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        [self performSegueWithIdentifier:@"segueEditCarrersTypes" sender:self];
    }
}

- (IBAction)buttonActionCountry:(id)sender {Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        flagGetCountry = TRUE;
        [self performSegueWithIdentifier:@"SegueCountrySelection" sender:self];
        
        //[self callWebServiceCountry];
    }
}

- (IBAction)buttonActionRegion:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        if (textFieldCountry.text.length > 0) {
            flagGetRegions = TRUE;
            [self performSegueWithIdentifier:@"SegueRegionSelection" sender:self];
            //[self callWebServiceRegion];
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select country" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (IBAction)buttonActionState:(id)sender {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        
        if (textFieldCountry.text.length >0 ) { //textFieldRegion.text.length >0
            if (textFieldRegion.text.length >0) {
                [self performSegueWithIdentifier:@"SegueStates" sender:self];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select region" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select country and region" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)callWebServiceCountry {
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetCountries";
    NSString* soapAction = @"http://tempuri.org/GetCountries";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: nil,nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceRegion {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetRegions";
    NSString* soapAction = @"http://tempuri.org/GetRegions";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: stringCountryId,@"countryid",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    //[[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [textFieldTital resignFirstResponder];
    [textFieldLocation resignFirstResponder];
    [textFieldKeyword resignFirstResponder];
    [textFieldEmployer resignFirstResponder];

    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    NSError *error;
    JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                               options: NSJSONReadingMutableContainers
                                                 error: &error];
    
    if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
        
        alertUpdateSuccess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Search criteria updated successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUpdateSuccess show];
    }else{
        alertUpdateError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertUpdateError show];
    }
    /*
     if (flagGetCountry == TRUE) {
     
     [HUD hide:YES];
     [self.tabBarController.view setUserInteractionEnabled:YES];
     NSError *error;
     JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
     options: NSJSONReadingMutableContainers
     error: &error];
     arrayPickerData = [JSONDict valueForKey:@"Rows"];
     myPicker.hidden = NO;
     [myPicker reloadAllComponents];
     
     }if (flagGetRegions == TRUE){
     
     [HUD hide:YES];
     [self.tabBarController.view setUserInteractionEnabled:YES];
     NSError *error;
     JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
     options: NSJSONReadingMutableContainers
     error: &error];
     
     if ([[JSONDict valueForKey:@"Rows"]count] ==0) {
     flagGetCountry = FALSE;
     flagGetRegions = FALSE;
     
     myPicker.hidden = YES;
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Ther is no region" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     }else{
     arrayPickerData = [JSONDict valueForKey:@"Rows"];
     myPicker.hidden = NO;
     [myPicker reloadAllComponents];
     
     }
     }
     */
}

- (IBAction)buttonActionUpdate:(id)sender {
    [textFieldTital resignFirstResponder];
    [textFieldLocation resignFirstResponder];
    [textFieldKeyword resignFirstResponder];
    [textFieldEmployer resignFirstResponder];

    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        jsonParser = [APParser sharedParser];
        jsonParser.delegate = self;
        
        [self.tabBarController.view setUserInteractionEnabled:NO ];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        [HUD show:YES];
        
        NSString* methodName = @"SaveSeach";
        NSString* soapAction = @"http://tempuri.org/SaveSeach";
        
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"0",@"deviceId",
                                       textFieldKeyword.text,@"keyword",
                                       textFieldLocation.text,@"location",
                                       stringIndustrySectorId,@"industrySector",
                                       stringIndustryTypeId,@"iType",
                                       stringCarrersTypeId,@"cType",
                                       [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"applicantid",
                                       stringEmployerId,@"employerid",
                                       [textFieldTital text],@"Title",
                                       stringStateId,@"StateIDs",
                                       stringRegionId,@"RegionIDs",
                                       stringCountryId,@"CountryIDs",
                                       stringSearchId,@"SavedSearchID",
                                       nil];
        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict",nil];
        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
        [jsonParser parseSoapWithJSONSoapContents:dictToSend];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    
    switch([error code]) {
        case kCLErrorNetwork: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User has denied to use current Location " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown network error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    
    @try {
        
    }
    @catch (NSException *exception) {
        
    }
    
    if (currentLocation != nil) {
        currentLatUpdate  = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
        currentLogUpdate = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:currentLatUpdate forKey:@"latKey"];
        [userDefaults setObject:currentLogUpdate forKey:@"logKey"];
        [userDefaults synchronize];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/xml?latlng=%@,%@&sensor=true",currentLatUpdate,currentLogUpdate]]];
        [request setHTTPMethod:@"POST"];
        [locationManager stopUpdatingLocation];
    }
    [locationManager stopUpdatingLocation];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _postalCodeUpdate = placemark.postalCode;
            _countryUpdate = placemark.country;
            _administrativeAreaUpdate = placemark.administrativeArea;
            //            NSLog(@"postalCode          :%@",_postalCodeUpdate);
            //            NSLog(@"country             :%@",placemark.country);
            //            NSLog(@"administrativeArea  :%@",placemark.administrativeArea);
            //            NSLog(@"locality            :%@",placemark.locality);
            //            NSLog(@"thoroughfare        :%@",placemark.thoroughfare);
            //            NSLog(@"subThoroughfare     :%@",placemark.subThoroughfare);
            //            NSLog(@"subLocality         :%@",placemark.subLocality);
            //            NSLog(@"name                :%@",[placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey]);
            
            [textFieldLocation setText:[NSString stringWithFormat:@"%@, %@",placemark.administrativeArea,placemark.country]];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

#pragma mark employer textfield generate data
- (NSArray *)dataForPopoverInTextField:(MPGTextField *)textField {
    
    if ([textField isEqual:textFieldEmployer]) {
        if ([textFieldEmployer.text length]>1) {
            [self generateData];
        }
        return data1;
    }
    else{
        return nil;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    heightForScrollViewUpdate = 700;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldSelect:(MPGTextField *)textField {
    [self viewWillLayoutSubviews];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    if (textField==textField) {
        
        if ( [text length] > 0 ) return YES;
        if ( range.length == 1 ){
            return YES;
        }else {
        }
        if ( [text length] == range.length ) return NO; // remove all != OK
        return YES;
    }
    return YES;
}

- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result {
    stringEmployerId = [[result valueForKey:@"CustomObject"]valueForKey:@"EmployerID"];
}

- (void)generateData {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        data1 = [[NSMutableArray alloc] init];
        
        NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
        NSString *webServiceString = [dictRoot objectForKey:@"WebServiceURL"];
        NSString *baseHost = [dictRoot objectForKey:@"BaseHost"];
        
        
        data1 = [[NSMutableArray alloc] init];
        //        static NSString* base_url = @"http://agcareers-ws.farmsstaging.com/mobilews/webservice/newJobSearch.asmx/"; //live
        //        static NSString* base_host = @"agcareers-ws.farmsstaging.com";
        NSString* base_url = webServiceString;
        NSString* base_host = baseHost;
        
        NSString * soapActionString = @"http://tempuri.org/GetMemberByKeyWords";
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFieldEmployer.text,@"SearchText", nil];
        NSString * base = base_url;
        NSError* error = nil;
        NSString* finalUrlString = [base stringByAppendingString:@"GetMemberByKeyWords"];
        NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:100.0];
        [request addValue: soapActionString forHTTPHeaderField:@"SOAPAction"];
        [request addValue:base_host forHTTPHeaderField:@"Host"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:&error];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
        [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                //[ fetchingGroupsFailedWithError:error];
            } else {
                NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                NSDictionary *JSONDict =
                [NSJSONSerialization JSONObjectWithData: [[returnDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &error];
                NSArray* contents = [JSONDict valueForKey:@"MemberAutoCompletesList"];
                dispatch_async( dispatch_get_main_queue(), ^{
                    // results of the background processing
                    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [data1 addObject:
                         [NSDictionary dictionaryWithObjectsAndKeys:[[obj objectForKey:@"FirstName"] stringByAppendingString:[NSString stringWithFormat:@" %@", [obj objectForKey:@"LastName"]]], @"DisplayText", [obj objectForKey:@"Company"], @"DisplaySubText",obj,@"CustomObject", nil]];
                        [data1 addObject:
                         [NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"Company"], @"DisplayText", [obj objectForKey:@"Company"], @"DisplaySubText",obj,@"CustomObject", nil]];
                    }];
                });
            }
        }];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textFieldTital resignFirstResponder];
    [textFieldLocation resignFirstResponder];
    [textFieldKeyword resignFirstResponder];
    [textFieldEmployer resignFirstResponder];
    heightForScrollViewUpdate = 480;
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
    }else{
        [scrollViewUpdate setContentOffset:CGPointMake(0, -50)];
    }
    if (textField==textFieldEmployer) {
        return NO;
    }else
        return YES;
}

#pragma mark AlertView delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"No Internet Connection"
                                message:@"You must be online for the app to function."
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        if (alertView == alertUpdateSuccess) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
        if (alertView == alertUpdateError) {
            
        }
    }
}

@end