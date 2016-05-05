//
//  JobDetailsViewController.m
//  AgCareers
//
//  Created by Unicorn on 26/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "JobDetailsViewController.h"
#import "APParser.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "EmployerDetailsViewController.h"
#import "ApplyForViewController.h"
#import "ApplyProfileViewController.h"
#import <Google/Analytics.h>
#import "CreateProfileViewController.h"
@interface JobDetailsViewController ()

@end

@implementation JobDetailsViewController
@synthesize tableViewJobDetails;
@synthesize stringJobId,labelJobTitle;
int cellheight;
NSString *JobLocationString;
BOOL flagFacebookCall               = FALSE;
BOOL flagtwitterCall                = FALSE;
BOOL flagForgotPasswordJobDetails   = FALSE;
BOOL flagSavedJob                   = FALSE;
BOOL flagLoginDetail                = FALSE;
BOOL flagCheckAlreadyApplied        = FALSE;
NSString *urlString = @"";

NSString *descriptionString;

- (void)viewDidLoad {
    [super viewDidLoad];
    cellheight = 150;
    shareBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
    
    UIBarButtonItem *favoriteBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_favourites_add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(favaritesButtonAction)];
    
    if (self.tabBarController.selectedIndex ==0) {
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:shareBarButton,favoriteBarButton, nil];
        self.navigationItem.rightBarButtonItems = arrBtns;
        
    }
    if (self.tabBarController.selectedIndex ==1) {
        NSArray *arrBtns = [[NSArray alloc]initWithObjects:shareBarButton, nil];
        self.navigationItem.rightBarButtonItems = arrBtns;
        
    }
    if (self.tabBarController.selectedIndex == 1) {
        
    }else{
        jsonParser2 = [APParser sharedParser];
        jsonParser2.delegate = self;
        [self callWebService];
    }
}

-(void)GetShareURL{
    
    flagFacebookCall = TRUE;
    
    jsonParser5 = [APParser sharedParser];
    
    jsonParser5.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    
    HUD.labelText = @"Loading";
    
    [HUD show:YES];
    
    NSString* methodName = @"GetJobURL";
    
    NSString* soapAction = @"http://tempuri.org/GetJobURL";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringJobId,@"jobid", nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    
    [jsonParser5 parseSoapWithJSONSoapContents:dictToSend];
    
    [HUD hide:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    flagCheckAlreadyApplied = FALSE;
    //#import <Google/Analytics.h>s
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Job Details Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        
        if (self.tabBarController.selectedIndex == 1) {
            jsonParser2 = [APParser sharedParser];
            jsonParser2.delegate = self;
            [self callWebService];
        }
    }else {
        //User is not logged in
        if (self.tabBarController.selectedIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:NO completion:NULL];
    }
}

//BFGNV H250.3625014
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
        
        NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
        NSString *urlStringConfig = [dictRoot objectForKey:@"MorePage"];

        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *stringFinalURL;

        if ([[JSONDict valueForKey:@"isConfidential"]intValue]==1) {
            
            NSArray *itemArr = [urlString componentsSeparatedByString:@"/"];
            NSString *str = [itemArr objectAtIndex:2];
            stringFinalURL = [NSString stringWithFormat: @"%@confidential/%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"JobShare"],str];
            
        }else{
            stringFinalURL = [NSString stringWithFormat: @"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"JobShare"],urlString];
        }
        
        
        
        [controller setInitialText:[NSString stringWithFormat:@"Company Name: %@\nJob Title: %@\nLocation: %@\nJob Link URL: %@",[JSONDict objectForKey:@"JobCompany"],[JSONDict objectForKey:@"JobLocation"],[JSONDict objectForKey:@"JobTitle"],stringFinalURL]];
        
        [controller addURL:[NSURL URLWithString:stringFinalURL]];
        
        [controller addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@new-skin/creative/assets/logos/logo.png",urlStringConfig]]];
        
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
        
        NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
        NSString *urlStringConfig = [dictRoot objectForKey:@"MorePage"];
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *stringTitle = [JSONDict objectForKey:@"JobTitle"];
        
        NSString *stringFinalURL;
        
        if ([[JSONDict valueForKey:@"isConfidential"]intValue]==1) {
            
            NSArray *itemArr = [urlString componentsSeparatedByString:@"/"];
            NSString *str = [itemArr objectAtIndex:2];
            stringFinalURL = [NSString stringWithFormat: @"%@confidential/%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"JobShare"],str];
            
        }else{
            stringFinalURL = [NSString stringWithFormat: @"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"JobShare"],urlString];
        }
        
        [tweetSheet setInitialText:stringTitle];
        
        [tweetSheet addURL:[NSURL URLWithString:stringFinalURL]];
                
        [tweetSheet addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@new-skin/creative/assets/logos/logo.png",urlStringConfig]]];
        
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
                                                                    message:@"This Job has been successfully posted to you twitter"
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

    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
    NSString *urlStringConfig = [dictRoot objectForKey:@"MorePage"];
    
    NSString *stringFinalURL;
    
    if ([[JSONDict valueForKey:@"isConfidential"]intValue]==1) {
        
        NSArray *itemArr = [urlString componentsSeparatedByString:@"/"];
        NSString *str = [itemArr objectAtIndex:2];
        stringFinalURL = [NSString stringWithFormat: @"%@confidential/%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"JobShare"],str];
    }else{
        stringFinalURL = [NSString stringWithFormat: @"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"JobShare"],urlString];
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setSubject:[JSONDict objectForKey:@"JobTitle"]];
        
        [mailViewController setMessageBody:[NSString stringWithFormat:@"Company Name: %@\nJob Title: %@\nLocation: %@\nJob Link URL: %@",[JSONDict objectForKey:@"JobCompany"],[JSONDict objectForKey:@"JobTitle"],[JSONDict objectForKey:@"JobLocation"],stringFinalURL] isHTML:NO];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}

-(void)favaritesButtonAction {
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

#pragma mark AlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
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

            [self performSegueWithIdentifier:@"SegueCreateJobDetails" sender:self];
        }
    }
    if (alertView == alertForOpenBrowser) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:[JSONDict valueForKey:@"ApplyLink"]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }if (alertView ==  alertForBack) {
        [self.navigationController popViewControllerAnimated:YES];
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
                    flagLoginDetail = TRUE;
                    jsonParser4 = [APParser sharedParser];
                    jsonParser4.delegate = self;
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.delegate = self;
                    HUD.labelText = @"Loading";
                    [HUD show:YES];
                    NSString* methodName = @"ValidateLogin";
                    NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[alertLogin textFieldAtIndex:0] text],@"userName",[[alertLogin textFieldAtIndex:1] text],@"password", nil];
                    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
                    [jsonParser4 parseSoapWithJSONSoapContents:dictToSend];
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

-(void)addToFavourite{
    flagSavedJob = TRUE;
    
    jsonParser3 = [APParser sharedParser];
    jsonParser3.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"SavedJob";
    NSString* soapAction = @"http://tempuri.org/SavedJob";
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",stringJobId,@"JobID", nil];
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    NSString *str = @"Our class rp>\r\n";
    NSAttributedString *newStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    //NSString *strFiltered = [newStr string];
    if (IDIOM==IPAD) {
        CGSize size1 = [self findHeightForText:descriptionString havingWidth:768 andFont:[UIFont systemFontOfSize:17]];//(768 *1024
        cellheight = size1.height;
    }else {
        CGSize size1 = [self findHeightForText:descriptionString havingWidth:300 andFont:[UIFont systemFontOfSize:14]];
        cellheight = size1.height;
    }
    [tableViewJobDetails reloadData];
}

- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return cellheight;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(indexPath.row==0){
        static NSString *CellID = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:411];
        
        labelTitle.text = descriptionString;
        
        UIButton *buttonDelete = (UIButton *)[cell viewWithTag:1677];
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [buttonDelete addGestureRecognizer:singleFingerTap];
        if (cellheight <150) {
            buttonDelete.hidden= YES;
        }
        if (cellheight>500) {
            buttonDelete.hidden = YES;
        }
        return cell;
    }
    if(indexPath.row==1){
        static NSString *CellID = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:412];
        labelTitle.text = [JSONDict objectForKey:@"JobCompany"];
        NSMutableAttributedString *mat = [labelTitle.attributedText mutableCopy];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
        labelTitle.attributedText = mat;
        return cell;
    }
    if(indexPath.row==2){
        static NSString *CellID = @"Cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:413];
        labelTitle.text = [JSONDict objectForKey:@"JobLocation"];
        return cell;
    }
    if(indexPath.row==3){
        static NSString *CellID = @"Cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:414];
        labelTitle.text = [JSONDict objectForKey:@"IndustryType"];
        return cell;
    }
    if(indexPath.row==4){
        static NSString *CellID = @"Cell5";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:415];
        labelTitle.text = [JSONDict objectForKey:@"CareerType"];
        return cell;
    }
    
    if(indexPath.row==5){
        static NSString *CellID = @"Cell6";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:416];
        labelTitle.text = [JSONDict objectForKey:@"JobType"];
        return cell;
    }
    if(indexPath.row==6){
        static NSString *CellID = @"Cell7";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:417];
        if ([[JSONDict objectForKey:@"Experience"]length]==0)
            labelTitle.text = @"N/A";
        else
            labelTitle.text = [JSONDict objectForKey:@"Experience"];
        return cell;
    }
    if(indexPath.row==7){
        static NSString *CellID = @"Cell8";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *labelTitle = (UILabel *)[cell viewWithTag:418];
        labelTitle.text = [JSONDict objectForKey:@"Salary"];
        return cell;
    }
    //        if(indexPath.row==8){
    //            static NSString *CellID = @"Cell9";
    //            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //            UILabel *labelTitle = (UILabel *)[cell viewWithTag:419];
    //            labelTitle.text = @"NA";
    //            return cell;
    //        }
    
    else{
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
        if ([[JSONDict valueForKey:@"isConfidential"]intValue]==1) {
            
        }else{
            if (indexPath.row == 1) {
                [self performSegueWithIdentifier:@"SegueEmployerDetailsFromJobDetails" sender:self];
            }
        }
    }
}

-(void)callWebService {
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetJobDetail";
    NSString* soapAction = @"http://tempuri.org/GetJobDetail";
    NSDictionary* parameterDict;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: stringJobId,@"JobID",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",@"iOSTest",@"UserIP",@"0",@"LongIP",@"0",@"CountryID",nil];
    }else{
        parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: stringJobId,@"JobID",@"0",@"MemberID",@"iOSTest",@"UserIP",@"0",@"LongIP",@"0",@"CountryID",nil];

    }
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
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

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    
    if (flagLoginDetail == TRUE) {
        [HUD hide:YES];
        flagLoginDetail = FALSE;
        NSError *error;
        NSDictionary *JSONDict12 =
        [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &error];
        if ([[[JSONDict12 valueForKey:@"ErrorFlag"]objectAtIndex:0] isEqualToString:@"Success"]==TRUE) {
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict12 valueForKey:@"ErrorFlag"]objectAtIndex:0] forKey:@"SuceessStatus"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict12 valueForKey:@"Message"]objectAtIndex:0] forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults]setObject:[[JSONDict12 valueForKey:@"Email"]objectAtIndex:0] forKey:@"UserEmail"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self addToFavourite];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered an incorrect username/password and/or you are not approved to use the site.If you continue to have problems, please contact agcareers@agcareers.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if (flagSavedJob == TRUE){
        flagSavedJob = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict11 = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                     options: NSJSONReadingMutableContainers
                                                       error: &error];
        int sucessFlag = [[JSONDict11 objectForKey:@"Success"] intValue];
        UIAlertView *alertSave ;
        if (sucessFlag==1) {
            alertSave = [[UIAlertView alloc]initWithTitle:@"Sucess" message:[JSONDict11 valueForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertSave show];
        }else {
            alertSave = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error has occured. Please try after some time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertSave show];
        }
    }else if (flagFacebookCall == TRUE){
        
        flagFacebookCall = FALSE;
        
        [HUD hide:YES];
        
        [self.tabBarController.view setUserInteractionEnabled:YES];
        
        NSError *error;
        
        JSONDict22 = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                      
                                                     options: NSJSONReadingMutableContainers
                      
                                                       error: &error];
        
        urlString = [JSONDict22 objectForKey:@"ErrorMsg"];  // ErrorMsg having URL Value
        
    }else if (flagtwitterCall == TRUE){
        
        flagtwitterCall = FALSE;
        
        [HUD hide:YES];
        
        [self.tabBarController.view setUserInteractionEnabled:YES];
        
        NSError *error;
        
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers
                                                     error: &error];
        urlString = [JSONDict objectForKey:@"ErrorMsg"];  // ErrorMsg having URL Value
        
    }else if (flagForgotPasswordJobDetails == TRUE){
        flagForgotPasswordJobDetails = FALSE;
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
    }else if(flagCheckAlreadyApplied==TRUE){
        flagCheckAlreadyApplied = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
        
        if ([[JSONDict objectForKey:@"Success"] intValue]==1) {
            alertForAlreadyApplied = [[UIAlertView alloc]initWithTitle:@"Error" message:[JSONDict objectForKey:@"ErrorMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertForAlreadyApplied show];
        }else{
            [self performSegueWithIdentifier:@"SegueDirectApplyWithLogin" sender:self];
        }
    }else{
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        if ([[JSONDict valueForKey:@"ApplyLink"]length]>0) {
            
            appDelegate.stringATSJob = [JSONDict valueForKey:@"ApplyLink"];
        }else {
            
            appDelegate.stringATSJob = @"";
        }
        
        appDelegate.stringCompany = [JSONDict valueForKey:@"JobCompany"];
        labelJobTitle.text = [JSONDict objectForKey:@"JobTitle"];
        NSString *str = [JSONDict objectForKey:@"JobDecsription"];
        
        if ((NSNull *)str == [NSNull null]) {
            str = @"There is no description for this job.";
        }
        
        NSString *strFilter = [self stringByStrippingHTML:str];
        strFilter = [strFilter stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        strFilter = [strFilter stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        strFilter = [strFilter stringByReplacingOccurrencesOfString:@"\n" withString:@"\t"];
        descriptionString = [self stringByStrippingHTML:[self decodeHTMLEntities:str]];
        
        if ([descriptionString length]==0) {
            cellheight = 50;
        }else{
            if (IDIOM==IPAD) {
                CGSize size1 = [self findHeightForText:descriptionString havingWidth:768 andFont:[UIFont systemFontOfSize:17]];//(768 *1024
                
                if (size1.height < 100) {
                    cellheight = 100;
                }else{
                    cellheight = 150;
                }
            }else {
                CGSize size1 = [self findHeightForText:descriptionString havingWidth:320 andFont:[UIFont systemFontOfSize:14]];
                
                if (size1.height < 100) {
                    cellheight = 100;
                }else {
                    cellheight = 150;
                }
            }
        }
        [self GetShareURL];
        [tableViewJobDetails reloadData];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    NSString *output = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
    //    NSLog(@"height: %@", output);
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueEmployerDetailsFromJobDetails"]) {
        EmployerDetailsViewController *employerDetailsViewController = [segue destinationViewController];
        employerDetailsViewController.stringEmployerId = [JSONDict objectForKey:@"EmployerId"];
        employerDetailsViewController.stringEmpTitle = [JSONDict objectForKey:@"JobCompany"];
    }
    if ([segue.identifier isEqualToString:@"SegueApplyForJob"]) {
        ApplyForViewController *applyForVeiwController = [segue destinationViewController];
        applyForVeiwController.stringJobId = [JSONDict objectForKey:@"JobId"];
        applyForVeiwController.stringJobTitle = labelJobTitle.text;
    }
    if ([segue.identifier isEqualToString:@"SegueDirectApplyWithLogin"]) {
        ApplyProfileViewController *applyProfileViewController = [segue destinationViewController];
        applyProfileViewController.applyCondition = @"ApplyWithLogin";
    }
    if ([segue.identifier isEqualToString:@"SegueCreateJobDetails"]) {
        
        CreateProfileViewController *createProfileViewController = [segue destinationViewController];
        createProfileViewController.stringEmailIDCreateProfile = @"";
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.stringApplyWhileCreating = @"OnlyCreating";
    }
}

-(IBAction)buttonActionApply:(id)sender {
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
    }else {
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
            appDelegate.stringJobIdCreateProfile = stringJobId;
            
            flagCheckAlreadyApplied = TRUE;
            [self callWebServiceAlreadyApplied];
    
        }else {
            [self performSegueWithIdentifier:@"SegueApplyForJob" sender:self];
        }
        
//        }
    }
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
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringJobId,@"JobId",
                                                                            [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"memberid",
                                                                            [[NSUserDefaults standardUserDefaults]valueForKey:@"UserEmail"],@"email",nil];
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser7 parseSoapWithJSONSoapContents:dictToSend];
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
                flagForgotPasswordJobDetails = TRUE;
                jsonParser6 = [APParser sharedParser];
                jsonParser6.delegate = self;
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
                [jsonParser6 parseSoapWithJSONSoapContents:dictToSend];
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
