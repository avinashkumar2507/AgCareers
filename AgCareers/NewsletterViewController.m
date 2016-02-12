//
//  NewsletterViewController.m
//  AgCareers
//
//  Created by Unicorn on 06/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "NewsletterViewController.h"

@interface NewsletterViewController ()

@end

@implementation NewsletterViewController
@synthesize buttonCountry,buttonSubmit,textFeildEmailAddress,textFieldCountry,pickerCountry;

NSString *stringSelectedCountry = @"";
BOOL flagSubmit = FALSE;
BOOL flagSelectCoutry = FALSE;
- (void)viewDidLoad {
    [super viewDidLoad];
    flagSelectCoutry = FALSE;
    //    UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
    //    downArrow.frame = CGRectMake(0.0, 0.0, downArrow.image.size.width+10.0, downArrow.image.size.height);
    //    downArrow.contentMode = UIViewContentModeCenter;
    //    textFieldCountry.rightView = downArrow;
    //    textFieldCountry.rightViewMode = UITextFieldViewModeAlways;
    
    [textFeildEmailAddress setText:[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]];
    
    pickerCountry.hidden = YES;
    
    //arrayPickerData = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6"];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [pickerCountry addGestureRecognizer:singleFingerTap];
    
    // Keyboard animation
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
    
    
    
    
    [self callWebService];
}

-(void)callWebService {
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

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    
    if (flagSubmit == TRUE) {
        flagSubmit = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];//ErrorMsg
        
        if ([[JSONDict objectForKey:@"Success"]intValue]==1) {
            
            if ([[JSONDict valueForKey:@"ID"]intValue]==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Email already subscribed"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                //[self showAlertViewWithMessage:@"Email already subscribed" withTitle:@"Error"];
            }else {
                [self showAlertViewWithMessage:@"Subscribed Successfully" withTitle:@"Success"];
            }
        }else {
            [self showAlertViewWithMessage:@"Some error occured. Please try again" withTitle:@"Error"];
        }
    }else{
        
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];//ErrorMsg
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        [pickerCountry reloadAllComponents];
    }
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

#pragma mark alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(alertView == alertForCheck){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)buttonActionSubmit:(id)sender {
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
        pickerCountry.hidden = YES;
        
        NSString *stringTextFieldUserName = textFeildEmailAddress.text;
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
                NSString *rawString = [textFeildEmailAddress text];
                NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSRange range = [rawString rangeOfCharacterFromSet:whitespace];
                if (range.location != NSNotFound) {
                    //NSLog(@"white space is there...");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    //Call Web service here
                    if (flagSelectCoutry==FALSE) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select country" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }else{
                        flagSubmit = TRUE;
//                        jsonParser1 = [APParser sharedParser];
//                        jsonParser1.delegate = self;
//                        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//                        [self.view addSubview:HUD];
//                        HUD.delegate = self;
//                        HUD.labelText = @"Loading";
//                        [HUD show:YES];
//                        [self.view setUserInteractionEnabled:NO];
//                        NSString* methodName = @"SubscribeNewsLetter";
//                        NSString* soapAction = @"http://tempuri.org/SubscribeNewsLetter";
//                        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFeildEmailAddress.text,@"email",
//                                                       stringSelectedCountry,@"CountryID",
//                                                       @"A",@"subscribetype",
//                                                       @"true",@"subscribe",
//                                                       nil];
//                        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
//                        
//                        [jsonParser1 parseSoapWithJSONSoapContents:dictToSend];
                        
                        
                        
                        
                        jsonParser = [APParser sharedParser];
                        jsonParser.delegate = self;
                        [self.tabBarController.view setUserInteractionEnabled:NO ];
                        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        HUD.delegate = self;
                        HUD.labelText = @"Loading";
                        [HUD show:YES];
                        
                        NSString* methodName = @"SubscribeNewsLetter";
                        NSString* soapAction = @"http://tempuri.org/SubscribeNewsLetter";
                        
                        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFeildEmailAddress.text,@"email",
                                                       stringSelectedCountry,@"CountryID",
                                                       @"A",@"subscribetype",
                                                       @"true",@"subscribe",
                                                       nil];
                        
                        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                        
                        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                        [jsonParser parseSoapWithJSONSoapContents:dictToSend];
                        
                    }
                }
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
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
        [textFeildEmailAddress resignFirstResponder];
        pickerCountry.hidden = NO;
    }
}

#pragma mark Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textFeildEmailAddress resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == textFeildEmailAddress){
        pickerCountry.hidden = YES;
    }
    return YES;
}

#pragma mark PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrayPickerData count] ;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //return arrayPickerData[row];
    return [[arrayPickerData objectAtIndex:row]valueForKey:@"Name"];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = pickerCountry.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, pickerCountry.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        //NSLog( @"Selected Row: %@", [arrayPickerData objectAtIndex:[pickerCountry selectedRowInComponent:0]] );
        [textFieldCountry setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[pickerCountry selectedRowInComponent:0]]];
        
        //NSLog(@"Selected id : %@",[[arrayPickerData valueForKey:@"ID"] objectAtIndex:[pickerCountry selectedRowInComponent:0]]);
        
        stringSelectedCountry = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[pickerCountry selectedRowInComponent:0]];
        flagSelectCoutry = TRUE;
        [pickerCountry setHidden:YES];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return true;
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

#pragma mark keyboard animation methods
- (void) keyboardWillShow:(NSNotification *)note {
    
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    frame.origin.y = -70;
    
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

@end
