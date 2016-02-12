//
//  MyProfileViewController.m
//  AgCareers
//
//  Created by Unicorn on 03/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "MyProfileViewController.h"
#import "LoginPopOverViewController.h"
#import "OptionsViewController.h"
#import <Google/Analytics.h>
#import "CreateProfileViewController.h"
@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
@synthesize buttonNext;
@synthesize scrollViewCreateProfile;
@synthesize textFieldFirstName,textFieldLastName,textFieldAddress1,textFieldAddress2,textFieldState,textFieldCountry,textFieldEmail,textFieldEmailConfirm,textFieldPassword,textFieldPasswordConfirm;
@synthesize pickerParentView,myPicker,buttonDone,myViewPassword,textfieldPassword,textfieldUsername;
@synthesize myView;

BOOL flagCountryMyProfile           = FALSE;
BOOL flagLoginMyProfileView         = FALSE;
BOOL flagStateMyProfile             = FALSE;
BOOL flagForgotPasswordMyProfile    = FALSE;
BOOL textFieldFlag                  = FALSE;
BOOL flagMyProfile                  = FALSE;
NSString *stringCountryIdMyProfile  = @"";

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [myViewPassword setHidden:YES];
    dictionaryState = [[NSMutableDictionary alloc]init];
    //self.tabBarController.delegate = self;
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
}

-(void)viewDidLayoutSubviews{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:@"UIKeyboardWillShowNotification"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:@"UIKeyboardDidHideNotification"
//                                               object:nil];
}

- (void) keyboardWillShow:(NSNotification *)note {
    
    //if(textFieldFlag == TRUE) {
        NSDictionary *userInfo = [note userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
        // move the view up by 50 pts
        CGRect frame = self.view.frame;
        frame.origin.y = -50;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
    //}
}

- (void) keyboardDidHide:(NSNotification *)note {
    //if(textFieldFlag == FALSE) {
        // move the view back to the origin
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
    //}
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [scrollViewCreateProfile setContentSize:CGSizeMake(300, 480)];
    }else{
        [scrollViewCreateProfile setContentSize:CGSizeMake(300, 480)];
    }
}

#pragma mark Call web service
-(void)callMyProfileWebService {
    flagMyProfile = TRUE;
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
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
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)viewWillAppear:(BOOL)animated{
    [textfieldUsername setText:@""];
    [textfieldPassword setText:@""];
    flagCountryMyProfile = FALSE;
    flagStateMyProfile = FALSE;
    flagUpdate = FALSE;
    flagLoginMyProfileView = FALSE;
    flagForgotPasswordMyProfile = FALSE;
    
    pickerParentView.hidden = YES;
    //    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
    //        // User is already logged in
    //           [self callMyProfileWebService];
    //    }else {
    //        //User is not logged in
    //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
    //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //        [self presentViewController:vc animated:NO completion:NULL];
    //    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        //#import <Google/Analytics.h>
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"iOS- My Profile Screen"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
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
            
            [self callMyProfileWebService];
        }
        
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [myView setHidden: YES];
    }else {
        
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [myView setHidden: NO];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueMyPfofileNextView"]) {
        
    }
    if ([segue.identifier isEqualToString:@"logonSegueFromMyProfile"]) {
        
    }
    if ([segue.identifier isEqualToString:@"SegueCreateProfileMyProfiles"]) {
        CreateProfileViewController *createProfileViewController = [segue destinationViewController];
        createProfileViewController.stringEmailIDCreateProfile = @"";
    }
}

#pragma mark Country selection delegate method
-(void)sendCountryDictionary : (NSMutableDictionary *) dictionaryCountry {
    [textFieldCountry setText:[[dictionaryCountry objectForKey:@"arrayTypeName"]objectAtIndex:0]];
    stringCountryIdMyProfile = [[dictionaryCountry objectForKey:@"arrayTypeIds"]objectAtIndex:0];
    stringStateIdMyProfile = @"";
    [textFieldState setText:@""];
}

NSString *stringStateIdMyProfile = @"";
#pragma mark Edit Careers Types delegate method
-(void)sendStatesDictionary : (NSMutableDictionary *) dictionaryStates {
    NSString *stringNew = [[dictionaryStates objectForKey:@"arrayTypeName"] componentsJoinedByString:@","];
    dictionaryState = dictionaryStates;
    stringStateIdMyProfile = [[dictionaryState objectForKey:@"arrayTypeIds"] componentsJoinedByString:@","];
    [textFieldState setText:stringNew];
}


#pragma mark TextField delegate method\

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 50;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { // return NO to disallow editing.
    
    if (textField==textfieldUsername || textField == textfieldPassword) {
        textFieldFlag = TRUE;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {           // became first responder
    
    
    if (textField == textfieldUsername || textField == textfieldPassword) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (isiPhone5)
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 50.0), self.view.frame.size.width, self.view.frame.size.height);
        else
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 50.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField==textfieldUsername || textField == textfieldPassword) {
        textFieldFlag = TRUE;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    if (textField==textfieldUsername || textField == textfieldPassword) {
        textFieldFlag = FALSE;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if (textField == textfieldUsername || textField == textfieldPassword) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        if (isiPhone5)
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+50), self.view.frame.size.width, self.view.frame.size.height);
        else
            self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+50), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from
    if (textField==textfieldUsername || textField == textfieldPassword) {
        textFieldFlag = FALSE;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textfieldUsername resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    [textFieldFirstName resignFirstResponder];
    [textFieldLastName resignFirstResponder];
    [textFieldAddress1 resignFirstResponder];
    [textFieldAddress2 resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textFieldEmailConfirm resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldPasswordConfirm resignFirstResponder];
    return YES;
}
-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

- (IBAction)buttonActionNext:(id)sender{
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
        [self performSegueWithIdentifier:@"SegueMyPfofileNextView" sender:self];
    }
}
BOOL flagUpdate = FALSE;
- (IBAction)buttonActionUpdate:(id)sender{
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
        flagStateMyProfile = FALSE;
        flagCountryMyProfile = FALSE;
        
        if ([textFieldFirstName.text length]>0) {
            if ([textFieldLastName.text length]>0) {
                if ([textFieldAddress1.text length]>0) {
                    if ([textFieldCountry.text length]>0) {
                        if ([textFieldState.text length]>0) {
                            if ([textFieldEmail.text length]>0) {
                                if ([textFieldEmailConfirm.text length]>0) {
                                    
                                    NSString *rawString = [textFieldEmail text];
                                    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                                    NSRange range = [rawString rangeOfCharacterFromSet:whitespace];
                                    if (range.location != NSNotFound) {
                                        //NSLog(@"white space is there...");
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [alert show];
                                    }else{
                                        if ([textFieldEmail.text isEqualToString:textFieldEmailConfirm.text]) {
                                            
                                            if ([self NSStringIsValidEmail:textFieldEmail.text]) {
                                                flagUpdate = TRUE;
                                                jsonParser = [APParser sharedParser];
                                                jsonParser.delegate = self;
                                                [self.tabBarController.view setUserInteractionEnabled:NO ];
                                                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                                                [self.navigationController.view addSubview:HUD];
                                                HUD.delegate = self;
                                                HUD.labelText = @"Loading";
                                                [HUD show:YES];
                                                
                                                NSString* methodName = @"SaveMember";
                                                NSString* soapAction = @"http://tempuri.org/SaveMember";
                                                
                                                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                               textFieldEmail.text,@"email",
                                                                               textFieldFirstName.text,@"firstname",
                                                                               textFieldLastName.text,@"lastname",
                                                                               textFieldAddress1.text,@"address",
                                                                               textFieldAddress2.text,@"address2",
                                                                               @"",@"city",
                                                                               stringStateIdMyProfile,@"stateid",
                                                                               stringCountryIdMyProfile,@"countryid",
                                                                               @"",@"postalcode",
                                                                               @"",@"PhoneWork",
                                                                               @"",@"CellPhone",
                                                                               @"",@"fax",
                                                                               @"",@"website",
                                                                               textFieldPassword.text,@"password",
                                                                               @"",@"password_old",
                                                                               @"1",@"TypeID",
                                                                               @"",@"referredby",
                                                                               @"",@"CurrSalary",
                                                                               @"",@"EduInfo",
                                                                               @"TRUE",@"approved",
                                                                               [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                                                               nil];
                                                
                                                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                                                
                                                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                                                [jsonParser parseSoapWithJSONSoapContents:dictToSend];
                                                
                                            }else{
                                                [self showAlertViewWithMessage:@"Please enter valid email address" withTitle:@"Error"];
                                            }
                                        }else{
                                            [self showAlertViewWithMessage:@"This value should be the same as Email Field." withTitle:@"Error"];
                                        }
                                    }
                                    
                                }else{
                                    //Confirm email
                                    [self showAlertViewWithMessage:@"Please re-enter email in confirm email" withTitle:@"Error"];
                                }
                            }else{
                                //Email
                                [self showAlertViewWithMessage:@"Please enter email" withTitle:@"Error"];
                            }
                        }else{
                            //State
                            [self showAlertViewWithMessage:@"Please select states" withTitle:@"Error"];
                        }
                    }else{
                        //Country
                        [self showAlertViewWithMessage:@"Please select country" withTitle:@"Error"];
                    }
                }else{
                    //Address 1
                    [self showAlertViewWithMessage:@"Please enter address" withTitle:@"Error"];
                }
            }else{
                //Last name
                [self showAlertViewWithMessage:@"Please enter last name" withTitle:@"Error"];
            }
        }else{
            //First name
            [self showAlertViewWithMessage:@"Please enter first name" withTitle:@"Error"];
        }
    }
}

-(void)hideHUDandWebservice {
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    //[[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    [textfieldUsername resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    
    if (flagCountryMyProfile == TRUE) {
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    }else if (flagStateMyProfile == TRUE){
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        if ([arrayPickerData count]==0) {
            [textFieldState setText:@"None"];
            stringStateIdMyProfile = @"0";
            pickerParentView.hidden = YES;
            flagStateMyProfile = FALSE;
        }else{
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        }
        
    }else if (flagUpdate == TRUE){
        flagUpdate = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        
        if ([[JSONDict valueForKey:@"Success"]intValue]==1)
            [self showAlertViewWithMessage:@"Your profile has been updated successfully" withTitle:@"Success."];
        else
            [self showAlertViewWithMessage:@"There is some error updating your profile. Please try again later." withTitle:@"Error"];
        
    }else if (flagLoginMyProfileView == TRUE){
        [HUD hide:YES];
        flagLoginMyProfileView = FALSE;
        NSError *error;
        NSDictionary *JSONDict11 =
        [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &error];
        if ([[[JSONDict11 valueForKey:@"ErrorFlag"]objectAtIndex:0] isEqualToString:@"Success"]==TRUE) {
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict11 valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict11 valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [myView setHidden:YES];
            [self callMyProfileWebService];
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered an incorrect username/password and/or you are not approved to use the site.If you continue to have problems, please contact agcareers@agcareers.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if (flagForgotPasswordMyProfile == TRUE){
        flagForgotPasswordMyProfile = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [self showAlertViewWithMessage:@"New password has been sent to your email id." withTitle:@"Success"];
        }else {
            [self showAlertViewWithMessage:@"There is some error. Please try again later." withTitle:@"Error"];
        }
    }else {
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        
        textFieldFirstName.text = [JSONDict objectForKey:@"FirstName"];
        textFieldLastName.text = [JSONDict objectForKey:@"LastName"];
        textFieldAddress1.text = [JSONDict objectForKey:@"Address"];
        textFieldAddress2.text = [JSONDict objectForKey:@"Address2"];
        textFieldEmail.text = [JSONDict objectForKey:@"Email"];
        textFieldEmailConfirm.text = [JSONDict objectForKey:@"Email"];
        textFieldCountry.text = [JSONDict objectForKey:@"CountryName"];
        stringCountryIdMyProfile = [JSONDict objectForKey:@"CountryID"];
        
        textFieldState.text = [JSONDict objectForKey:@"StateName"];
        stringStateIdMyProfile = [JSONDict objectForKey:@"StateID"];
        [myView setHidden: YES];
    }
}

#pragma mark email validater
-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)buttonActionDone:(id)sender{
    pickerParentView.hidden = YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagCountryMyProfile == TRUE) {
            
            flagCountryMyProfile = FALSE;
            [textFieldCountry setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringCountryIdMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            
            [textFieldState setText:@""];
            stringStateIdMyProfile = @"0";
            NSLog(@"stringCountryIdCreateProfile :%@",stringCountryIdMyProfile);
            pickerParentView.hidden = YES;
        }
        if (flagStateMyProfile == TRUE) {
            flagStateMyProfile = FALSE;
            [textFieldState setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringStateIdMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringStateIdCreateProfile :%@",stringStateIdMyProfile);
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
    return [[arrayPickerData objectAtIndex:row]valueForKey:@"Name"];
}

- (IBAction)buttonActionCountry:(id)sender {
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
        flagCountryMyProfile = TRUE;
        flagStateMyProfile = FALSE;
        [self callWebServiceCountry];
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
        if ([textFieldCountry.text length]>0) {
            flagStateMyProfile = TRUE;
            flagCountryMyProfile = FALSE;
            [self callWebServiceState];
        }else{
            [self showAlertViewWithMessage:@"Please select country" withTitle:@"Error"];
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
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceState {
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetStates";
    NSString* soapAction = @"http://tempuri.org/GetStates";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringCountryIdMyProfile,@"countryid",@"",@"regionid", nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

- (IBAction)buttonActionLogin:(id)sender {
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
    } else{
        
        [textfieldUsername resignFirstResponder];
        [textfieldPassword resignFirstResponder];
        [self loginAction];
    }
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertLogin) {
        // Login button
        if (buttonIndex==1) {
            [self loginAction];
        }
        // Register now button
        if (buttonIndex == 2) {
            [self forgotPassword];
        }
    }
}

-(void)forgotPassword{
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
        
        if ([textfieldUsername text]>0) {
            if ([self NSStringIsValidEmail:[textfieldUsername text]]==TRUE) {
                flagForgotPasswordMyProfile = TRUE;
                jsonParser2 = [APParser sharedParser];
                jsonParser2.delegate = self;
                [self.tabBarController.view setUserInteractionEnabled:NO ];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.delegate = self;
                HUD.labelText = @"Loading";
                [HUD show:YES];
                
                NSString* methodName = @"ForgotPassword";
                NSString* soapAction = @"http://tempuri.org/ForgotPassword";
                
                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[textfieldUsername text],@"email",nil];
                
                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                
                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
            }else {
                [self showAlertViewWithMessage:@"Please enter valid email id" withTitle:@"Error"];
            }
        }else {
            [self showAlertViewWithMessage:@"Please enter email id" withTitle:@"Error"];
        }
    }
}

- (IBAction)buttonActionCreateProfileOnView:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.stringApplyWhileCreating = @"OnlyCreating";
    appDelegate.stringATSJob = @"";
    
    [self performSegueWithIdentifier:@"SegueCreateProfileMyProfiles" sender:self];
}

- (IBAction)buttonActionForgotPassword:(id)sender {
    [self forgotPassword];
}

-(void)loginAction{
    
    NSString *stringTextFieldUserName = [textfieldUsername text];
    stringTextFieldUserName = [stringTextFieldUserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    stringTextFieldUserName = [stringTextFieldUserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray* words = [stringTextFieldUserName componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    stringTextFieldUserName = [words componentsJoinedByString:@""];
    
    if ([stringTextFieldUserName length]!=0) {
        
        BOOL *valideEmailString = [self NSStringIsValidEmail:stringTextFieldUserName];
        
        if (valideEmailString == NO) {
            alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertPromt show];
        }else {
            NSString *rawString = [textfieldUsername text];
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSRange range = [rawString rangeOfCharacterFromSet:whitespace];
            if (range.location != NSNotFound) {
                //NSLog(@"white space is there...");
                alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertPromt show];
            }else{
                //Call Web service here
                if ([[textfieldPassword text] length]==0) {
                    alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertPromt show];
                }else{
                    flagLoginMyProfileView = TRUE;
                    jsonParser3 = [APParser sharedParser];
                    jsonParser3.delegate = self;
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.delegate = self;
                    HUD.labelText = @"Loading";
                    [HUD show:YES];
                    NSString* methodName = @"ValidateLogin";
                    NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[textfieldUsername text],@"userName",[textfieldPassword text],@"password", nil];
                    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                    
                    [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
                }
            }
        }
    }else {
        alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertPromt show];
    }
}

@end
