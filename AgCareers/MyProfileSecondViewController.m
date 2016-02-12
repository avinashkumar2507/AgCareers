//
//  MyProfileSecondViewController.m
//  AgCareers
//
//  Created by Unicorn on 24/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "MyProfileSecondViewController.h"
#import "IndustryAndCareerViewController.h"
@interface MyProfileSecondViewController ()

@end

@implementation MyProfileSecondViewController
@synthesize myPicker,pickerParentView;
@synthesize textFieldExperience,textFieldCareerType,textFieldIndustryType,textFieldMejorEducation,textFieldMinimumEducation,textFieldOccupation;
@synthesize strMemId;

BOOL flagExperienceMyProfile         = FALSE;
BOOL flagOccupationMyProfile         = FALSE;
BOOL flagMinimumExperienceMyProfile  = FALSE;
BOOL flagMaximumExperienceMyProfile  = FALSE;
BOOL flagCareersTypeMyProfile        = FALSE;
BOOL flagIndustryTypeMyProfile       = FALSE;
BOOL flagSaveMemberDetailsMyProfile  = FALSE;
BOOL flagGetMyProfileDetails         = FALSE;

NSString *stringIdExperienceMyProfile        = @"";
NSString *stringIdOccupationMyProfile        = @"";
NSString *stringIdMinimumEductionMyProfile   = @"";
NSString *stringIdMajorEducationMyProfile    = @"";


- (void)viewDidLoad {
    [super viewDidLoad];
    dictionaryCareer = [[NSMutableDictionary alloc]init];
    dictionaryIndustry = [[NSMutableDictionary alloc]init];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus internateStatus = [reach currentReachabilityStatus];
        if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"No Internet Connection"
                                    message:@"You must be online for the app to function."
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
            [myAlert show];
        }
        else{
            [self callWebServiceMyProfileDetails];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    flagCareersTypeMyProfile = FALSE;
    flagIndustryTypeMyProfile = FALSE;
    flagMaximumExperienceMyProfile = FALSE;
    flagMinimumExperienceMyProfile = FALSE;
    flagOccupationMyProfile = FALSE;
    flagExperienceMyProfile = FALSE;
    
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueMyPfofileSubmitView"]) {
        
    }
    if ([segue.identifier isEqualToString:@"SegueIndustryAndCareer"]) {
        IndustryAndCareerViewController *selectSectroViewController = [segue destinationViewController];
        selectSectroViewController.delegateIndustryCareerProtocol = self;
        if (flagCareersTypeMyProfile == TRUE) {
            selectSectroViewController.stringTitle = @"Career";
            selectSectroViewController.stringWSName = @"GetCareerTypes";
            selectSectroViewController.stringId = stringIdCareersMyProfile;
            selectSectroViewController.stringValues = stringCareerNames;
        }
        if (flagIndustryTypeMyProfile == TRUE) {
            selectSectroViewController.stringTitle = @"Industry";
            selectSectroViewController.stringWSName = @"GetIndustryTypes";
            selectSectroViewController.stringId = stringIdIndustryMyProfile;
            selectSectroViewController.stringValues = stringIndutryNames;
        }
    }
}

#pragma mark selectSectorsViewController delegate
-(void)sendIndustryCareerDictionary : (NSMutableDictionary *)sectorsDictionary{
    
    if (flagCareersTypeMyProfile == TRUE) {
        flagCareersTypeMyProfile = FALSE;
        textFieldCareerType.text = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringCareerNames = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringIdCareersMyProfile = [[sectorsDictionary objectForKey:@"arraySectorIds"]componentsJoinedByString:@","] ;
        dictionaryCareer = sectorsDictionary;
    }
    if (flagIndustryTypeMyProfile == TRUE) {
        flagIndustryTypeMyProfile = FALSE;
        textFieldIndustryType.text = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringIndutryNames = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringIdIndustryMyProfile = [[sectorsDictionary objectForKey:@"arraySectorIds"]componentsJoinedByString:@","] ;
        dictionaryIndustry = sectorsDictionary;

    }
}

- (IBAction)buttonActionDone:(id)sender {
    pickerParentView.hidden = YES;
}

// Picker view single tap
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagExperienceMyProfile == TRUE) {
            flagExperienceMyProfile = FALSE;
            [textFieldExperience setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdExperienceMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagOccupationMyProfile == TRUE) {
            flagOccupationMyProfile = FALSE;
            [textFieldOccupation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdOccupationMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagMinimumExperienceMyProfile == TRUE) {
            flagMinimumExperienceMyProfile = FALSE;
            [textFieldMinimumEducation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdMinimumEductionMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagMaximumExperienceMyProfile == TRUE) {
            flagMaximumExperienceMyProfile = FALSE;
            [textFieldMejorEducation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdMajorEducationMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagIndustryTypeMyProfile == TRUE) {
            flagIndustryTypeMyProfile = FALSE;
            [textFieldIndustryType setText:[[arrayPickerData valueForKey:@"CategoryName"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdIndustryMyProfile = [[arrayPickerData valueForKey:@"CategoryID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagCareersTypeMyProfile == TRUE) {
            flagCareersTypeMyProfile = FALSE;
            [textFieldCareerType setText:[[arrayPickerData valueForKey:@"CategoryName"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdCareersMyProfile = [[arrayPickerData valueForKey:@"CategoryID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
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
    if (flagCareersTypeMyProfile == TRUE | flagIndustryTypeMyProfile == TRUE) {
        return [[arrayPickerData objectAtIndex:row]valueForKey:@"CategoryName"];
    }else{
        return [[arrayPickerData objectAtIndex:row]valueForKey:@"Name"];
    }
}

-(void)callWebServiceExperience {
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetExperiences";
    NSString* soapAction = @"http://tempuri.org/GetExperiences";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceOccupation {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetOccupations";
    NSString* soapAction = @"http://tempuri.org/GetOccupations";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceMinimumExperience {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetDegrees";
    NSString* soapAction = @"http://tempuri.org/GetDegrees";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceMaximumExperience {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetEducationCategories";
    NSString* soapAction = @"http://tempuri.org/GetEducationCategories";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceIndustryType {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetIndustryTypes";
    NSString* soapAction = @"http://tempuri.org/GetIndustryTypes";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceCareersType {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetCareerTypes";
    NSString* soapAction = @"http://tempuri.org/GetCareerTypes";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
}

-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool {
    
    if (flagExperienceMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    } else if (flagOccupationMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    }
    else if (flagMinimumExperienceMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    } else if (flagMaximumExperienceMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    } else if (flagIndustryTypeMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"CategorysList"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    } else if (flagCareersTypeMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"CategorysList"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    } else if (flagSaveMemberDetailsMyProfile == TRUE) {
        flagSaveMemberDetailsMyProfile = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [self showAlertViewWithMessage:@"Your profile details have been updated successfully" withTitle:@"Success"];
        }else{
            [self showAlertViewWithMessage:@"Some error occured. Please try again later." withTitle:@"Error"];
        }
    }else if (flagGetMyProfileDetails == TRUE){
        flagCareersTypeMyProfile = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDictDetails = [[NSDictionary alloc]init];
        
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        JSONDictDetails = JSONDict;
        
        [textFieldExperience setText:[JSONDict valueForKey:@"Experience"]];
        [textFieldOccupation setText:[JSONDict valueForKey:@"Occupation"]];
        [textFieldMinimumEducation setText:[JSONDict valueForKey:@"MinEducation"]];
        [textFieldMejorEducation setText:[JSONDict valueForKey:@"MaxEducation"]];
        [textFieldCareerType setText:[JSONDict valueForKey:@"CareerType"]];
        [textFieldIndustryType setText:[JSONDict valueForKey:@"IndustryType"]];
        stringCareerNames = [JSONDict valueForKey:@"CareerType"];
        stringIndutryNames = [JSONDict valueForKey:@"IndustryType"];
        
        stringIdExperienceMyProfile = [JSONDict valueForKey:@"ExpYearsid"];
        stringIdOccupationMyProfile = [JSONDict valueForKey:@"Occupationid"];
        stringIdMinimumEductionMyProfile = [JSONDict valueForKey:@"MinEducationID"];
        stringIdMajorEducationMyProfile = [JSONDict valueForKey:@"MaxEducationID"];
        stringIdCareersMyProfile = [JSONDict valueForKey:@"CareerTypeID"];
        stringIdIndustryMyProfile = [JSONDict valueForKey:@"IndustryTypeID"];
    }else{
        
    }
}

- (IBAction)buttonActionNumberOfYears:(id)sender {
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
        flagExperienceMyProfile          = TRUE;
        flagOccupationMyProfile          = FALSE;
        flagMinimumExperienceMyProfile   = FALSE;
        flagMaximumExperienceMyProfile   = FALSE;
        flagIndustryTypeMyProfile        = FALSE;
        flagCareersTypeMyProfile         = FALSE;
        [self callWebServiceExperience];
    }
}

- (IBAction)buttonActionOccupation:(id)sender {
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
        flagExperienceMyProfile          = FALSE;
        flagOccupationMyProfile          = TRUE;
        flagMinimumExperienceMyProfile   = FALSE;
        flagMaximumExperienceMyProfile   = FALSE;
        flagIndustryTypeMyProfile        = FALSE;
        flagCareersTypeMyProfile         = FALSE;
        [self callWebServiceOccupation];
    }
}

- (IBAction)buttonActionMinimumEducation:(id)sender {
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
        flagExperienceMyProfile          = FALSE;
        flagOccupationMyProfile          = FALSE;
        flagMinimumExperienceMyProfile   = TRUE;
        flagMaximumExperienceMyProfile   = FALSE;
        flagIndustryTypeMyProfile        = FALSE;
        flagCareersTypeMyProfile         = FALSE;
        [self callWebServiceMinimumExperience];
    }
}

- (IBAction)buttonActionMajorEducation:(id)sender {
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
        flagExperienceMyProfile          = FALSE;
        flagOccupationMyProfile          = FALSE;
        flagMinimumExperienceMyProfile   = FALSE;
        flagMaximumExperienceMyProfile   = TRUE;
        flagIndustryTypeMyProfile        = FALSE;
        flagCareersTypeMyProfile         = FALSE;
        [self callWebServiceMaximumExperience];
    }
}

- (IBAction)buttonActionIndustryType:(id)sender {
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
        flagExperienceMyProfile          = FALSE;
        flagOccupationMyProfile          = FALSE;
        flagMinimumExperienceMyProfile   = FALSE;
        flagMaximumExperienceMyProfile   = FALSE;
        flagIndustryTypeMyProfile        = TRUE;
        flagCareersTypeMyProfile         = FALSE;
        
        [self performSegueWithIdentifier:@"SegueIndustryAndCareer" sender:self];
        
        //[self callWebServiceIndustryType];
    }
}
- (IBAction)buttonActionCareerType:(id)sender {
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
        flagExperienceMyProfile          = FALSE;
        flagOccupationMyProfile          = FALSE;
        flagMinimumExperienceMyProfile   = FALSE;
        flagMaximumExperienceMyProfile   = FALSE;
        flagIndustryTypeMyProfile        = FALSE;
        flagCareersTypeMyProfile         = TRUE;
        
        [self performSegueWithIdentifier:@"SegueIndustryAndCareer" sender:self];
        
        //[self callWebServiceCareersType];
    }
}

- (IBAction)buttonActionUpdate:(id)sender {
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
        if ([textFieldExperience.text length]>0) {
            
            if ([textFieldOccupation.text length]>0) {
                
                if ([textFieldMinimumEducation.text length]>0) {
                    
                    if ([textFieldMejorEducation.text length]>0) {
                        
                        if ([textFieldCareerType.text length]>0) {
                            
                            if ([textFieldIndustryType.text length]>0) {
                                
                                flagSaveMemberDetailsMyProfile = TRUE;
                                jsonParser = [APParser sharedParser];
                                jsonParser.delegate = self;
                                [self.tabBarController.view setUserInteractionEnabled:NO ];
                                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                                [self.navigationController.view addSubview:HUD];
                                HUD.delegate = self;
                                HUD.labelText = @"Loading";
                                [HUD show:YES];
                                
                                NSString* methodName = @"SaveMemberDetails";
                                NSString* soapAction = @"http://tempuri.org/SaveMemberDetails";
                                
                                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               stringIdMinimumEductionMyProfile,@"EduLevel",
                                                               stringIdExperienceMyProfile,@"ExpYears",
                                                               stringIdMajorEducationMyProfile,@"EduCategory",
                                                               stringIdOccupationMyProfile,@"Occupation",
                                                               @"0",@"CurrentlyEmployed",
                                                               @"0",@"PreferredJobType",
                                                               @"",@"CareerObjective",
                                                               @"",@"RecentJobTitle",
                                                               @"",@"CurrentEmployer",
                                                               @"0",@"SalaryMinimum",
                                                               @"0",@"SalaryMaximum",
                                                               @"false",@"USEligible",
                                                               @"false",@"CanadianEligible",
                                                               @"",@"Associations",
                                                               stringIdIndustryMyProfile,@"iType",
                                                               stringIdCareersMyProfile,@"cType",
                                                               [JSONDictDetails valueForKey:@"Email"],@"email",
                                                               [JSONDictDetails valueForKey:@"FirstName"],@"firstname",
                                                               [JSONDictDetails valueForKey:@"LastName"],@"lastname",
                                                               [JSONDictDetails valueForKey:@"Address"],@"address",
                                                               [JSONDictDetails valueForKey:@"Address2"],@"address2",
                                                               @"",@"city",
                                                               [JSONDictDetails valueForKey:@"StateID"],@"stateid",
                                                               [JSONDictDetails valueForKey:@"CountryID"],@"countryid",
                                                               @"",@"postalcode",
                                                               @"",@"PhoneWork",
                                                               @"",@"CellPhone",
                                                               @"",@"fax",
                                                               @"",@"website",
                                                               @"",@"password",          ///////
                                                               @"",@"password_old",
                                                               @"1",@"TypeID",
                                                               @"",@"referredby",
                                                               @"",@"CurrSalary",
                                                               @"",@"EduInfo",
                                                               @"TRUE",@"approved",
                                                               @"0",@"ResumeID",
                                                               [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                                               @"update",@"mode",
                                                               nil];
                                
                                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                                
                                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                                [jsonParser parseSoapWithJSONSoapContents:dictToSend];
                                
                            }else{
                                [self showAlertViewWithMessage:@"Please select preferred industry type" withTitle:@"Error"];
                            }
                        }else{
                            [self showAlertViewWithMessage:@"Please select preferred career type" withTitle:@"Error"];
                        }
                    }else{
                        [self showAlertViewWithMessage:@"Please select education major / discipline category" withTitle:@"Error"];
                    }
                }else{
                    [self showAlertViewWithMessage:@"Please select minimum education completed" withTitle:@"Error"];
                }
            }else{
                [self showAlertViewWithMessage:@"Please select most recent / current occupation" withTitle:@"Error"];
            }
        }else{
            [self showAlertViewWithMessage:@"Please select number of years experience" withTitle:@"Error"];
        }
    }
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)callWebServiceMyProfileDetails{
    flagGetMyProfileDetails = TRUE;
    jsonParser3 = [APParser sharedParser];
    jsonParser3.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetMemberProfileDetail";
    NSString* soapAction = @"http://tempuri.org/GetMemberProfileDetail";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",@" ",@"email",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:5];
    [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)viewDidDisappear:(BOOL)animated{
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)buttonActionNext:(id)sender {
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
        [self performSegueWithIdentifier:@"SegueMyPfofileSubmitView" sender:self];
        
        ///////////////////////////////////// Delete existing files in document direcotyr /////////////////////////////////
        NSString *fileDoc;
        NSError *error;
        
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
        NSFileManager *localFileManager=[[NSFileManager alloc] init];
        NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
        while ((fileDoc = [dirEnum nextObject])) {
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docsDir,fileDoc];
            [localFileManager removeItemAtPath: fullPath error:&error ];
        }
        NSString *docsDirCover = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
        NSFileManager *localFileManagerCover = [[NSFileManager alloc] init];
        NSDirectoryEnumerator *dirEnumCover = [localFileManagerCover enumeratorAtPath:docsDirCover];
        while ((fileDoc = [dirEnumCover nextObject])) {
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docsDirCover,fileDoc];
            [localFileManagerCover removeItemAtPath: fullPath error:&error ];
        }
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    }
}
@end
