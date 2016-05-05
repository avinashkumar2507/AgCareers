//
//  CreateProfileViewController.m
//  AgCareers
//
//  Created by Unicorn on 04/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "CreateProfileViewController.h"
#import "EditIndustrySectorViewController.h" // Select states
#import "CountrySelectionViewController.h"
#import "CreateProfileSecondViewController.h"
#import <Google/Analytics.h>
@interface CreateProfileViewController ()

@end

@implementation CreateProfileViewController



@synthesize buttonNext;
@synthesize scrollViewCreateProfile;
@synthesize textFieldFirstName,textFieldLastName,textFieldAddress1,textFieldAddress2,textFieldState,textFieldCountry,textFieldEmail,textFieldEmailConfirm,textFieldPassword,textFieldPasswordConfirm;
@synthesize pickerParentView,myPicker,buttonDone;

@synthesize stringEmailIDCreateProfile;

BOOL flagCountryCreateProfile = FALSE;
BOOL flagStateCreateProfile = FALSE;

-(void)viewWillAppear:(BOOL)animated{
    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Create Profile One Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    //    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
    //
    //    }else{
    ////        NSArray * controllerArray = [[self navigationController] viewControllers];
    ////
    ////        for (UIViewController *controller in controllerArray){
    ////            //Code here.. e.g. print their titles to see the array setup;
    ////            NSLog(@"%@",controller.title);
    ////        }
    ////
    ////        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    //    }
    //
    //
    //    NSArray * controllerArray = [[self navigationController] viewControllers];
    //
    //    for (UIViewController *controller in controllerArray){
    //        //Code here.. e.g. print their titles to see the array setup;
    //        NSLog(@"%@",controller.title);
    //    }
}

//-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if ([viewController isKindOfClass:[UINavigationController class]])
//    {
//        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dictionaryState = [[NSMutableDictionary alloc]init];
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
    
    [textFieldEmailConfirm setText:stringEmailIDCreateProfile];
    [textFieldEmail setText:stringEmailIDCreateProfile];
}

-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [scrollViewCreateProfile setContentSize:CGSizeMake(300, 850)];
    }else{
        [scrollViewCreateProfile setContentSize:CGSizeMake(300, 850)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark tableview delegate methods
 //- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0){
 //
 //}
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return 8;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 55;
 }
 
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *CellID = @"Cell111";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 if(indexPath.row==0){
 static NSString *CellID = @"Cell111";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UITextField *textFieldFirstName = (UITextField *)[cell viewWithTag:4211];
 UITextField *textFieldLastName = (UITextField *)[cell viewWithTag:4221];
 //textFieldFirstName.text = [JSONDict objectForKey:@"FirstName"];
 //textFieldLastName.text = [JSONDict objectForKey:@"LastName"];
 return cell;
 }
 if(indexPath.row==1){
 static NSString *CellID = @"Cell121";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UITextField *textFieldEmail = (UITextField *)[cell viewWithTag:4231];
 //textFieldEmail.text = [JSONDict objectForKey:@"Email"];
 return cell;
 }
 if(indexPath.row==2){
 static NSString *CellID = @"Cell131";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UITextField *textFieldFirstName = (UITextField *)[cell viewWithTag:4241];
 UITextField *textFieldLastName = (UITextField *)[cell viewWithTag:4251];
 //labelTitle.text = [JSONDict objectForKey:@"Experience"];
 return cell;
 }
 if(indexPath.row==3){
 static NSString *CellID = @"Cell141";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UILabel *labelTitle = (UILabel *)[cell viewWithTag:4261];
 //labelTitle.text = [JSONDict objectForKey:@"MinEducation"];
 return cell;
 }
 if(indexPath.row==4){
 static NSString *CellID = @"Cell151";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UILabel *labelTitle = (UILabel *)[cell viewWithTag:4271];
 //labelTitle.text = [JSONDict objectForKey:@"MaxEducation"];
 return cell;
 }
 if(indexPath.row==5){
 static NSString *CellID = @"Cell161";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UILabel *labelTitle = (UILabel *)[cell viewWithTag:4281];
 //labelTitle.text = [JSONDict objectForKey:@"Occupation"];
 return cell;
 }
 if(indexPath.row==6){
 
 static NSString *CellID = @"Cell171";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UILabel *labelTitle = (UILabel *)[cell viewWithTag:4291];
 //            labelTitle.text = [JSONDict objectForKey:@"Experience"];
 
 return cell;
 }
 if(indexPath.row==7){
 
 static NSString *CellID = @"Cell181";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
 UILabel *labelTitle = (UILabel *)[cell viewWithTag:4301];
 //            labelTitle.text = [JSONDict objectForKey:@"Experience"];
 
 return cell;
 }
 else {
 return cell;
 }
 }
 
 - (BOOL)textFieldShouldReturn:(UITextField *)textField{
 [tableViewMyProfile endEditing:YES];
 return YES;
 }
 */

NSString *stringCountryIdCreateProfile = @"";
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueCountryFromCreate"]) {
        CountrySelectionViewController *countrySelectionViewController = [segue destinationViewController];
        countrySelectionViewController.delegateCountry = self;
    }
    if ([segue.identifier isEqualToString:@"SegueStatesFromCreate"]) {
        EditIndustrySectorViewController *editIndustrySectorViewController = [segue destinationViewController];
        editIndustrySectorViewController.stringCountryId = stringCountryIdCreateProfile;
        editIndustrySectorViewController.stringRegionId = @"";
        editIndustrySectorViewController.delegateStates = self;
    }
    if ([segue.identifier isEqualToString:@"SegueCreateProfileNext"]) {
        CreateProfileSecondViewController *createProfileSecondViewController = [segue destinationViewController];
        createProfileSecondViewController.strMemId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"];
    }
}

#pragma mark Country selection delegate method
-(void)sendCountryDictionary : (NSMutableDictionary *) dictionaryCountry {
    [textFieldCountry setText:[[dictionaryCountry objectForKey:@"arrayTypeName"]objectAtIndex:0]];
    stringCountryIdCreateProfile = [[dictionaryCountry objectForKey:@"arrayTypeIds"]objectAtIndex:0];
    stringStateIdCreateProfile = @"";
    [textFieldState setText:@""];
}
NSString *stringStateIdCreateProfile = @"";
#pragma mark Edit Careers Types delegate method
-(void)sendStatesDictionary : (NSMutableDictionary *) dictionaryStates {
    NSString *stringNew = [[dictionaryStates objectForKey:@"arrayTypeName"] componentsJoinedByString:@","];
    dictionaryState = dictionaryStates;
    stringStateIdCreateProfile = [[dictionaryState objectForKey:@"arrayTypeIds"] componentsJoinedByString:@","];
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
-(void)showAlertViewWithMessage :(NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:@"Error" message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        flagStateCreateProfile = FALSE;
        flagCountryCreateProfile = FALSE;
        //[self performSegueWithIdentifier:@"SegueCreateProfileNext" sender:self];
        
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
                                                if ([textFieldPassword.text length]>0) {
                                                    
                                                    if ([textFieldPasswordConfirm.text length]>0) {
                                                        if ([textFieldPassword.text isEqualToString:textFieldPasswordConfirm.text]) {
                                                            if ([self strongPassword:textFieldPassword.text]==TRUE) {
                                                                //Final
                                                                // SegueCreateProfileNext
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
                                                                                               textFieldEmail.text,@"email",                ///////
                                                                                               textFieldFirstName.text,@"firstname",        ///////
                                                                                               textFieldLastName.text,@"lastname",          ///////
                                                                                               textFieldAddress1.text,@"address",           ///////
                                                                                               textFieldAddress2.text,@"address2",          ///////
                                                                                               @"",@"city",
                                                                                               stringStateIdCreateProfile,@"stateid",       ///////
                                                                                               stringCountryIdCreateProfile,@"countryid",   ///////
                                                                                               @"",@"postalcode",
                                                                                               @"",@"PhoneWork",
                                                                                               @"",@"CellPhone",
                                                                                               @"",@"fax",
                                                                                               @"",@"website",
                                                                                               textFieldPassword.text,@"password",          ///////
                                                                                               @"",@"password_old",
                                                                                               @"1",@"TypeID",
                                                                                               @"",@"referredby",
                                                                                               @"",@"CurrSalary",
                                                                                               @"",@"EduInfo",
                                                                                               @"TRUE",@"approved",
                                                                                               @"0",@"MemberID",
                                                                                               nil];
                                                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                                                appDelegate.applyProfileDictionary = parameterDict;
                                                                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                                                                
                                                                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                                                                [jsonParser parseSoapWithJSONSoapContents:dictToSend];
                                                            }else {
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                message:@"Password must be at least 8 characters and contain 1 number as well as 1 upper and 1 lowercase letter."
                                                                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                                [alert show];
                                                            }
                                                            
                                                        }else{
                                                            [self showAlertViewWithMessage:@"This value should be the same as Password Field"];
                                                        }
                                                    }else{
                                                        //Confirm password
                                                        [self showAlertViewWithMessage:@"Please re-enter password in confirm password"];
                                                    }
                                                }else{
                                                    //Password
                                                    [self showAlertViewWithMessage:@"Please enter password"];
                                                }
                                            }else{
                                                [self showAlertViewWithMessage:@"Please enter valid email address"];
                                            }
                                        }else{
                                            [self showAlertViewWithMessage:@"This value should be the same as Email Field"];
                                        }
                                    }
                                    
                                }else{
                                    //Confirm email
                                    [self showAlertViewWithMessage:@"Please re-enter email in confirm email"];
                                }
                            }else{
                                //Email
                                [self showAlertViewWithMessage:@"Please enter email"];
                            }
                        }else{
                            //State
                            [self showAlertViewWithMessage:@"Please select states"];
                        }
                    }else{
                        //Country
                        [self showAlertViewWithMessage:@"Please select country"];
                    }
                }else{
                    //Address 1
                    [self showAlertViewWithMessage:@"Please enter address"];
                }
            }else{
                //Last name
                [self showAlertViewWithMessage:@"Please enter last name"];
            }
        }else{
            //First name
            [self showAlertViewWithMessage:@"Please enter first name"];
        }
    }
}

-(void)hideHUDandWebservice {
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    //[[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    
    if (flagCountryCreateProfile == TRUE) {
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        pickerParentView.hidden = NO;
        [myPicker reloadAllComponents];
        
        
    }else if (flagStateCreateProfile == TRUE){
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayPickerData = [JSONDict valueForKey:@"Rows"];
        if ([arrayPickerData count]==0) {
            [textFieldState setText:@"None"];
            stringStateIdCreateProfile = @"0";
            pickerParentView.hidden = YES;
            flagStateCreateProfile = FALSE;
        }else{
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        }
    }else{
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            
            if ([[JSONDict valueForKey:@"ErrorMsg"]isEqualToString:@"User name and email already exists."]==TRUE) {
                [self showAlertViewWithMessage:@"Email is already in use"];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:@"Success" forKey:@"SuceessStatus"];
                [[NSUserDefaults standardUserDefaults]setObject:[JSONDict valueForKey:@"ID"] forKey:@"UserId"];
                [[NSUserDefaults standardUserDefaults]setObject:textFieldEmail.text forKey:@"UserEmail"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self performSegueWithIdentifier:@"SegueCreateProfileNext" sender:self];
            }
        }else {
            [self showAlertViewWithMessage:[JSONDict valueForKey:@"ErrorMsg"]];
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
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagCountryCreateProfile == TRUE) {
            
            flagCountryCreateProfile = FALSE;
            [textFieldCountry setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringCountryIdCreateProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            
            [textFieldState setText:@""];
            stringStateIdCreateProfile = @"0";
            NSLog(@"stringCountryIdCreateProfile :%@",stringCountryIdCreateProfile);
            pickerParentView.hidden = YES;
        }
        if (flagStateCreateProfile == TRUE) {
            flagStateCreateProfile = FALSE;
            [textFieldState setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringStateIdCreateProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringStateIdCreateProfile :%@",stringStateIdCreateProfile);
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

// To disable Copy Paste options
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
//    }];
//    return [super canPerformAction:action withSender:sender];
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UITableViewCell *cell = (UITableViewCell *)view;
//
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell setBounds: CGRectMake(0, 0, cell.frame.size.width -20 , 44)];
//        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSelection:)];
//        singleTapGestureRecognizer.numberOfTapsRequired = 1;
//        [cell addGestureRecognizer:singleTapGestureRecognizer];
//    }
//
//    if ([selectedItems indexOfObject:[NSNumber numberWithInt:row]] != NSNotFound) {
//        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//    } else {
//        [cell setAccessoryType:UITableViewCellAccessoryNone];
//    }
//    cell.textLabel.text = [[arrayPickerData objectAtIndex:row]valueForKey:@"Name"];
//    cell.tag = row;
//
//    return cell;
//}
//
//- (void)toggleSelection:(UITapGestureRecognizer *)recognizer {
//    NSNumber *row = [NSNumber numberWithInt:recognizer.view.tag];
//    NSUInteger index = [selectedItems indexOfObject:row];
//    if (index != NSNotFound) {
//        [selectedItems removeObjectAtIndex:index];
//        [(UITableViewCell *)(recognizer.view) setAccessoryType:UITableViewCellAccessoryNone];
//    } else {
//        [selectedItems addObject:row];
//        [(UITableViewCell *)(recognizer.view) setAccessoryType:UITableViewCellAccessoryCheckmark];
//    }
//}

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
        flagCountryCreateProfile = TRUE;
        flagStateCreateProfile = FALSE;
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
            flagStateCreateProfile = TRUE;
            flagCountryCreateProfile = FALSE;
            [self callWebServiceState];
            
        }else{
            [self showAlertViewWithMessage:@"Please select country"];
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
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringCountryIdCreateProfile,@"countryid",@"",@"regionid", nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

- (BOOL)strongPassword:(NSString *)yourText {
    BOOL strongPwd = YES;
    
    //Checking length
    if([yourText length] < 8)
        strongPwd = NO;
    
    //Checking uppercase characters
    NSCharacterSet *charSet = [NSCharacterSet uppercaseLetterCharacterSet];
    NSRange range = [yourText rangeOfCharacterFromSet:charSet];
    if(range.location == NSNotFound)
        strongPwd = NO;
    
    //Checking lowercase characters
    charSet = [NSCharacterSet lowercaseLetterCharacterSet];
    range = [yourText rangeOfCharacterFromSet:charSet];
    if(range.location == NSNotFound)
        strongPwd = NO;
    
    //Checking special characters
    charSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    range = [yourText rangeOfCharacterFromSet:charSet];
    if(range.location == NSNotFound)
        strongPwd = NO;
    
    return strongPwd;
}


@end
