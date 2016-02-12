//
//  SavedJobsViewController.m
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "SavedJobsViewController.h"
#import "LoginViewController.h"
@interface SavedJobsViewController ()

@end

@implementation SavedJobsViewController
@synthesize buttonLogOff;
//MyProfileViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"User is already logged in with ID : %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBackgroundNotification:) name:@"BackgroundNotification" object:nil];
    //    [[NSUserDefaults standardUserDefaults]setObject:@"AvinashKumar" forKey:@"UserNameStandardDefault"];
    //    [[NSUserDefaults standardUserDefaults]setObject:@"4321" forKey:@"UserIdStandardDefault"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        jsonParser = [Parser sharedParser];
        jsonParser.delegate = self;
        [self callWebService];
    }else {
        //User is not logged in
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:YES completion:NULL];
        
        alertForLogin = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertForLogin show];
    }
}

- (void) receiveBackgroundNotification:(NSNotification *) notification {
    
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController {
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }else {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SavedJobsViewController *newVC = segue.destinationViewController;
    
    [SavedJobsViewController setPresentationStyleForSelfController:self presentingController:newVC];
}

- (IBAction)buttonActionLogOff:(id)sender {
    
    alertLogout = [[UIAlertView alloc]initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertLogout show];
}

- (IBAction)buttonAction:(id)sender {
    
    [self performSegueWithIdentifier:@"seguePopOver" sender:self];
}

#pragma mark AlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == alertLogout) {
        if (buttonIndex == 1) {
            [self.tabBarController setSelectedIndex:0];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SuceessStatus"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserId"];
        }else{
            
        }
    }
    if (alertView == alertForLogin) {
        
    }
}

#pragma mark Call web service
-(void)callWebService {
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    //[self.view setUserInteractionEnabled:NO];
    NSString* methodName = @"GetSavedJob";
    NSString* soapAction = @"http://tempuri.org/GetSavedJob";
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]);
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID", nil];
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:60];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice {
    [HUD hide:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict{
    
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    NSError *error;
    NSDictionary *JSONDict =
    [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    
    //    NSLog(@">>>%@",[[[JSONDict objectForKey:@"JobList"]objectAtIndex:0]valueForKey:@"Applied"]);
    
    if ([[JSONDict objectForKey:@"JobList"] count ]==0  ) {
        NSLog(@"empty");
    }
    
    //    Applied = 0;
    //    AppliedDate = "";
    //    Company = "Land O'Lakes";
    //    DateExpired = "13 May 2015 00:00:00";
    //    IsExpired = 0;
    //    JobID = 425144;
    //    JobTitle = "Regional EHS Manager";
    //    Location = "Neosho, Missouri";
    //    SavedOn = "16 Apr 2015 03:31:32";
}

@end
