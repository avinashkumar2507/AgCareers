//
//  ApplyDetailsViewController.m
//  AgCareers
//
//  Created by Unicorn on 07/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "ApplyDetailsViewController.h"
#import "ApplySubmitViewController.h"
@interface ApplyDetailsViewController ()

@end

@implementation ApplyDetailsViewController
@synthesize myPicker,pickerParentView;
@synthesize textFieldExperience,textFieldCareerType,textFieldIndustryType,textFieldMejorEducation,textFieldMinimumEducation,textFieldOccupation;
@synthesize applyConditionDetails;
@synthesize buttonApplyOnline;

BOOL flagExperienceApplyDetails         = FALSE;
BOOL flagOccupationApplyDetails         = FALSE;
BOOL flagMinimumExperienceApplyDetails  = FALSE;
BOOL flagMaximumExperienceApplyDetails  = FALSE;
BOOL flagCareersTypeApplyDetails        = FALSE;
BOOL flagIndustryTypeApplyDetails       = FALSE;
BOOL flagGetApplyDetails                = FALSE;
BOOL flagSaveMemberDetailsApplyDetails  = FALSE;
BOOL flagApplyNewJobDetails = FALSE;
NSString *stringIdExperienceApplyDetails       = @"";
NSString *stringIdOccupationApplyDetails       = @"";
NSString *stringIdMinimumEductionApplyDetails  = @"";
NSString *stringIdMajorEducationApplyDetails   = @"";
NSString *stringIdCareersApplyDetails          = @"";
NSString *stringIdIndustryApplyDetails         = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    stringIdCareersApplyDetails          = @"";
    stringIdIndustryApplyDetails         = @"";
    
    [buttonApplyOnline setTitle:@"Apply online" forState:UIControlStateNormal];
    
    if ([applyConditionDetails isEqualToString:@"ApplyWithLogin"]) {
        [self callWebServiceMyProfileDetails];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    flagExperienceApplyDetails         = FALSE;
    flagOccupationApplyDetails         = FALSE;
    flagMinimumExperienceApplyDetails  = FALSE;
    flagMaximumExperienceApplyDetails  = FALSE;
    flagCareersTypeApplyDetails        = FALSE;
    flagIndustryTypeApplyDetails       = FALSE;
    
    //flagGetApplyDetails = FALSE;
    flagSaveMemberDetailsApplyDetails = FALSE;
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    dict = appDelegate.applyProfileDictionary;
    
    NSLog(@"ATS job: %@",appDelegate.stringATSJob);
    
    if ([appDelegate.stringATSJob length]>0) {
        
        [buttonApplyOnline setHidden:NO];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [buttonApplyOnline setHidden:YES];
    }
    
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        
    }else{
        if ([applyConditionDetails isEqualToString:@"ApplyWithOutLogin"]) {
            
        }else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
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
        
        if (flagExperienceApplyDetails == TRUE) {
            flagExperienceApplyDetails = FALSE;
            [textFieldExperience setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdExperienceApplyDetails = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagOccupationApplyDetails == TRUE) {
            flagOccupationApplyDetails = FALSE;
            [textFieldOccupation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdOccupationApplyDetails = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagMinimumExperienceApplyDetails == TRUE) {
            flagMinimumExperienceApplyDetails = FALSE;
            [textFieldMinimumEducation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdMinimumEductionApplyDetails = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagMaximumExperienceApplyDetails == TRUE) {
            flagMaximumExperienceApplyDetails = FALSE;
            [textFieldMejorEducation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdMajorEducationApplyDetails = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagIndustryTypeApplyDetails == TRUE) {
            flagIndustryTypeApplyDetails = FALSE;
            [textFieldIndustryType setText:[[arrayPickerData valueForKey:@"CategoryName"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdIndustryApplyDetails = [[arrayPickerData valueForKey:@"CategoryID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            pickerParentView.hidden = YES;
        }
        if (flagCareersTypeApplyDetails == TRUE) {
            flagCareersTypeApplyDetails = FALSE;
            [textFieldCareerType setText:[[arrayPickerData valueForKey:@"CategoryName"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdCareersApplyDetails = [[arrayPickerData valueForKey:@"CategoryID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
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
    if (flagCareersTypeApplyDetails == TRUE | flagIndustryTypeApplyDetails == TRUE) {
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
    if (successBool == YES) {
        
        if (flagExperienceApplyDetails == TRUE) {
            
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            arrayPickerData = [JSONDict valueForKey:@"Rows"];
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        } else if (flagOccupationApplyDetails == TRUE) {
            
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
        else if (flagMinimumExperienceApplyDetails == TRUE) {
            
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            arrayPickerData = [JSONDict valueForKey:@"Rows"];
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        } else if (flagMaximumExperienceApplyDetails == TRUE) {
            
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            arrayPickerData = [JSONDict valueForKey:@"Rows"];
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        } else if (flagIndustryTypeApplyDetails == TRUE) {
            
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            arrayPickerData = [JSONDict valueForKey:@"CategorysList"];
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        } else if (flagCareersTypeApplyDetails == TRUE) {
            
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            arrayPickerData = [JSONDict valueForKey:@"CategorysList"];
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        } else if (flagSaveMemberDetailsApplyDetails == TRUE) {
            flagSaveMemberDetailsApplyDetails = FALSE;
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
        } else if (flagGetApplyDetails == TRUE){
            flagGetApplyDetails = FALSE;
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            [textFieldExperience setText:[JSONDict valueForKey:@"Experience"]];
            [textFieldOccupation setText:[JSONDict valueForKey:@"Occupation"]];
            [textFieldMinimumEducation setText:[JSONDict valueForKey:@"MinEducation"]];
            [textFieldMejorEducation setText:[JSONDict valueForKey:@"MaxEducation"]];
            [textFieldCareerType setText:[JSONDict valueForKey:@"CareerType"]];
            [textFieldIndustryType setText:[JSONDict valueForKey:@"IndustryType"]];
            
            stringIdExperienceApplyDetails = [JSONDict valueForKey:@"ExpYearsid"];
            stringIdOccupationApplyDetails = [JSONDict valueForKey:@"Occupationid"];
            stringIdMinimumEductionApplyDetails = [JSONDict valueForKey:@"MinEducationID"];
            stringIdMajorEducationApplyDetails = [JSONDict valueForKey:@"MaxEducationID"];
            stringIdCareersApplyDetails = [JSONDict valueForKey:@"CareerTypeID"];
            stringIdIndustryApplyDetails = [JSONDict valueForKey:@"IndustryTypeID"];
        }else if (flagApplyNewJobDetails == TRUE){
            flagApplyNewJobDetails = FALSE;
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            if ([[JSONDict valueForKey:@"ErrorMsg"]isEqualToString:@"Applied Successfully."]) {
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
                NSString *stringCompanyName = appDelegate.stringCompany;
                NSString *str = [NSString stringWithFormat:@"%@ requires candidates to submit a resume through their online application site. Please tap below to be redirected to the %@ application page for this job.",stringCompanyName,stringCompanyName];
                
                alertSuccessApply = [[UIAlertView alloc]initWithTitle:@"Success" message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
                [alertSuccessApply show];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[JSONDict valueForKey:@"ErrorMsg"]
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else{
            
        }
    }else{ //if (successBool == YES) {
        [HUD hide:YES];
        UIAlertView *alertSuccessStatus = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSuccessStatus show];
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
        flagExperienceApplyDetails          = TRUE;
        flagOccupationApplyDetails          = FALSE;
        flagMinimumExperienceApplyDetails   = FALSE;
        flagMaximumExperienceApplyDetails   = FALSE;
        flagIndustryTypeApplyDetails        = FALSE;
        flagCareersTypeApplyDetails         = FALSE;
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
        flagExperienceApplyDetails          = FALSE;
        flagOccupationApplyDetails          = TRUE;
        flagMinimumExperienceApplyDetails   = FALSE;
        flagMaximumExperienceApplyDetails   = FALSE;
        flagIndustryTypeApplyDetails        = FALSE;
        flagCareersTypeApplyDetails         = FALSE;
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
        flagExperienceApplyDetails          = FALSE;
        flagOccupationApplyDetails          = FALSE;
        flagMinimumExperienceApplyDetails   = TRUE;
        flagMaximumExperienceApplyDetails   = FALSE;
        flagIndustryTypeApplyDetails        = FALSE;
        flagCareersTypeApplyDetails         = FALSE;
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
        flagExperienceApplyDetails          = FALSE;
        flagOccupationApplyDetails          = FALSE;
        flagMinimumExperienceApplyDetails   = FALSE;
        flagMaximumExperienceApplyDetails   = TRUE;
        flagIndustryTypeApplyDetails        = FALSE;
        flagCareersTypeApplyDetails         = FALSE;
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
        flagExperienceApplyDetails          = FALSE;
        flagOccupationApplyDetails          = FALSE;
        flagMinimumExperienceApplyDetails   = FALSE;
        flagMaximumExperienceApplyDetails   = FALSE;
        flagIndustryTypeApplyDetails        = TRUE;
        flagCareersTypeApplyDetails         = FALSE;
        [self callWebServiceIndustryType];
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
        flagExperienceApplyDetails          = FALSE;
        flagOccupationApplyDetails          = FALSE;
        flagMinimumExperienceApplyDetails   = FALSE;
        flagMaximumExperienceApplyDetails   = FALSE;
        flagIndustryTypeApplyDetails        = FALSE;
        flagCareersTypeApplyDetails         = TRUE;
        [self callWebServiceCareersType];
    }
}

//BOOL flagUpdateDetailsMyProfile
- (IBAction)buttonActionUpdate:(id)sender {
    
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

-(void)callWebServiceMyProfileDetails{
    flagGetApplyDetails = TRUE;
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

-(void)viewDidDisappear:(BOOL)animated {
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
        if ([textFieldExperience.text length]>0) {
            
            if ([textFieldOccupation.text length]>0) {
                
                if ([textFieldMinimumEducation.text length]>0) {
                    
                    if ([textFieldMejorEducation.text length]>0) {
                        //flagSaveMemberDetailsApplyDetails = TRUE;
                        
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
                        
                        
                        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       stringIdMinimumEductionApplyDetails,@"EduLevel",
                                                       stringIdExperienceApplyDetails,@"ExpYears",
                                                       stringIdMajorEducationApplyDetails,@"EduCategory",
                                                       stringIdOccupationApplyDetails,@"Occupation",
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
                                                       stringIdIndustryApplyDetails,@"iType",
                                                       stringIdCareersApplyDetails,@"cType",
                                                       [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                                       nil];
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                        appDelegate.applyDetailsDictionary = parameterDict;
                        
                        [self performSegueWithIdentifier:@"SegueApplySubmit" sender:self];
                        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueApplySubmit"]) {
        ApplySubmitViewController *applySubmitViewController = [segue destinationViewController];
        applySubmitViewController.applyConditionSumit = applyConditionDetails;
        applySubmitViewController.stringIdCareersApply = stringIdCareersApplyDetails;
        applySubmitViewController.stringIdIndustryApply = stringIdIndustryApplyDetails;
    }
}

- (IBAction)buttonActionApplyOnline:(id)sender {
    [self callWebServiceNewJobApply];
}

-(void)callWebServiceNewJobApply {
    
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
                        //flagSaveMemberDetailsApplyDetails = TRUE;
                        
                        NSDictionary* parameterDictDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              stringIdMinimumEductionApplyDetails,@"EduLevel",
                                                              stringIdExperienceApplyDetails,@"ExpYears",
                                                              stringIdMajorEducationApplyDetails,@"EduCategory",
                                                              stringIdOccupationApplyDetails,@"Occupation",
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
                                                              stringIdIndustryApplyDetails,@"iType",
                                                              stringIdCareersApplyDetails,@"cType",
                                                              [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                                              nil];
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                        appDelegate.applyDetailsDictionary = parameterDictDetails;
                        
                        flagApplyNewJobDetails = TRUE;
                        jsonParser3 = [APParser sharedParser];
                        jsonParser3.delegate = self;
                        
                        [self.tabBarController.view setUserInteractionEnabled:NO];
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        HUD.delegate = self;
                        HUD.labelText = @"Loading";
                        [HUD show:YES];
                        
                        NSString* methodName = @"NewJobApply";
                        NSString* soapAction = @"http://tempuri.org/NewJobApply";
                        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                        NSDictionary *dictProfile = [[NSDictionary alloc]init];
                        NSDictionary *dictDetails = [[NSDictionary alloc]init];
                        dictProfile = appDelegate.applyProfileDictionary;
                        dictDetails = appDelegate.applyDetailsDictionary;
                        NSString *strinJobId = appDelegate.stringJobIdCreateProfile;
                        NSString *stringmemberId;
                        if ([applyConditionDetails isEqualToString:@"ApplyWithOutLogin"]) {
                            stringmemberId = @"0";
                        }else{
                            stringmemberId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"];
                        }
                        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:strinJobId,@"JobID",
                                                       stringmemberId,@"MemberID",
                                                       [dictProfile valueForKey:@"firstname"],@"firstname",
                                                       [dictProfile valueForKey:@"lastname"],@"lastname",
                                                       [dictProfile valueForKey:@"address"],@"Address1",
                                                       [dictProfile valueForKey:@"address2"],@"Address2",
                                                       [dictProfile valueForKey:@"city"],@"city",
                                                       [dictProfile valueForKey:@"countryid"],@"CountryID",
                                                       [dictProfile valueForKey:@"stateid"],@"StateID",
                                                       [dictProfile valueForKey:@"postalcode"],@"PostalCode",
                                                       [dictProfile valueForKey:@"email"],@"Email",
                                                       [dictProfile valueForKey:@"PhoneWork"],@"PhoneWork",
                                                       [dictDetails valueForKey:@"ExpYears"],@"ExperienceID",
                                                       [dictDetails valueForKey:@"EduLevel"],@"MinEducationID",
                                                       [dictDetails valueForKey:@"EduCategory"],@"MaxEducationID",
                                                       [dictDetails valueForKey:@"Occupation"],@"Occupationid",
                                                       @"ATS",@"ResumeFileName",
                                                       @"ATS",@"DescriptiveName",
                                                       @"0",@"ResumeUploadID",
                                                       @"",@"siteURL",
                                                       @"",@"CoverLetterFileName",
                                                       @"",@"CoverLetter",
                                                       @"",@"DEVICEID",
                                                       appDelegate.stringATSJob,@"ApplyURL",
                                                       @"",@"DesiredSalary",
                                                       @"",@"CommutingDistance",
                                                       @"",@"Relocate",
                                                       @"",@"RelocateWhen",
                                                       stringIdIndustryApplyDetails,@"iType",
                                                       stringIdCareersApplyDetails,@"cType",
                                                       nil];
                        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                        
                        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                        [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
                        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(alertView == alertSuccessApply){
        if(buttonIndex == 1){
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
            
            NSURL *url = [NSURL URLWithString:appDelegate.stringATSJob];
            [[UIApplication sharedApplication] openURL:url];
            
            if (self.tabBarController.selectedIndex == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }else {
            if (self.tabBarController.selectedIndex == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
    }
}

@end
