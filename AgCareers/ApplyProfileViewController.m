//
//  ApplyProfileViewController.m
//  AgCareers
//
//  Created by Unicorn on 03/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "ApplyProfileViewController.h"
#import "ApplyDetailsViewController.h"
@interface ApplyProfileViewController ()

@end

@implementation ApplyProfileViewController

@synthesize buttonNext;
@synthesize scrollViewCreateProfile;
@synthesize textFieldFirstName,textFieldLastName,textFieldAddress1,textFieldAddress2,textFieldState,textFieldCountry,textFieldEmail,textFieldEmailConfirm,textFieldPassword,textFieldPasswordConfirm;
@synthesize pickerParentView,myPicker,buttonDone;
@synthesize viewPassword;
@synthesize applyCondition;

@synthesize stringJobTitleProfile,stringJobIdProfile;
@synthesize stringEmailId;
BOOL flagCountryApplyProfile = FALSE;
BOOL flagStateApplyProfile = FALSE;
BOOL flagApplyUpdate = FALSE;

NSString *stringCountryIdApplyProfile = @"";
NSString *stringStateIdApplyProfile = @"";
BOOL flagLoginApplyProfileView = FALSE;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    flagCountryApplyProfile = FALSE;
    flagStateApplyProfile = FALSE;
    flagApplyUpdate = FALSE;
    flagLoginApplyProfileView = FALSE;
    
    dictionaryState = [[NSMutableDictionary alloc]init];
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
    
    if ([applyCondition isEqualToString:@"ApplyWithLogin"]) {
        viewPassword.hidden = YES;
        
        [self callMyProfileWebService];
    }
    if ([applyCondition isEqualToString:@"ApplyWithOutLogin"]) {
        viewPassword.hidden = YES;
    }
    [textFieldEmail setText:stringEmailId];
    [textFieldEmailConfirm setText:stringEmailId];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        
    }else{
        if ([applyCondition isEqualToString:@"ApplyWithOutLogin"]) {
            
        }else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        //[scrollViewCreateProfile setContentSize:CGSizeMake(300, 850)];
    }else{
        //[scrollViewCreateProfile setContentSize:CGSizeMake(300, 850)];
    }
}

#pragma mark Call web service
-(void)callMyProfileWebService {
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueMyPfofileNextView"]) {
        
    }
    if ([segue.identifier isEqualToString:@"logonSegueFromMyProfile"]) {
        
    }
    if ([segue.identifier isEqualToString:@"SegueApplyDetails"]) {
        ApplyDetailsViewController *applyDetailsViewController =[segue destinationViewController];
        applyDetailsViewController.applyConditionDetails = applyCondition;
    }
}

#pragma mark Country selection delegate method
-(void)sendCountryDictionary : (NSMutableDictionary *) dictionaryCountry {
    [textFieldCountry setText:[[dictionaryCountry objectForKey:@"arrayTypeName"]objectAtIndex:0]];
    stringCountryIdApplyProfile = [[dictionaryCountry objectForKey:@"arrayTypeIds"]objectAtIndex:0];
    stringStateIdApplyProfile = @"";
    [textFieldState setText:@""];
}

#pragma mark Edit Careers Types delegate method
-(void)sendStatesDictionary : (NSMutableDictionary *) dictionaryStates {
    NSString *stringNew = [[dictionaryStates objectForKey:@"arrayTypeName"] componentsJoinedByString:@","];
    dictionaryState = dictionaryStates;
    stringStateIdApplyProfile = [[dictionaryState objectForKey:@"arrayTypeIds"] componentsJoinedByString:@","];
    [textFieldState setText:stringNew];
}


#pragma mark TextField delegate method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 50;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
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
        flagStateApplyProfile = FALSE;
        flagCountryApplyProfile = FALSE;
        
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

                                                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                               textFieldEmail.text,@"email",
                                                                               textFieldFirstName.text,@"firstname",
                                                                               textFieldLastName.text,@"lastname",
                                                                               textFieldAddress1.text,@"address",
                                                                               textFieldAddress2.text,@"address2",
                                                                               @"",@"city",
                                                                               stringStateIdApplyProfile,@"stateid",
                                                                               stringCountryIdApplyProfile,@"countryid",
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
                                                                               stringJobIdProfile,@"JobId",
                                                                               nil];
                                                
                                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                                appDelegate.applyProfileDictionary = parameterDict;
                                                
                                                [self performSegueWithIdentifier:@"SegueApplyDetails" sender:self];
                                            }else{
                                                [self showAlertViewWithMessage:@"Please enter valid email address" withTitle:@"Error"];
                                            }
                                        }else{
                                            [self showAlertViewWithMessage:@"This value should be the same as Email Field" withTitle:@"Error"];
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
        flagStateApplyProfile = FALSE;
        flagCountryApplyProfile = FALSE;
        
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
                                                //flagApplyUpdate = TRUE;
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
                                                                               stringStateIdApplyProfile,@"stateid",
                                                                               stringCountryIdApplyProfile,@"countryid",
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
                                            [self showAlertViewWithMessage:@"Email addresses does not match. Please check." withTitle:@"Error"];
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
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    
    if (flagCountryApplyProfile == TRUE) {
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
    }else if (flagStateApplyProfile == TRUE){
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        if ([arrayPickerData count]==0) {
            [textFieldState setText:@"None"];
            stringStateIdApplyProfile = @"0";
            pickerParentView.hidden = YES;
            flagStateApplyProfile = FALSE;
        }else{
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        }
        
    }else if (flagApplyUpdate == TRUE){
        flagApplyUpdate = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [self showAlertViewWithMessage:@"Your profile has been updated successfully" withTitle:@"Success."];
        }else{
            [self showAlertViewWithMessage:@"There is some error updating your profile. Please try again later." withTitle:@"Error"];
        }
    }else if (flagLoginApplyProfileView == TRUE){
        [HUD hide:YES];
        flagLoginApplyProfileView = FALSE;
        NSError *error;
        NSDictionary *JSONDict11 =
        [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &error];
        if ([[[JSONDict11 valueForKey:@"ErrorFlag"]objectAtIndex:0] isEqualToString:@"Success"]==TRUE) {
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict11 valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict11 valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict11 valueForKey:@"Email"]objectAtIndex:0] forKey:@"UserEmail"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            
            [self callMyProfileWebService];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered an incorrect username/password and/or you are not approved to use the site.If you continue to have problems, please contact agcareers@agcareers.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        
        if ([[responseDict objectForKey:@"Message"]isEqualToString:@"There was an error processing the request."]) {
            
        }else{
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            textFieldFirstName.text = [JSONDict objectForKey:@"FirstName"];
            textFieldLastName.text = [JSONDict objectForKey:@"LastName"];
            textFieldAddress1.text = [JSONDict objectForKey:@"Address"];
            textFieldAddress2.text = @"";[JSONDict objectForKey:@"LastName"];
            textFieldEmail.text = [JSONDict objectForKey:@"Email"];
            textFieldEmailConfirm.text = [JSONDict objectForKey:@"Email"];
            textFieldCountry.text = [JSONDict objectForKey:@"CountryName"];
            stringCountryIdApplyProfile = [JSONDict objectForKey:@"CountryID"];
            textFieldState.text = [JSONDict objectForKey:@"StateName"];
            stringStateIdApplyProfile = [JSONDict objectForKey:@"StateID"];
        }
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
    
    if(CGRectContainsPoint(selectorFrame, touchPoint)) {
        
        if (flagCountryApplyProfile == TRUE) {
            
            flagCountryApplyProfile = FALSE;
            [textFieldCountry setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringCountryIdApplyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            [textFieldState setText:@""];
            stringStateIdApplyProfile = @"0";
            NSLog(@"stringCountryIdCreateProfile :%@",stringCountryIdApplyProfile);
            pickerParentView.hidden = YES;
        }
        if (flagStateApplyProfile == TRUE) {
            flagStateApplyProfile = FALSE;
            [textFieldState setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringStateIdApplyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringStateIdCreateProfile :%@",stringStateIdApplyProfile);
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
    [textFieldFirstName resignFirstResponder];
    [textFieldLastName resignFirstResponder];
    [textFieldAddress1 resignFirstResponder];
    [textFieldAddress2 resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textFieldEmailConfirm resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldPasswordConfirm resignFirstResponder];
    
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
        flagCountryApplyProfile = TRUE;
        flagStateApplyProfile = FALSE;
        [self callWebServiceCountry];
    }
}

- (IBAction)buttonActionState:(id)sender {
    [textFieldFirstName resignFirstResponder];
    [textFieldLastName resignFirstResponder];
    [textFieldAddress1 resignFirstResponder];
    [textFieldAddress2 resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textFieldEmailConfirm resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldPasswordConfirm resignFirstResponder];
    
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
            flagStateApplyProfile = TRUE;
            flagCountryApplyProfile = FALSE;
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
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringCountryIdApplyProfile,@"countryid",@"",@"regionid", nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

// To disable Copy Paste options
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
//    }];
//    return [super canPerformAction:action withSender:sender];
//}

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
    }
    else{
        alertLogin =[[UIAlertView alloc ] initWithTitle:@"Login" message:@"Enter Username & Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        alertLogin.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alertLogin addButtonWithTitle:@"Login"];
        [alertLogin addButtonWithTitle:@"Register now"];
        [alertLogin show];
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
            [self performSegueWithIdentifier:@"SegueRegisterNowMyProfile" sender:self];
        }
    }
}

-(void)loginAction{
    
    NSString *stringTextFieldUserName = [[alertLogin textFieldAtIndex:0] text];
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
            NSString *rawString = [[alertLogin textFieldAtIndex:0] text];
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSRange range = [rawString rangeOfCharacterFromSet:whitespace];
            if (range.location != NSNotFound) {
                alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertPromt show];
            }else{
                //Call Web service here
                if ([[[alertLogin textFieldAtIndex:1] text] length]==0) {
                    alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertPromt show];
                }else{
                    flagLoginApplyProfileView = TRUE;
                    jsonParser3 = [APParser sharedParser];
                    jsonParser3.delegate = self;
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.delegate = self;
                    HUD.labelText = @"Loading";
                    [HUD show:YES];
                    NSString* methodName = @"ValidateLogin";
                    NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[alertLogin textFieldAtIndex:0] text],@"userName",[[alertLogin textFieldAtIndex:1] text],@"password", nil];
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
