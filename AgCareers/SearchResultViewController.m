//
//  SearchResultViewController.m
//  AgCareers
//
//  Created by Unicorn on 12/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "SearchResultViewController.h"
#import "JobDetailsViewController.h"
#import "LoginPopOverViewController.h"
#import "CreateProfileViewController.h"
#import <Google/Analytics.h>
@interface SearchResultViewController ()

@end


@implementation SearchResultViewController
@synthesize stringEmpoloyer,stringKeyword,stringLocation,stringSectors,stringCareers,stringTypes,tableViewResult,stringFromPageCount,stringToPageCount,viewFooter,tableViewRecruiter,segmentControl,segmentRecruiter,textFieldKeywordEmployer,textFieldKeywordRecruiter,buttonLoadMoreEmpoloyer,buttonLoadMoreRecruiter,viewFooterRecruiter;

NSInteger selectedSegment        = 0;
NSString *stringEmpRec = @"0";
BOOL SAVE_FLAG = FALSE;
int empoloyerJobCount;
int recruiterJobCount;
BOOL flagForgotPasswordSearchResult = FALSE;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Results";
    textFieldKeywordEmployer.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    textFieldKeywordRecruiter.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    [textFieldKeywordEmployer setText:stringKeyword];
    [textFieldKeywordRecruiter setText:stringKeyword];
    //    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search.png"]];
    //    arrow.frame = CGRectMake(0.0, 0.0, arrow.image.size.width+10.0, arrow.image.size.height);
    //    arrow.contentMode = UIViewContentModeCenter;
    //    textFieldKeywordRecruiter.leftView = arrow;
    //    textFieldKeywordRecruiter.leftViewMode = UITextFieldViewModeAlways;
    
    textFieldKeywordRecruiter.placeholder = [NSString stringWithFormat:@"%@ Jobs Title, Keywords",[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D" ]] ;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndex"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstLoad"];
    
    /* Navigation bar bold title */
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor: [UIColor whiteColor],
                                                           UITextAttributeTextShadowColor: [UIColor clearColor],
                                                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                           UITextAttributeFont: [UIFont fontWithName:@"Arial-Bold" size:0.0],
                                                           }];
    
    stringEmpRec = @"0";
    [[UISegmentedControl appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor blackColor]} forState:UIControlStateSelected];
    
    //    [segmentControl setSelectedSegmentIndex:0];
    
    arrayResult = [[NSMutableArray alloc]init];
    arrayRecruiter = [[NSMutableArray alloc]init];
    NSLog(@"%@",stringKeyword);
    NSLog(@"%@",stringLocation);
    NSLog(@"%@",stringEmpoloyer);
    NSLog(@"%@",stringSectors);
    NSLog(@"%@",stringTypes);
    NSLog(@"%@",stringCareers);
    
    [self callWebService];
}

-(void)viewWillAppear:(BOOL)animated{
    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Search Result Listing Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    //    long resultCount = [arrayResult count] +[arrayRecruiter count];
    //    if (resultCount == 0) {
    //        self.title = @"Results";
    //    }else {
    //        self.title = [NSString stringWithFormat:@"%ld Results",resultCount];
    //    }
    ///////////////////// segment title //////////////////
    //    if ([stringEmpRec isEqualToString:@"1"]) {
    //        NSString *employerCountString = [NSString stringWithFormat:@"Employer Jobs (%lu)",(unsigned long)[arrayResult count]];
    //        NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%lu)",(unsigned long)[arrayRecruiter count]];
    //        [segmentControl  setTitle:employerCountString forSegmentAtIndex:0];
    //        [segmentControl setTitle:recruiterCountString forSegmentAtIndex:1];
    //    }else {
    //        NSString *employerCountString = [NSString stringWithFormat:@"Employer Jobs (%lu)",(unsigned long)[arrayResult count]];
    //        NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%lu)",(unsigned long)[arrayRecruiter count]];
    //        [segmentRecruiter  setTitle:employerCountString forSegmentAtIndex:0];
    //        [segmentRecruiter setTitle:recruiterCountString forSegmentAtIndex:1];
    //    }
    
    ///////////////////// Navigation bar image /////////////////////
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_act_2_a.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark LoginView delegate method
-(void)sendResult : (NSDictionary *) resultDictionary{
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"segueFromSearchResultsSave"]) {
        
        LoginPopOverViewController *loginPopOverViewController = [segue destinationViewController];
        loginPopOverViewController.delegateLogin = self;
        
    } else if ([segue.identifier isEqualToString:@"SegueCreateJobSearchResult"] ){
        CreateProfileViewController *createProfileViewController = [segue destinationViewController];
        createProfileViewController.stringEmailIDCreateProfile = @"";
        
    }else{
        
        JobDetailsViewController *jobDetailsViewController = [segue destinationViewController];
        
        if ([stringEmpRec isEqualToString:@"0"]) {
            NSIndexPath *indexpath = [tableViewResult indexPathForSelectedRow];
            jobDetailsViewController.stringJobId = [[arrayResult objectAtIndex:indexpath.row]valueForKey:@"JOBID"];
        }else{
            NSIndexPath *indexpath = [tableViewRecruiter indexPathForSelectedRow];
            jobDetailsViewController.stringJobId = [[arrayRecruiter objectAtIndex:indexpath.row]valueForKey:@"JOBID"];
        }
    }
}
#pragma mark AlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == alertForLogin) {
        if (buttonIndex==1) {
            [self performSegueWithIdentifier:@"segueFromSearchResultsSave" sender:self];
        }else{
            
        }
    }
    
    if (alertView == alertPromt) {
        [alertLogin show];
    }
    
    if (alertView == alertLogin) {
        
        ///////////////////////// Login button
        if (buttonIndex==1) {
            [self loginAction];
        }
        
        ///////////////////////// Register now button
        if (buttonIndex == 2) {
            [self forgotPassword];
        }
        if (buttonIndex == 3) {
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.stringApplyWhileCreating = @"OnlyCreating";
            appDelegate.stringATSJob = @"";
            
            [self performSegueWithIdentifier:@"SegueCreateJobSearchResult" sender:self];
        }
    }
    if (alertView == alertSaveTitle) {
        
        if (buttonIndex == 1) {
            jsonParser2 = [APParser sharedParser];
            jsonParser2.delegate = self;
            
            [self.tabBarController.view setUserInteractionEnabled:NO ];
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"Loading";
            [HUD show:YES];
            
            NSString* methodName = @"SaveSeach";
            NSString* soapAction = @"http://tempuri.org/SaveSeach";
            
            NSString *stringSaveTitle = [[alertSaveTitle textFieldAtIndex:0] text];
            
            NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"0",@"deviceId",
                                           stringKeyword,@"keyword",
                                           stringLocation,@"location",
                                           stringSectors,@"industrySector",
                                           stringTypes,@"iType",
                                           stringCareers,@"cType",
                                           [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"applicantid",
                                           stringEmpoloyer,@"employerid",
                                           stringSaveTitle,@"Title",
                                           @"",@"StateIDs",
                                           @"0",@"RegionIDs",
                                           @"0",@"CountryIDs",
                                           @"0",@"SavedSearchID",
                                           nil];
            NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict",nil];
            
            [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
            
            [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
        }else{
            
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
        
        //[[alertLogin textFieldAtIndex:0] text],@"userName",[[alertLogin textFieldAtIndex:1] text],@"password", nil];
        if ([[alertLogin textFieldAtIndex:0] text]>0) {
            if ([self NSStringIsValidEmail:[[alertLogin textFieldAtIndex:0] text]]==TRUE) {
                flagForgotPasswordSearchResult = TRUE;
                jsonParser4 = [APParser sharedParser];
                jsonParser4.delegate = self;
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
                [jsonParser4 parseSoapWithJSONSoapContents:dictToSend];
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

BOOL flagLogin = FALSE;

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
                //NSLog(@"white space is there...");
                alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Valid Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertPromt show];
            }else{
                //Call Web service here
                if ([[[alertLogin textFieldAtIndex:1] text] length]==0) {
                    alertPromt = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertPromt show];
                }else{
                    flagLogin = TRUE;
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

#pragma mark email validater
-(BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark Call web service
-(void)callWebService {
    jsonParser1 = [APParser sharedParser];
    jsonParser1.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetJobAdvanceSearch";
    NSString* soapAction = @"http://tempuri.org/GetJobAdvanceSearch";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   stringEmpRec,@"EmpRec",
                                   @"false",@"Flagship",
                                   @"false",@"Featured",
                                   @"",@"Frontpage",
                                   @"",@"JobType",
                                   stringSectors,@"IndustrySector",
                                   stringTypes,@"itype",
                                   stringCareers,@"ctype",
                                   @"0",@"experience",
                                   @"0",@"countryID",
                                   stringLocation,@"NonIntCountry",
                                   @"",@"region",
                                   @"",@"stateid",
                                   stringKeyword,@"keywords",
                                   @"",@"exactPhrase",
                                   @"",@"excludeWords",
                                   @"",@"anyOfTheseWords",
                                   @"0",@"fJobs",
                                   @"0",@"isOthersBlank",
                                   @"2",@"maxGroup",
                                   @"LastUpdated DESC",@"orderBy",
                                   stringFromPageCount,@"PageFrom",
                                   stringToPageCount,@"PageTo",
                                   @"false",@"loadmore",
                                   stringEmpoloyer,@"employerid",
                                   nil];
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser1 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice {
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    
    //    {
    //        d = "{\"JobsList\":null,\"EMPJOBCOUNT\":null,\"RECJOBCOUNT\":null,\"ID\":0,\"ID2\":0,\"ReferredBy\":null,\"Success\":false,\"ErrorMsg\":\"Can not convert Integer to String.\"}";
    //    }
    
    if (successBool == YES) {
        
        if (SAVE_FLAG==TRUE) {
            SAVE_FLAG = FALSE;
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDictSave = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                           options: NSJSONReadingMutableContainers
                                                             error: &error];//ErrorMsg
            int sucessFlag = [[JSONDictSave objectForKey:@"Success"] intValue];
            UIAlertView *alertSave ;
            if (sucessFlag==1) {
                alertSave = [[UIAlertView alloc]initWithTitle:@"Success" message:[JSONDictSave valueForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertSave show];
            }else {
                alertSave = [[UIAlertView alloc]initWithTitle:@"Error" message:[JSONDictSave valueForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertSave show];
            }
        } else if (flagLogin == TRUE){
            [HUD hide:YES];
            flagLogin = FALSE;
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
                [self saveSearchFilter];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered an incorrect username/password and/or you are not approved to use the site.If you continue to have problems, please contact agcareers@agcareers.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else if (flagForgotPasswordSearchResult == TRUE){
            flagForgotPasswordSearchResult = FALSE;
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
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            
            
            if ([[JSONDict valueForKey:@"Success"]intValue]==1){
                
                
                if ([stringEmpRec isEqualToString:@"0"]) {
                    [arrayResult addObjectsFromArray:[JSONDict valueForKey:@"JobsList"]];
                    if ([arrayResult count]==0) {
                        
                        NSString *stringEmployer = [NSString stringWithFormat:@"Employer Jobs (%@)", [JSONDict valueForKey:@"EMPJOBCOUNT"]];
                        NSString *stringRecruiter = [NSString stringWithFormat:@"Recruiter Jobs (%@)", [JSONDict valueForKey:@"RECJOBCOUNT"]];
                        
                        [segmentControl  setTitle:stringEmployer forSegmentAtIndex:0];
                        [segmentControl setTitle:stringRecruiter forSegmentAtIndex:1];
                        
                        int totalJobCount = [[JSONDict valueForKey:@"EMPJOBCOUNT"] intValue]+ [[JSONDict valueForKey:@"RECJOBCOUNT"] intValue];
                        
                        self.title = [NSString stringWithFormat:@" %d Results ",totalJobCount];//@"Results";
                    }else {
                        
                        int empoloyerJobCount = [[[arrayResult objectAtIndex:0]valueForKey:@"EMPJOBCOUNT"] intValue];
                        int recruiterJobCount = [[[arrayResult objectAtIndex:0]valueForKey:@"RECJOBCOUNT"] intValue];
                        
                        if (empoloyerJobCount == 0 && recruiterJobCount == 0) {
                            NSString *employerCountString = @"Employer Jobs";
                            NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%d)",recruiterJobCount];
                            
                            [segmentControl  setTitle:employerCountString forSegmentAtIndex:0];
                            [segmentRecruiter setTitle:recruiterCountString forSegmentAtIndex:1];
                        }else {
                            NSString *employerCountString = [NSString stringWithFormat:@"Employer Jobs (%d)",empoloyerJobCount];
                            NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%d)",recruiterJobCount];
                            
                            [segmentControl  setTitle:employerCountString forSegmentAtIndex:0];
                            [segmentControl setTitle:recruiterCountString forSegmentAtIndex:1];
                        }
                        
                        long resultCount = empoloyerJobCount+recruiterJobCount;
                        
                        if (resultCount == 0) {
                            self.title = @"Results";
                        }else {
                            self.title = [NSString stringWithFormat:@"%ld Results",resultCount];
                        }
                        
                        [tableViewResult reloadData];
                    }
                }else {
                    
                    [arrayRecruiter addObjectsFromArray:[JSONDict valueForKey:@"JobsList"]];
                    
                    if ([arrayRecruiter count]==0) {
                        
                        NSString *stringEmployer = [NSString stringWithFormat:@"Employer Jobs (%@)", [JSONDict valueForKey:@"EMPJOBCOUNT"]];
                        NSString *stringRecruiter = [NSString stringWithFormat:@"Recruiter Jobs (%@)", [JSONDict valueForKey:@"RECJOBCOUNT"]];
                        
                        [segmentRecruiter  setTitle:stringEmployer forSegmentAtIndex:0];
                        [segmentRecruiter setTitle:stringRecruiter forSegmentAtIndex:1];
                        int totalJobCount = [[JSONDict valueForKey:@"EMPJOBCOUNT"] intValue]+ [[JSONDict valueForKey:@"RECJOBCOUNT"] intValue];
                        self.title = [NSString stringWithFormat:@" %d Results ",totalJobCount];//@"Results";
                    }else {
                        
                        int empoloyerJobCount = [[[arrayRecruiter objectAtIndex:0]valueForKey:@"EMPJOBCOUNT"]intValue];
                        int recruiterJobCount = [[[arrayRecruiter objectAtIndex:0]valueForKey:@"RECJOBCOUNT"]intValue];
                        
                        if (empoloyerJobCount == 0 && recruiterJobCount == 0) {
                            NSString *employerCountString = @"Employer Jobs";
                            NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%d)",recruiterJobCount];
                            
                            [segmentControl  setTitle:employerCountString forSegmentAtIndex:0];
                            [segmentRecruiter setTitle:recruiterCountString forSegmentAtIndex:1];
                        }else{
                            NSString *employerCountString = [NSString stringWithFormat:@"Employer Jobs (%d)",empoloyerJobCount];
                            NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%d)",recruiterJobCount];
                            
                            [segmentRecruiter  setTitle:employerCountString forSegmentAtIndex:0];
                            [segmentRecruiter setTitle:recruiterCountString forSegmentAtIndex:1];
                        }
                        
                        long resultCount = empoloyerJobCount+recruiterJobCount;
                        if (resultCount == 0) {
                            self.title = @"Results";
                        }else {
                            self.title = [NSString stringWithFormat:@"%ld Results",resultCount];
                        }
                        [tableViewRecruiter reloadData];
                    }
                }
            }else{
                
            }
            
        }
    }else{
        [HUD hide:YES];
        UIAlertView *alertSuccessStatus = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSuccessStatus show];
    }
}

#pragma mark tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==tableViewResult) {
        if ([arrayResult count]>0)
            return [arrayResult count];
        else
            return 1;
    }else{
        if ([arrayRecruiter count]>0)
            return [arrayRecruiter count];
        else
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==tableViewResult) {
        
        if ([arrayResult count]>0) {
            [viewFooter setHidden:NO];
            static NSString *kCellID = @"cellResultID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
            UILabel *labelTitle = (UILabel *)[cell viewWithTag:450];
            UILabel *labelCompanyName = (UILabel *)[cell viewWithTag:451];
            UILabel *labelAddress = (UILabel *)[cell viewWithTag:452];
            UILabel *labelDays = (UILabel *)[cell viewWithTag:453];
            labelTitle.text = [[arrayResult objectAtIndex:indexPath.row]valueForKey:@"TITLE"];
            labelCompanyName.text = [[arrayResult objectAtIndex:indexPath.row]valueForKey:@"COMPANY"];
            
            NSString *locationValues;
            NSString *city = [[arrayResult objectAtIndex:indexPath.row]valueForKey:@"CITY"];
            NSString *state= [[arrayResult objectAtIndex:indexPath.row]valueForKey:@"STATE"];
            NSString *country =[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"COUNTRY"];
            
            if(city.length >0 && state.length >0 && country.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@, %@",city,state,country];
            }
            else if(city.length >0 && state.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@",city,state];
            }
            else if(state.length >0 && country.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@",state,country];
            }
            else if(country.length >0 && city.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@",city,country];
            }
            else {
                locationValues = [NSString stringWithFormat:@"%@%@%@",city,state,country];
            }
            
            labelAddress.text = locationValues;
            labelDays.text = [[arrayResult objectAtIndex:indexPath.row]valueForKey:@"DATEADDEDDISPLAY"];//RECJOBCOUNT
            if ([arrayResult count]==[[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"EMPJOBCOUNT"]intValue]) {
                [viewFooter setHidden:YES];
            }else{
                
                if (indexPath.row == [arrayResult count] - 1)
                {
                    NSLog(@"index path : %ld %lu",(long)indexPath.row,(unsigned long)([arrayResult count]-1));
                    [self loadMore];
                }
                
                [viewFooter setHidden:NO];
            }
            return cell;
        }else{
            [viewFooter setHidden:YES];
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = @"No result found for given keyword";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            if ([arrayResult count]<21) {
                [viewFooter setHidden:YES];
            }else{
                [viewFooter setHidden:NO];
            }
            return cell;
        }
    }else {
        if ([arrayRecruiter count]>0) {
            [viewFooterRecruiter setHidden:NO];
            static NSString *kCellID = @"cellRecruiterID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
            UILabel *labelTitle = (UILabel *)[cell viewWithTag:454];
            UILabel *labelCompanyName = (UILabel *)[cell viewWithTag:455];
            UILabel *labelAddress = (UILabel *)[cell viewWithTag:456];
            UILabel *labelDays = (UILabel *)[cell viewWithTag:457];
            labelTitle.text = [[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"TITLE"];
            labelCompanyName.text = [[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"COMPANY"];
            
            NSString *locationValues;
            NSString *city = [[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"CITY"];
            NSString *state= [[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"STATE"];
            NSString *country =[[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"COUNTRY"];
            
            if(city.length >0 && state.length >0 && country.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@, %@",city,state,country];
                //locationValues=city+", "+state+", "+country;
            }
            else if(city.length >0 && state.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@",city,state];
                //locationValues=city+","+state;
            }
            else if(state.length >0 && country.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@",state,country];
                //locationValues=state+", "+countryName;
            }
            else if(country.length >0 && city.length >0){
                locationValues = [NSString stringWithFormat:@"%@, %@",city,country];
                //locationValues=city+", "+countryName;
            }
            else {
                locationValues = [NSString stringWithFormat:@"%@%@%@",city,state,country];
                //locationValues = city+state+countryName;
            }
            
            labelAddress.text = locationValues;
            //labelAddress.text = [[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"AREALONG"];
            labelDays.text = [[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"DATEADDEDDISPLAY"];
            if ([arrayRecruiter count]==[[[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"RECJOBCOUNT"]intValue]) {//
                [viewFooterRecruiter setHidden:YES];
            }else{
                
                if (indexPath.row == [arrayRecruiter count] - 1)
                {
                    NSLog(@"index path : %ld %lu",(long)indexPath.row,(unsigned long)([arrayResult count]-1));
                    [self loadMore];
                }
                
                [viewFooterRecruiter setHidden:NO];
            }
            return cell;
        }else{
            [viewFooterRecruiter setHidden:YES];
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = @"No result found for given keyword";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            if ([arrayRecruiter count]<21) {
                [viewFooterRecruiter setHidden:YES];
            }else{
                [viewFooterRecruiter setHidden:NO];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        //        if ([stringEmpRec isEqualToString:@"0"]) {
        //            NSLog(@"%@",[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"TITLE"]);//JOBID
        //        }else{
        //            NSLog(@"%@",[[arrayRecruiter objectAtIndex:indexPath.row]valueForKey:@"TITLE"]);
        //        }
        if (tableView == tableViewResult) {
            if ([arrayResult count]>0) {
                [self performSegueWithIdentifier:@"JobDetailsSegue" sender:self];
            }else{
                
            }
        }
        if (tableView == tableViewRecruiter) {
            if ([arrayRecruiter count]>0) {
                [self performSegueWithIdentifier:@"JobDetailsSegue" sender:self];
            }else{
                
            }
        }
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        //[self loadMore];
        
        if (indexPath.row == [arrayResult count] - 1)
        {
            NSLog(@"index path : %ld %lu",(long)indexPath.row,(unsigned long)([arrayResult count]-1));
            //            [self loadMore];
        }
    }
}

-(void)loadMore{
    
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
        if ([stringEmpRec isEqualToString:@"0"]) {
            int fromCount   = [stringFromPageCount intValue];
            int toCount     = [stringToPageCount intValue];
            fromCount       = fromCount +20;
            toCount         = toCount +20;
            stringFromPageCount = [NSString stringWithFormat:@"%d",fromCount];
            stringToPageCount   = [NSString stringWithFormat:@"%d",toCount];
            [self callWebService];
        }else{
            int fromCount   = [stringFromPageCount intValue];
            int toCount     = [stringToPageCount intValue];
            fromCount       = fromCount +20;
            toCount         = toCount +20;
            stringFromPageCount = [NSString stringWithFormat:@"%d",fromCount];
            stringToPageCount   = [NSString stringWithFormat:@"%d",toCount];
            [self callWebService];
        }
    }
}

- (IBAction)buttonActiionLoadMore:(id)sender {
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
        if ([stringEmpRec isEqualToString:@"0"]) {
            int fromCount   = [stringFromPageCount intValue];
            int toCount     = [stringToPageCount intValue];
            fromCount       = fromCount +20;
            toCount         = toCount +20;
            stringFromPageCount = [NSString stringWithFormat:@"%d",fromCount];
            stringToPageCount   = [NSString stringWithFormat:@"%d",toCount];
            [self callWebService];
        }else{
            int fromCount   = [stringFromPageCount intValue];
            int toCount     = [stringToPageCount intValue];
            fromCount       = fromCount +20;
            toCount         = toCount +20;
            stringFromPageCount = [NSString stringWithFormat:@"%d",fromCount];
            stringToPageCount   = [NSString stringWithFormat:@"%d",toCount];
            [self callWebService];
        }
    }
}

- (IBAction)segmentAction:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedIndex"]isEqualToString:@"0"]) {
        stringFromPageCount = @"1";
        stringToPageCount   = @"20";
        
        stringKeyword = textFieldKeywordRecruiter.text;
        
        //[textFieldKeywordRecruiter setText:textFieldKeywordEmployer.text];
        
        [segmentControl setSelectedSegmentIndex:0];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"selectedIndex"];
        [tableViewResult setHidden:FALSE];
        [tableViewRecruiter setHidden:TRUE];
        stringEmpRec = @"0";
        if ([arrayRecruiter count]==0) {
            
        }else{
            
            if ([arrayResult count]>0) {
                int empoloyerJobCount = [[[arrayResult objectAtIndex:0]valueForKey:@"EMPJOBCOUNT"] intValue];
                int recruiterJobCount = [[[arrayResult objectAtIndex:0]valueForKey:@"RECJOBCOUNT"] intValue];
                NSString *employerCountString = [NSString stringWithFormat:@"Employer Jobs (%d)",empoloyerJobCount];
                NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%d)",recruiterJobCount];
                
                [segmentControl  setTitle:employerCountString forSegmentAtIndex:0];
                [segmentControl setTitle:recruiterCountString forSegmentAtIndex:1];
            }else{
                [segmentControl setTitle:@"Employer Jobs" forSegmentAtIndex:0];
                [segmentControl setTitle:@"Recruiter Jobs" forSegmentAtIndex:1];
            }
        }
        [arrayResult removeAllObjects];
        [tableViewResult reloadData];
        [self callWebService];
    }
    else {
        stringFromPageCount = @"1";
        stringToPageCount   = @"20";
        
        //stringKeyword = textFieldKeywordEmployer.text;
        stringKeyword = textFieldKeywordRecruiter.text;
        
        //[textFieldKeywordEmployer setText:textFieldKeywordRecruiter.text];
        
        //        UIImageView *serachIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search.png"]];
        //        serachIconImageView.frame = CGRectMake(0.0, 0.0, serachIconImageView.image.size.width+10.0, serachIconImageView.image.size.height);
        //        serachIconImageView.contentMode = UIViewContentModeCenter;
        //
        //        textFieldKeywordEmployer.leftView = serachIconImageView;
        //        textFieldKeywordEmployer.leftViewMode = UITextFieldViewModeAlways;
        textFieldKeywordEmployer.placeholder = [NSString stringWithFormat:@"%@ Jobs Title, Keywords",[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D" ]] ;
        [segmentRecruiter setSelectedSegmentIndex:1];
        //        [segmentControl setSelectedSegmentIndex:1];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"selectedIndex"];
        [tableViewResult setHidden:TRUE];
        [tableViewRecruiter setHidden:FALSE];
        stringEmpRec = @"1";
        
        if ([arrayResult count ]==0) {
            
        }else{
            
            if ([arrayResult count]>0) {
                int empoloyerJobCount = [[[arrayResult objectAtIndex:0]valueForKey:@"EMPJOBCOUNT"] intValue];
                int recruiterJobCount = [[[arrayResult objectAtIndex:0]valueForKey:@"RECJOBCOUNT"] intValue];
                NSString *employerCountString = [NSString stringWithFormat:@"Employer Jobs (%d)",empoloyerJobCount];
                NSString *recruiterCountString = [NSString stringWithFormat:@"Recruiter Jobs (%d)",recruiterJobCount];
                
                [segmentRecruiter  setTitle:employerCountString forSegmentAtIndex:0];
                [segmentRecruiter setTitle:recruiterCountString forSegmentAtIndex:1];
                
            }else{
                [segmentRecruiter  setTitle:@"Employer Jobs" forSegmentAtIndex:0];
                [segmentRecruiter setTitle:@"Recruiter Jobs" forSegmentAtIndex:1];
            }
            
        }
        //        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"FirstLoad"]isEqualToString:@"FirstTimeLoad"]) {
        //
        //        }else{
        //            [[NSUserDefaults standardUserDefaults]setValue:@"FirstTimeLoad" forKey:@"FirstLoad"];
        //            [self callWebService];
        //        }
        [arrayRecruiter removeAllObjects];
        [tableViewRecruiter reloadData];
        [self callWebService];
    }
}

- (IBAction)buttonActionSave:(id)sender {//[[JSONDict valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"]
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
            
            [self saveSearchFilter];
            
        }else {
            //User is not logged in
            //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
            //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            //        [self presentViewController:vc animated:YES completion:NULL];
            
            alertLogin =[[UIAlertView alloc ] initWithTitle:@"Login" message:@"Enter Username & Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alertLogin.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            [alertLogin textFieldAtIndex:0].placeholder = @"Username";
            [alertLogin addButtonWithTitle:@"Login"];
            [alertLogin addButtonWithTitle:@"Forgot Password?"];
            [alertLogin addButtonWithTitle:@"Register now"];
            [alertLogin show];
        }
    }
}

-(void)saveSearchFilter{
    
    SAVE_FLAG = TRUE;
    
    alertSaveTitle =[[UIAlertView alloc ] initWithTitle:@"Search Title" message:@"Please enter search title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alertSaveTitle.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertSaveTitle addButtonWithTitle:@"OK"];
    [alertSaveTitle show];
}

- (IBAction)buttonActionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textFieldKeywordEmployer resignFirstResponder];
    [textFieldKeywordRecruiter resignFirstResponder];
    
    if ([stringEmpRec isEqualToString:@"0"]) {
        //if (textFieldKeywordRecruiter.text.length>0) {
        stringKeyword = textFieldKeywordRecruiter.text;
        [textFieldKeywordEmployer setText:textFieldKeywordRecruiter.text];
        [arrayResult removeAllObjects];
        [tableViewResult reloadData];
        stringFromPageCount = @"1";
        stringToPageCount   = @"20";
        [self callWebService];
        //}
    }else{
        //if (textFieldKeywordEmployer.text.length>0) {
        stringKeyword = textFieldKeywordEmployer.text;
        [textFieldKeywordRecruiter setText:textFieldKeywordEmployer.text];
        [arrayRecruiter removeAllObjects];
        [tableViewRecruiter reloadData];
        stringFromPageCount = @"1";
        stringToPageCount   = @"20";
        [self callWebService];
        //}
    }
    return YES;
}

@end