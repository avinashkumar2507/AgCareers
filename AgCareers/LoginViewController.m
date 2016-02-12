//
//  LoginViewController.m
//  AgCareers
//
//  Created by Unicorn on 14/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize textFieldPassword,textFieldUsername;
- (void)viewDidLoad {
    [super viewDidLoad];
    jsonParser = [Parser sharedParser];
    jsonParser.delegate = self;
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict{
    [HUD hide:YES];
    
    NSError *error;
    NSDictionary *JSONDict =
    [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    
    NSLog(@">>>%@",[[JSONDict valueForKey:@"ErrorFlag"]objectAtIndex:0]);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.loginCheck      = YES;
    [appDelegate.loginDetails setObject:[[JSONDict valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
    [appDelegate.loginDetails setObject:[[JSONDict valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
    [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
    
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {//CreateMemberSegue
    if ([segue.identifier isEqualToString:@"SegueCreateFromLoginSetting"]) {
        
    }
}

#pragma mark - Keyboard animation
- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textFieldPassword resignFirstResponder];
    [textFieldUsername resignFirstResponder];
    return YES;
}

-(void)viewDidLayoutSubviews{
    
    if (IDIOM==IPAD) {
        
    } else{
        if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:@"UIKeyboardWillShowNotification"
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardDidHide:)
                                                         name:@"UIKeyboardDidHideNotification"
                                                       object:nil];
            
        } else{
            
        }
    }
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
        //    if ([textFieldUsername.text isEqualToString:@"avinash@farms.com"]&&[textFieldPassword.text isEqualToString:@"test1234"]) {
        //        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        //        appDelegate.loginCheck      = YES;
        //        //[appDelegate.loginDetails setObject:[[JSONDict valueForKey:@"Login"]valueForKey:@"DealerName"] forKey:@"DealerName"];
        //        [appDelegate.loginDetails setObject:@"AvinashKumar" forKey:@"UserName"];
        //        [appDelegate.loginDetails setObject:@"4321" forKey:@"UserId"];
        //        [[NSUserDefaults standardUserDefaults]setObject:@"AvinashKumar" forKey:@"UserNameStandardDefault"];
        //        [[NSUserDefaults standardUserDefaults]setObject:@"4321" forKey:@"UserIdStandardDefault"];
        //        [self dismissViewControllerAnimated:YES completion:NULL];
        //    }else{
        //
        //    }
        
        NSString *stringTextFieldUserName = textFieldUsername.text;
        stringTextFieldUserName = [stringTextFieldUserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        stringTextFieldUserName = [stringTextFieldUserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSArray* words = [stringTextFieldUserName componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
        stringTextFieldUserName = [words componentsJoinedByString:@""];
        
        if ([stringTextFieldUserName length]!=0) {
            
            BOOL *valideEmailString = [self NSStringIsValidEmail:stringTextFieldUserName];
            
            if (valideEmailString == NO) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSString *rawString = [textFieldUsername text];
                NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSRange range = [rawString rangeOfCharacterFromSet:whitespace];
                if (range.location != NSNotFound) {
                    //NSLog(@"white space is there...");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    //Call Web service here
                    if ([textFieldPassword.text length]==0) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }else{
                        
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        HUD.delegate = self;
                        HUD.labelText = @"Loading";
                        [HUD show:YES];
                        [self.view setUserInteractionEnabled:NO];
                        NSString* methodName = @"ValidateLogin";
                        NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFieldUsername.text,@"userName",textFieldPassword.text,@"password", nil];
                        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                        [jsonParser parseSoapWithJSONSoapContents:dictToSend];
                    }
                }
            }
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

- (IBAction)buttonActionBack:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboardId"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:NO completion:NULL];
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

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (IBAction)ButtonActionCreateMember:(id)sender {
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
        [self performSegueWithIdentifier:@"SegueCreateFromLoginSetting" sender:self];
    }
}
@end
