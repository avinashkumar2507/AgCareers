//
//  ApplyForViewController.m
//  AgCareers
//
//  Created by Unicorn on 03/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "ApplyForViewController.h"
#import "ApplyProfileViewController.h"
#import <Google/Analytics.h>
#import "CreateProfileViewController.h"
@interface ApplyForViewController ()

@end

@implementation ApplyForViewController
@synthesize labelCompanyName,textFieldEmailAddress,textFieldPassword,viewContinue,viewCreateProfile,viewPassword;
@synthesize stringJobId,stringJobTitle;

BOOL flagLoginApply = FALSE;
BOOL flagForgotPasswordApply = FALSE;
BOOL flagCheckAlreadyApplied1 = FALSE;
NSString *stringApplyCondition = @"";
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",stringJobId);
    [labelCompanyName setText:stringJobTitle];
    textFieldEmailAddress.userInteractionEnabled = YES;
    [viewCreateProfile setHidden:YES];
    [viewPassword setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    flagCheckAlreadyApplied1 = FALSE;
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Apply Without Login Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertCommon = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertCommon show];
}

- (IBAction)buttonActionContinue:(id)sender {
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
        if ([textFieldEmailAddress text]>0) {
            if ([self NSStringIsValidEmail:[textFieldEmailAddress text]]==TRUE) {
                
                [textFieldEmailAddress resignFirstResponder];
                
                flagCheckAlreadyApplied1 = TRUE;
                [self callWebServiceAlreadyApplied];
                
            }else {
                [self showAlertViewWithMessage:@"Please enter valid email id" withTitle:@"Error"];
            }
        }else {
            [self showAlertViewWithMessage:@"Please enter email id" withTitle:@"Error"];
        }
    }
}

-(void)callWebServiceCheckEmail{
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"UserExists";
    NSString* soapAction = @"http://tempuri.org/UserExists";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFieldEmailAddress.text,@"email",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
    
}


-(void)callWebServiceAlreadyApplied{
    jsonParser7 = [APParser sharedParser];
    jsonParser7.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"IsJobApplied";
    NSString* soapAction = @"http://tempuri.org/IsJobApplied";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringJobId,@"JobId",@"0",@"memberid",[textFieldEmailAddress text],@"email",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser7 parseSoapWithJSONSoapContents:dictToSend];
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
    }
    else{
        if ([textFieldEmailAddress text]>0) {
            if ([self NSStringIsValidEmail:[textFieldEmailAddress text]]==TRUE) {
                if ([textFieldPassword text]>0) {
                    flagLoginApply = TRUE;
                    jsonParser1 = [APParser sharedParser];
                    jsonParser1.delegate = self;
                    [self.tabBarController.view setUserInteractionEnabled:NO ];
                    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    HUD.delegate = self;
                    HUD.labelText = @"Loading";
                    [HUD show:YES];
                    
                    NSString* methodName = @"ValidateLogin";
                    NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                    
                    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFieldEmailAddress.text,@"userName",
                                                   textFieldPassword.text,@"password",
                                                   nil];
                    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                    
                    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                    [jsonParser1 parseSoapWithJSONSoapContents:dictToSend];
                }else{
                    [self showAlertViewWithMessage:@"Please enter Password" withTitle:@"Error"];
                }
            }else {
                [self showAlertViewWithMessage:@"Please enter valid email id" withTitle:@"Error"];
            }
        }else {
            [self showAlertViewWithMessage:@"Please enter email id" withTitle:@"Error"];
        }
    }
}

- (IBAction)buttonActionForgotPassword:(id)sender {
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
        if ([textFieldEmailAddress text]>0) {
            if ([self NSStringIsValidEmail:[textFieldEmailAddress text]]==TRUE) {
                flagForgotPasswordApply = TRUE;
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
                
                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFieldEmailAddress.text,@"email",nil];
                
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertCommon) {
        
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueApplyProfile"]) {
        ApplyProfileViewController *applyProfileViewController = [segue destinationViewController];
        applyProfileViewController.applyCondition = stringApplyCondition;
        applyProfileViewController.stringJobIdProfile = stringJobId;
        applyProfileViewController.stringJobTitleProfile = stringJobTitle;
        applyProfileViewController.stringEmailId = textFieldEmailAddress.text;
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        appDelegate.stringJobIdCreateProfile = stringJobId;
    }else if ([segue.identifier isEqualToString:@"SegueCreateProfileApply"]){
        CreateProfileViewController *createProfileViewController = [segue destinationViewController];
        createProfileViewController.stringEmailIDCreateProfile = textFieldEmailAddress.text;
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        appDelegate.stringJobIdCreateProfile = stringJobId;
    }else{
        
    }
}

- (IBAction)buttonActionCreateProfile:(id)sender {
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
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.stringApplyWhileCreating = @"ApplyWhileCreating";
        
        [self performSegueWithIdentifier:@"SegueCreateProfileApply" sender:self];
    }
}

- (IBAction)buttonActionWithoutLogin:(id)sender {
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
        stringApplyCondition = @"ApplyWithOutLogin";
        [self performSegueWithIdentifier:@"SegueApplyProfile" sender:self];
    }
}

- (IBAction)buttonActionWithoutCreating:(id)sender {
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
        stringApplyCondition = @"ApplyWithOutLogin";
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.stringApplyWhileCreating = @"ApplyWithOutCreating";
        
        [self performSegueWithIdentifier:@"SegueApplyProfile" sender:self];
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
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    
    if (flagLoginApply == TRUE) {
        flagLoginApply = FALSE;
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        
        if ([[[JSONDict valueForKey:@"ErrorFlag"]objectAtIndex:0] isEqualToString:@"Success"]==TRUE) {
            
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            stringApplyCondition = @"ApplyWithLogin";
            
            [self performSegueWithIdentifier:@"SegueApplyProfile" sender:self];
        }else {
            [self showAlertViewWithMessage:[[JSONDict valueForKey:@"Message"]objectAtIndex:0] withTitle:@"Error"];
        }
    }else if (flagForgotPasswordApply == TRUE){
        flagForgotPasswordApply = FALSE;
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [self showAlertViewWithMessage:@"New password has been sent to your email id." withTitle:@"Success"];
        }else {
            [self showAlertViewWithMessage:@"There is some error. Please try again later." withTitle:@"Error"];
        }
    }else if (flagCheckAlreadyApplied1== TRUE){
        flagCheckAlreadyApplied1 = FALSE;
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict objectForKey:@"Success"] intValue]==1) {
            alertForAlreadyApplied = [[UIAlertView alloc]initWithTitle:@"Error" message:[JSONDict objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertForAlreadyApplied show];
        }else{
            [self callWebServiceCheckEmail];
        }
    }else {
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"ErrorMsg"] isEqualToString:@"User exists."]) {
            textFieldEmailAddress.userInteractionEnabled = NO;
            [viewContinue setHidden:YES];
            [viewCreateProfile setHidden:YES];
            [viewPassword setHidden:NO];
        }else{
            [viewContinue setHidden:YES];
            [viewPassword setHidden:YES];
            [viewCreateProfile setHidden:NO];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textFieldEmailAddress resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    return YES;
}

@end
