//
//  EmployerDetailsViewController.m
//  AgCareers
//
//  Created by Unicorn on 14/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "EmployerDetailsViewController.h"
#import "JobDetailsViewController.h"
#import <Google/Analytics.h>
#import "CreateProfileViewController.h"
#import <Social/Social.h>
@interface EmployerDetailsViewController ()

@end

@implementation EmployerDetailsViewController
@synthesize stringEmployerId,labelDescription,labelEmployerTitle,imageViewLogo,stringEmpTitle,tableViewCurrentJobs,textFieldDescription;

NSString *stringJobIDFromEmployer       = @"";
NSString *stringEmployerName            = @"";
NSString *stringEmployerDescription     = @"";
NSString *stringEmploperJobCount        = @"";
NSString *stringLogoImageURL            = @"";
BOOL flagSaveEmployer                   = FALSE;
BOOL flagLoginEmployerDetails           = FALSE;
BOOL flagForgotPasswordEmpDetails       = FALSE;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _labelCurrentJobsListing.text = @"";
    
    
    imageViewLogo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
    
    backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_ar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonActionBack)];
    
    //NSArray *arrBtns = [[NSArray alloc]initWithObjects:backButton, nil];
    self.navigationItem.leftBarButtonItem = backButton;
    shareBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
    
    saveButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_favourites_add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonActionSaveFabouriteEmployer)];
    
    labelEmployerTitle.text = stringEmpTitle;
    arrayJobsListing = [[NSArray alloc]init];
    
    if (self.tabBarController.selectedIndex ==0) {
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:shareBarButton,saveButton, nil];
        self.navigationItem.rightBarButtonItems = arrBtns;
        
    }
    if (self.tabBarController.selectedIndex ==1) {
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:shareBarButton, nil];
        self.navigationItem.rightBarButtonItems = arrBtns;
    }
    
    if (self.tabBarController.selectedIndex == 1) {
        
    }else{
        jsonParser = [APParser sharedParser];
        jsonParser.delegate = self;
        [self callWebService];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Employer Details Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        
        if (self.tabBarController.selectedIndex == 1) {
            jsonParser = [APParser sharedParser];
            jsonParser.delegate = self;
            [self callWebService];
        }else{
            
        }
    }else {
        //User is not logged in
        if (self.tabBarController.selectedIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:NO completion:NULL];
    }
}

-(void)addToFavourite{
    flagSaveEmployer = TRUE;
    jsonParser1 = [APParser sharedParser];
    jsonParser1.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD1];
    HUD1.delegate = self;
    HUD1.labelText = @"Loading";
    [HUD1 show:YES];
    
    NSString* methodName = @"SaveFavouriteEmployer";
    NSString* soapAction = @"http://tempuri.org/SaveFavouriteEmployer";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"ApplicantID",stringEmployerId,@"EmployerID",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser1 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)buttonActionSaveFabouriteEmployer{
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
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
            [self addToFavourite];
        }else {
            alertLogin =[[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter Username & Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alertLogin.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [alertLogin textFieldAtIndex:0].placeholder = @"Username";
            [alertLogin addButtonWithTitle:@"Login"];
            [alertLogin addButtonWithTitle:@"Forgot Password?"];
            [alertLogin addButtonWithTitle:@"Register now"];
            [alertLogin show];
        }
    }
}
-(void)buttonActionBack{
    
    if ([self.tabBarController selectedIndex]==1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayJobsListing count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.backgroundView.backgroundColor = [UIColor whiteColor];
//    header.textLabel.textColor = [UIColor blackColor];
//    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
//    CGRect headerFrame = header.frame;
//    header.textLabel.frame = headerFrame;
//    header.textLabel.textAlignment = NSTextAlignmentLeft;
//
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Current Jobs Listings";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellEmployers";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    UILabel *labelTitle = (UILabel *)[cell viewWithTag:3691];
    UILabel *labelLocation = (UILabel *)[cell viewWithTag:3692];
    UILabel *labelExpirationDate = (UILabel *)[cell viewWithTag:3693];
    labelTitle.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"JobTitle"];
    labelLocation.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"Location"];
    labelExpirationDate.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"Dateexpire"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    stringJobIDFromEmployer = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"JobID"];
    [self performSegueWithIdentifier:@"SegueToJobDetailsFromEmployer" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SegueToJobDetailsFromEmployer"]) {
        JobDetailsViewController *jobDetailViewController = [segue destinationViewController];
        jobDetailViewController.stringJobId = stringJobIDFromEmployer;
    }
    if ([segue.identifier isEqualToString:@"SegueCreateEpmloyerDetails"]) {
        CreateProfileViewController *createProfileViewController = [segue destinationViewController];
        createProfileViewController.stringEmailIDCreateProfile = @"";
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.stringApplyWhileCreating = @"OnlyCreating";
    }
}

-(void)callWebService {
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetFavouriteEmployerDetails";
    NSString* soapAction = @"http://tempuri.org/GetFavouriteEmployerDetails";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: stringEmployerId,@"EmployerID",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    if (flagSaveEmployer == TRUE) {
        flagSaveEmployer = FALSE;
        [HUD1 hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES ];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:[JSONDict valueForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[JSONDict valueForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if (flagLoginEmployerDetails == TRUE) {
        [HUD hide:YES];
        flagLoginEmployerDetails = FALSE;
        NSError *error;
        NSDictionary *JSONDict12 =
        [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &error];
        if ([[[JSONDict12 valueForKey:@"ErrorFlag"]objectAtIndex:0] isEqualToString:@"Success"]==TRUE) {
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict12 valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict12 valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self addToFavourite];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered an incorrect username/password and/or you are not approved to use the site.If you continue to have problems, please contact agcareers@agcareers.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if (flagForgotPasswordEmpDetails == TRUE){
        flagForgotPasswordEmpDetails = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            [self showAlertViewWithMessage:@"New password has been sent to your email id." withTitle:@"Success"];
        }else {
            [self showAlertViewWithMessage:[JSONDict valueForKey:@"ErrorMsg"] withTitle:@"Error"];
        }
    }else{
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES ];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"EmployerID"] intValue] == 0) {
            _labelCurrentJobsListing.text = @"";
            imageViewLogo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
            alertForNoDetails = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There are no details for this employer" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertForNoDetails show];
        }else {
            
            if ([[JSONDict valueForKey:@"Description"] length]==0) {
                textFieldDescription.text = @"There is no description";
                stringEmployerDescription = @"There is no description";
            }else {
                textFieldDescription.text = [self stringByStrippingHTML:[self decodeHTMLEntities:[JSONDict valueForKey:@"Description"]]];
                stringEmployerDescription = [self stringByStrippingHTML:[self decodeHTMLEntities:[JSONDict valueForKey:@"Description"]]];
            }
            _labelCurrentJobsListing.text = @"Current Jobs Listings";//http://dev.agcareers.farmsstaging.com
//            NSString *stringImageURL = [NSString stringWithFormat:@"http://agcareers-ws.farmsstaging.com/uploads/companyLogos/%@",[[JSONDict valueForKey:@"LogoName"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSString *stringImageURL = [NSString stringWithFormat:@"http://dev.agcareers.farmsstaging.com/uploads/companyLogos/%@",[[JSONDict valueForKey:@"LogoName"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];

            imageViewLogo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:stringImageURL]]];
            arrayJobsListing = [JSONDict valueForKey:@"JobsList"];
            stringLogoImageURL = stringImageURL;
            stringEmployerName = stringEmpTitle;
            stringEmploperJobCount = [NSString stringWithFormat:@"%lu",(unsigned long)[arrayJobsListing count]];
            
            [tableViewCurrentJobs reloadData];
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
        if (alertView == alertForNoDetails) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        if (alertView == alertPromt) {
            [alertLogin show];
        }
        if (alertView == alertLogin) {
            if (buttonIndex==1) {
                [self loginAction];
            }
            if (buttonIndex == 2) {
                [self forgotPassword];
            }
            if (buttonIndex == 3) {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                appDelegate.stringApplyWhileCreating = @"OnlyCreating";
                appDelegate.stringATSJob = @"";

                [self performSegueWithIdentifier:@"SegueCreateEpmloyerDetails" sender:self];
            }
        }
    }
}

-(void)loginAction {
    
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
                //NSLog(@"white space is there...");
                alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertPromt show];
            }else {
                //Call Web service here
                if ([[[alertLogin textFieldAtIndex:1] text] length] == 0) {
                    alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertPromt show];
                }else {
                    flagLoginEmployerDetails = TRUE;
                    jsonParser2 = [APParser sharedParser];
                    jsonParser2.delegate = self;
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.delegate = self;
                    HUD.labelText = @"Loading";
                    [HUD show:YES];
                    NSString* methodName = @"ValidateLogin";
                    NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[alertLogin textFieldAtIndex:0] text],@"userName",[[alertLogin textFieldAtIndex:1] text],@"password", nil];
                    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                    [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
                }
            }
        }
    }else{
        alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertPromt show];
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

// Method to remove HTML tags from string
-(NSString *) stringByStrippingHTML :(NSString *)s {
    NSRange r;
    
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)decodeHTMLEntities:(NSString *)string {
    // Reserved Characters in HTML
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    // ISO 8859-1 Symbols
    string = [string stringByReplacingOccurrencesOfString:@"&iexcl;" withString:@"¡"];
    string = [string stringByReplacingOccurrencesOfString:@"&cent;" withString:@"¢"];
    string = [string stringByReplacingOccurrencesOfString:@"&pound;" withString:@"£"];
    string = [string stringByReplacingOccurrencesOfString:@"&curren;" withString:@"¤"];
    string = [string stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
    string = [string stringByReplacingOccurrencesOfString:@"&brvbar;" withString:@"¦"];
    string = [string stringByReplacingOccurrencesOfString:@"&sect;" withString:@"§"];
    string = [string stringByReplacingOccurrencesOfString:@"&uml;" withString:@"¨"];
    string = [string stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordf;" withString:@"ª"];
    string = [string stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    string = [string stringByReplacingOccurrencesOfString:@"&not;" withString:@"¬"];
    string = [string stringByReplacingOccurrencesOfString:@"&shy;" withString:@"    "];
    string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];
    string = [string stringByReplacingOccurrencesOfString:@"&macr;" withString:@"¯"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&plusmn;" withString:@"±       "];
    string = [string stringByReplacingOccurrencesOfString:@"&sup2;" withString:@"²"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup3;" withString:@"³"];
    string = [string stringByReplacingOccurrencesOfString:@"&acute;" withString:@"´"];
    string = [string stringByReplacingOccurrencesOfString:@"&micro;" withString:@"µ"];
    string = [string stringByReplacingOccurrencesOfString:@"&para;" withString:@"¶"];
    string = [string stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    string = [string stringByReplacingOccurrencesOfString:@"&cedil;" withString:@"¸"];
    string = [string stringByReplacingOccurrencesOfString:@"&sup1;" withString:@"¹"];
    string = [string stringByReplacingOccurrencesOfString:@"&ordm;" withString:@"º"];
    string = [string stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac14;" withString:@"¼"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac12;" withString:@"½"];
    string = [string stringByReplacingOccurrencesOfString:@"&frac34;" withString:@"¾"];
    string = [string stringByReplacingOccurrencesOfString:@"&iquest;" withString:@"¿"];
    string = [string stringByReplacingOccurrencesOfString:@"&times;" withString:@"×"];
    string = [string stringByReplacingOccurrencesOfString:@"&divide;" withString:@"÷"];
    
    // ISO 8859-1 Characters
    string = [string stringByReplacingOccurrencesOfString:@"&Agrave;" withString:@"À"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aacute;" withString:@"Á"];
    string = [string stringByReplacingOccurrencesOfString:@"&Acirc;" withString:@"Â"];
    string = [string stringByReplacingOccurrencesOfString:@"&Atilde;" withString:@"Ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&Auml;" withString:@"Ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&Aring;" withString:@"Å"];
    string = [string stringByReplacingOccurrencesOfString:@"&AElig;" withString:@"Æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ccedil;" withString:@"Ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&Egrave;" withString:@"È"];
    string = [string stringByReplacingOccurrencesOfString:@"&Eacute;" withString:@"É"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ecirc;" withString:@"Ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&Euml;" withString:@"Ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&Igrave;" withString:@"Ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iacute;" withString:@"Í"];
    string = [string stringByReplacingOccurrencesOfString:@"&Icirc;" withString:@"Î"];
    string = [string stringByReplacingOccurrencesOfString:@"&Iuml;" withString:@"Ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&ETH;" withString:@"Ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ntilde;" withString:@"Ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ograve;" withString:@"Ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oacute;" withString:@"Ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ocirc;" withString:@"Ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&Otilde;" withString:@"Õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ouml;" withString:@"Ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&Oslash;" withString:@"Ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ugrave;" withString:@"Ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uacute;" withString:@"Ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&Ucirc;" withString:@"Û"];
    string = [string stringByReplacingOccurrencesOfString:@"&Uuml;" withString:@"Ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&Yacute;" withString:@"Ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&THORN;" withString:@"Þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&szlig;" withString:@"ß"];
    string = [string stringByReplacingOccurrencesOfString:@"&agrave;" withString:@"à"];
    string = [string stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
    string = [string stringByReplacingOccurrencesOfString:@"&acirc;" withString:@"â"];
    string = [string stringByReplacingOccurrencesOfString:@"&atilde;" withString:@"ã"];
    string = [string stringByReplacingOccurrencesOfString:@"&auml;" withString:@"ä"];
    string = [string stringByReplacingOccurrencesOfString:@"&aring;" withString:@"å"];
    string = [string stringByReplacingOccurrencesOfString:@"&aelig;" withString:@"æ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ccedil;" withString:@"ç"];
    string = [string stringByReplacingOccurrencesOfString:@"&egrave;" withString:@"è"];
    string = [string stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
    string = [string stringByReplacingOccurrencesOfString:@"&ecirc;" withString:@"ê"];
    string = [string stringByReplacingOccurrencesOfString:@"&euml;" withString:@"ë"];
    string = [string stringByReplacingOccurrencesOfString:@"&igrave;" withString:@"ì"];
    string = [string stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
    string = [string stringByReplacingOccurrencesOfString:@"&icirc;" withString:@"î"];
    string = [string stringByReplacingOccurrencesOfString:@"&iuml;" withString:@"ï"];
    string = [string stringByReplacingOccurrencesOfString:@"&eth;" withString:@"ð"];
    string = [string stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ograve;" withString:@"ò"];
    string = [string stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
    string = [string stringByReplacingOccurrencesOfString:@"&ocirc;" withString:@"ô"];
    string = [string stringByReplacingOccurrencesOfString:@"&otilde;" withString:@"õ"];
    string = [string stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    string = [string stringByReplacingOccurrencesOfString:@"&oslash;" withString:@"ø"];
    string = [string stringByReplacingOccurrencesOfString:@"&ugrave;" withString:@"ù"];
    string = [string stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
    string = [string stringByReplacingOccurrencesOfString:@"&ucirc;" withString:@"û"];
    string = [string stringByReplacingOccurrencesOfString:@"&uuml;" withString:@"ü"];
    string = [string stringByReplacingOccurrencesOfString:@"&yacute;" withString:@"ý"];
    string = [string stringByReplacingOccurrencesOfString:@"&thorn;" withString:@"þ"];
    string = [string stringByReplacingOccurrencesOfString:@"&yuml;" withString:@"ÿ"];
    
    // Avinash
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&ndash;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
    return string;
}

-(void)shareButtonAction{
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
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *alertController;
            UIAlertAction *FacebookAction;
            UIAlertAction *TwitterAction;
            UIAlertAction *EmailAction;
            UIAlertAction *cancelAction;
            
            alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            FacebookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self facebookCall];
            }];
            TwitterAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self twitterCall];
            }];
            EmailAction = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self emailCall];
            }];
            cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:FacebookAction];//emailCall
            [alertController addAction:TwitterAction];
            [alertController addAction:EmailAction];
            [alertController addAction:cancelAction];
            alertController.modalInPopover = YES;
            /** Use this code for barbutton item **/
            alertController.popoverPresentationController.barButtonItem = shareBarButton;
            alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
            alertController.popoverPresentationController.delegate = self;
            [alertController setModalPresentationStyle:UIModalPresentationPopover];
            //        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
            //        popPresenter.sourceView = buttonResume;
            //        popPresenter.sourceRect = buttonResume.bounds;
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:nil
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             destructiveButtonTitle:nil
                             otherButtonTitles:@"Facebook", @"Twitter",@"Email", nil];
            [myActionSheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
        if (buttonIndex==0){
            [self facebookCall];
        }
        if (buttonIndex==1) {
            [self twitterCall];
        }
        if (buttonIndex==2) {
            [self emailCall];
        }
        
    }
}

-(void)facebookCall {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"Employer Name: %@ Jobs Available: %@",stringEmployerName,stringEmploperJobCount]];
        
        //[controller addURL:[NSURL URLWithString:stringFinalURL]];
        
        [controller addImage:[UIImage imageNamed:stringLogoImageURL]];
        
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case 0:
                {
                SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Some error occured. Please try again."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    break;
                }
                case 1:
                {
                    
                SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"This Job has been successfully posted on your facebook"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    break;
                }
                    
                default:
                    break;
                    
            }
            
        }];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook" message:@"Please login to your Facebook account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)twitterCall{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:[NSString stringWithFormat:@"Employer Name : %@ Jobs Available: %@",stringEmployerName,stringEmploperJobCount]];
        
        //[tweetSheet addURL:[NSURL URLWithString:stringFinalURL]];
        
        [tweetSheet addImage:[UIImage imageNamed:stringLogoImageURL]];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case 0: {
                SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Some error occured. Please try again."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                case 1: {
                    
                SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"This employer has been successfully posted to you twitter"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                default:
                    break;
                    
            }
            
        }];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Please login to your Twitter account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)emailCall {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setSubject:stringEmployerName];
        
        [mailViewController setMessageBody:[NSString stringWithFormat:@"Employer Name: %@\nDescription: %@\nNumber of jobs available: %@",stringEmployerName,stringEmployerDescription,stringEmploperJobCount] isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}

#pragma mark MFMailComposeViewController delegate method
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
            
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [self performSelectorInBackground:@selector(showAlertSucess) withObject:self];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            [self performSelectorInBackground:@selector(showAlertFailure) withObject:self];
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showAlertSucess {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Email sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showAlertFailure{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured while sending email. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
        
        //[[alertLogin textFieldAtIndex:0] text],@"userName",[[alertLogin textFieldAtIndex:1] text],@"password", nil];
        if ([[alertLogin textFieldAtIndex:0] text]>0) {
            if ([self NSStringIsValidEmail:[[alertLogin textFieldAtIndex:0] text]]==TRUE) {
                flagForgotPasswordEmpDetails = TRUE;
                jsonParser3 = [APParser sharedParser];
                jsonParser3.delegate = self;
                [self.tabBarController.view setUserInteractionEnabled:NO ];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.delegate = self;
                HUD.labelText = @"Loading";
                [HUD show:YES];
                
                NSString* methodName = @"ForgotPassword";
                NSString* soapAction = @"http://tempuri.org/ForgotPassword";
                
                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[alertLogin textFieldAtIndex:0] text],@"email",nil];
                
                NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                
                [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
                [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
            }else {
                //[self showAlertViewWithMessage:@"Please enter valid email id" withTitle:@"Error"];
                alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertPromt show];
            }
        }else {
            //[self showAlertViewWithMessage:@"Please enter email id" withTitle:@"Error"];
            alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertPromt show];
        }
    }
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

@end