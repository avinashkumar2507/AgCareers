//
//  CreateProfileSecondViewController.m
//  AgCareers
//
//  Created by Unicorn on 18/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "CreateProfileSecondViewController.h"
#import "CreateProfileSubmitViewController.h"
#import "IndustryAndCareerViewController.h"
#import <Google/Analytics.h>
@interface CreateProfileSecondViewController ()

@end

@implementation CreateProfileSecondViewController
@synthesize myPicker,pickerParentView;
@synthesize textFieldExperience,textFieldCareerType,textFieldIndustryType,textFieldMejorEducation,textFieldMinimumEducation,textFieldOccupation;
@synthesize strMemId,buttonApplyOnline;

BOOL flagExperience         = FALSE;
BOOL flagOccupation         = FALSE;
BOOL flagMinimumExperience  = FALSE;
BOOL flagMaximumExperience  = FALSE;
BOOL flagCareersType        = FALSE;
BOOL flagIndustryType       = FALSE;


NSString *stringIdCareers           = @"";
NSString *stringIdIndustry          = @"";
NSString *stringIdExperience        = @"";
NSString *stringIdOccupation        = @"";
NSString *stringIdMinimumEduction   = @"";
NSString *stringIdMajorEducation    = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    stringIdCareers           = @"";
    stringIdIndustry          = @"";

    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueCreateProfileSubmit"]) {
        CreateProfileSubmitViewController *createProfileSubmitViewController = [segue destinationViewController];
        createProfileSubmitViewController.strMemIdSubmit = strMemId;
        
        createProfileSubmitViewController.stringIdCareersSubmit = stringIdCareers;
        createProfileSubmitViewController.stringIdIndustrySubmit = stringIdIndustry;
        createProfileSubmitViewController.stringResumeId = stringResumeIdCreate;
    }//SegueIndustryCareerCreateProfile
    if ([segue.identifier isEqualToString:@"SegueIndustryCareerCreateProfile"]) {
        IndustryAndCareerViewController *selectSectroViewController = [segue destinationViewController];
        selectSectroViewController.delegateIndustryCareerProtocol = self;
        if (flagCareersType == TRUE) {
            selectSectroViewController.stringTitle = @"Career";
            selectSectroViewController.stringWSName = @"GetCareerTypes";
            selectSectroViewController.stringId = stringIdCareers;
            selectSectroViewController.stringValues = stringCareerNamesCreate;
            
        }
        if (flagIndustryType == TRUE) {
            selectSectroViewController.stringTitle = @"Industry";
            selectSectroViewController.stringWSName = @"GetIndustryTypes";
            selectSectroViewController.stringId = stringIdIndustry;
            selectSectroViewController.stringValues = stringIndutryNamesCreate;
        }
    }
    
}

#pragma mark selectSectorsViewController delegate
-(void)sendIndustryCareerDictionary : (NSMutableDictionary *)sectorsDictionary{
    
    if (flagCareersType == TRUE) {
        flagCareersType = FALSE;
        textFieldCareerType.text = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringCareerNamesCreate = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringIdCareers = [[sectorsDictionary objectForKey:@"arraySectorIds"]componentsJoinedByString:@","] ;
        //dictionaryCareer = sectorsDictionary;
    }
    if (flagIndustryType == TRUE) {
        flagIndustryType = FALSE;
        textFieldIndustryType.text = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringIndutryNamesCreate = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
        stringIdIndustry = [[sectorsDictionary objectForKey:@"arraySectorIds"]componentsJoinedByString:@","] ;
        //dictionaryIndustry = sectorsDictionary;
    }
}

- (IBAction)buttonActionDone:(id)sender {
    pickerParentView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Picker view single tap
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagExperience == TRUE) {
            
            flagExperience = FALSE;
            [textFieldExperience setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdExperience = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringIdExperience :%@",stringIdExperience);
            pickerParentView.hidden = YES;
        }
        if (flagOccupation == TRUE) {
            flagOccupation = FALSE;
            [textFieldOccupation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdOccupation = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringIdOccupation :%@",stringIdOccupation);
            pickerParentView.hidden = YES;
        }
        if (flagMinimumExperience == TRUE) {
            flagMinimumExperience = FALSE;
            [textFieldMinimumEducation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdMinimumEduction = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringIdMinimumEduction :%@",stringIdMinimumEduction);
            pickerParentView.hidden = YES;
        }
        if (flagMaximumExperience == TRUE) {
            flagMaximumExperience = FALSE;
            [textFieldMejorEducation setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdMajorEducation = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringIdMajorEducation :%@",stringIdMajorEducation);
            pickerParentView.hidden = YES;
        }
        if (flagIndustryType == TRUE) {
            flagIndustryType = FALSE;
            [textFieldIndustryType setText:[[arrayPickerData valueForKey:@"CategoryName"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdIndustry = [[arrayPickerData valueForKey:@"CategoryID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringIdIndustry :%@",stringIdIndustry);
            pickerParentView.hidden = YES;
        }
        if (flagCareersType == TRUE) {
            flagCareersType = FALSE;
            [textFieldCareerType setText:[[arrayPickerData valueForKey:@"CategoryName"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringIdCareers = [[arrayPickerData valueForKey:@"CategoryID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringIdCareers :%@",stringIdCareers);
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
    if (flagCareersType == TRUE | flagIndustryType == TRUE) {
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

-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if ([appDelegate.stringATSJob length]>0) {
        //self.navigationItem.hidesBackButton = YES;
        [buttonApplyOnline setHidden:NO];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [buttonApplyOnline setHidden:YES];
    }

    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Create Profile Two Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        
        //[self performSegueWithIdentifier:@"SegueShowProfileDetailsAndEdit" sender:self];
        //   [self callWebService];
    }else {
        //User is not logged in
        
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:NO completion:NULL];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self hideHUDandWebservice];
}

-(void)viewDidDisappear:(BOOL)animated {
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool {
    
    if (flagExperience == TRUE) {
        
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
    if (flagOccupation == TRUE) {
        
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
    if (flagMinimumExperience == TRUE) {
        
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
    if (flagMaximumExperience == TRUE) {
        
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
    if (flagIndustryType == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"CategorysList"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    }
    if (flagCareersType == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"CategorysList"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    }
    if (flagSaveMemberDetails == TRUE) {
        flagSaveMemberDetails = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        stringResumeIdCreate = [JSONDict valueForKey:@"ID2"];
//        [[NSUserDefaults standardUserDefaults]setObject:[JSONDict valueForKey:@"ID2"] forKey:@"ResumeIdFromCreate"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [self performSegueWithIdentifier:@"SegueCreateProfileSubmit" sender:self];
        }else{
            [self showAlertViewWithMessage:@"Some error occured. Please try again later."];
        }
    }
    if (flagApplyNewJobCreate == TRUE){
        flagApplyNewJobCreate = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [buttonApplyOnline setTitle:@"Applied already" forState:UIControlStateNormal];
            [buttonApplyOnline setEnabled:NO];
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
            NSString *stringCompanyName = appDelegate.stringCompany;
            NSString *str = [NSString stringWithFormat:@"%@ requires candidates to submit a resume through their online application site. Please click below to be redirected to the %@ application page for this job.",stringCompanyName,stringCompanyName];
            
            alertSuccessApply = [[UIAlertView alloc]initWithTitle:@"Success" message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
            [alertSuccessApply show];
            
        }else{
            [buttonApplyOnline setEnabled:YES];
            //[self showAlertViewWithMessage:@"Some error occured. Please try again later." withTitle:@"Error"];
            alertP = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
            [alertP show];
        }
    }
}

NSString *stringResumeIdCreate = @"";

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
        flagExperience          = TRUE;
        flagOccupation          = FALSE;
        flagMinimumExperience   = FALSE;
        flagMaximumExperience   = FALSE;
        flagIndustryType        = FALSE;
        flagCareersType         = FALSE;
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
        flagExperience          = FALSE;
        flagOccupation          = TRUE;
        flagMinimumExperience   = FALSE;
        flagMaximumExperience   = FALSE;
        flagIndustryType        = FALSE;
        flagCareersType         = FALSE;
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
        flagExperience          = FALSE;
        flagOccupation          = FALSE;
        flagMinimumExperience   = TRUE;
        flagMaximumExperience   = FALSE;
        flagIndustryType        = FALSE;
        flagCareersType         = FALSE;
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
        flagExperience          = FALSE;
        flagOccupation          = FALSE;
        flagMinimumExperience   = FALSE;
        flagMaximumExperience   = TRUE;
        flagIndustryType        = FALSE;
        flagCareersType         = FALSE;
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
        flagExperience          = FALSE;
        flagOccupation          = FALSE;
        flagMinimumExperience   = FALSE;
        flagMaximumExperience   = FALSE;
        flagIndustryType        = TRUE;
        flagCareersType         = FALSE;
        [self performSegueWithIdentifier:@"SegueIndustryCareerCreateProfile" sender:self];
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
        flagExperience          = FALSE;
        flagOccupation          = FALSE;
        flagMinimumExperience   = FALSE;
        flagMaximumExperience   = FALSE;
        flagIndustryType        = FALSE;
        flagCareersType         = TRUE;
        [self performSegueWithIdentifier:@"SegueIndustryCareerCreateProfile" sender:self];
        //[self callWebServiceCareersType];
    }
}

BOOL flagSaveMemberDetails = FALSE;
- (IBAction)buttonActionNext:(id)sender {
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
        //[self performSegueWithIdentifier:@"SegueCreateProfileSubmit" sender:self];
        
        if ([textFieldExperience.text length]>0) {
            
            if ([textFieldOccupation.text length]>0) {
                
                if ([textFieldMinimumEducation.text length]>0) {
                    
                    if ([textFieldMejorEducation.text length]>0) {
                        
                        if ([textFieldCareerType.text length]>0) {
                            
                            if ([textFieldIndustryType.text length]>0) {
                                
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

                                flagSaveMemberDetails = TRUE;
                                jsonParser = [APParser sharedParser];
                                jsonParser.delegate = self;
                                [self.tabBarController.view setUserInteractionEnabled:NO ];
                                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                                [self.navigationController.view addSubview:HUD];
                                HUD.delegate = self;
                                HUD.labelText = @"Loading";
                                [HUD show:YES];
                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                NSDictionary *memberDictionary = appDelegate.applyProfileDictionary;
                                
                                NSString* methodName = @"SaveMemberDetails";
                                NSString* soapAction = @"http://tempuri.org/SaveMemberDetails";
                                //38
                                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [memberDictionary valueForKey:@"email"],@"email",
                                                               [memberDictionary valueForKey:@"firstname"],@"firstname",
                                                               [memberDictionary valueForKey:@"lastname"],@"lastname",
                                                               [memberDictionary valueForKey:@"address"],@"address",
                                                               [memberDictionary valueForKey:@"address2"],@"address2",
                                                               @"",@"city",
                                                               [memberDictionary valueForKey:@"stateid"],@"stateid",
                                                               [memberDictionary valueForKey:@"countryid"],@"countryid",
                                                               @"",@"postalcode",
                                                               @"",@"PhoneWork",
                                                               @"",@"CellPhone",
                                                               @"",@"fax",
                                                               @"",@"website",
                                                               @"",@"password",
                                                               @"",@"password_old",
                                                               @"1",@"TypeID",
                                                               @"",@"referredby",
                                                               @"",@"CurrSalary",
                                                               @"",@"EduInfo",
                                                               @"TRUE",@"approved",
                                                               stringIdMinimumEduction,@"EduLevel",
                                                               stringIdExperience,@"ExpYears",
                                                               stringIdMajorEducation,@"EduCategory",
                                                               stringIdOccupation,@"Occupation",
                                                               @"0",@"CurrentlyEmployed",
                                                               @"0",@"PreferredJobType",
                                                               @"",@"CareerObjective",
                                                               @"",@"RecentJobTitle",
                                                               @"",@"CurrentEmployer",
                                                               @"0",@"SalaryMinimum",
                                                               @"0",@"SalaryMaximum",
                                                               @"false",@"USEligible",
                                                               @"false",@"CanadianEligible",
                                                               @"0",@"Associations",
                                                               stringIdIndustry,@"iType",
                                                               stringIdCareers,@"cType",
                                                               [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                                               @"0",@"ResumeID",
                                                               @"create",@"mode",
                                                               nil];

                                appDelegate.applyDetailsDictionary = parameterDict;
                                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                                
                                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                                [jsonParser parseSoapWithJSONSoapContents:dictToSend];
                                
                            }else{
                                [self showAlertViewWithMessage:@"Please select preferred industry type"];
                            }
                        }else{
                            [self showAlertViewWithMessage:@"Please select preferred career type"];
                        }
                    }else{
                        [self showAlertViewWithMessage:@"Please select education major / discipline category"];
                    }
                }else{
                    [self showAlertViewWithMessage:@"Please select minimum education completed"];
                }
            }else{
                [self showAlertViewWithMessage:@"Please select most recent / current occupation"];
            }
        }else{
            [self showAlertViewWithMessage:@"Please select number of years experience"];
        }
    }
}

-(void)showAlertViewWithMessage :(NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:@"Error" message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}
BOOL flagApplyNewJobCreate = FALSE;
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
                        
                        if ([textFieldCareerType.text length]>0) {
                            
                            if ([textFieldIndustryType.text length]>0) {

                                flagApplyNewJobCreate = TRUE;
                                NSDictionary* parameterDictDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               stringIdMinimumEduction,@"EduLevel",
                                                               stringIdExperience,@"ExpYears",
                                                               stringIdMajorEducation,@"EduCategory",
                                                               stringIdOccupation,@"Occupation",
                                                               @"0",@"CurrentlyEmployed",
                                                               @"0",@"PreferredJobType",
                                                               @"",@"CareerObjective",
                                                               @"",@"RecentJobTitle",
                                                               @"",@"CurrentEmployer",
                                                               @"0",@"SalaryMinimum",
                                                               @"0",@"SalaryMaximum",
                                                               @"false",@"USEligible",
                                                               @"false",@"CanadianEligible",
                                                               @"0",@"Associations",
                                                               stringIdIndustry,@"iType",
                                                               stringIdCareers,@"cType",
                                                               [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                                               nil];
                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                appDelegate.applyDetailsDictionary = parameterDictDetails;
                                
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
                                NSString *jobID = appDelegate.stringJobIdCreateProfile;
                                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:jobID,@"JobID",
                                                               [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
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
                                                               @"ATS",@"CoverLetterFileName",
                                                               @"ATS",@"CoverLetter",
                                                               @"",@"DEVICEID",
                                                               appDelegate.stringATSJob,@"ApplyURL",
                                                               @"",@"DesiredSalary",
                                                               @"",@"CommutingDistance",
                                                               @"",@"Relocate",
                                                               @"",@"RelocateWhen",
                                                               stringIdIndustry,@"iType",
                                                               stringIdCareers,@"cType",
                                                               nil];
                                
                                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                                
                                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                                [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];

                            }else{
                                [self showAlertViewWithMessage:@"Please select preferred industry type"];
                            }
                        }else{
                            [self showAlertViewWithMessage:@"Please select preferred career type"];
                        }
                    }else{
                        [self showAlertViewWithMessage:@"Please select education major / discipline category"];
                    }
                }else{
                    [self showAlertViewWithMessage:@"Please select minimum education completed"];
                }
            }else{
                [self showAlertViewWithMessage:@"Please select most recent / current occupation"];
            }
        }else{
            [self showAlertViewWithMessage:@"Please select number of years experience"];
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
            
        }else{
            if (self.tabBarController.selectedIndex == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
    }
}

@end
