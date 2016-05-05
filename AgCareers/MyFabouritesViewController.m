//
//  MyFabouritesViewController.m
//  AgCareers
//
//  Created by Unicorn on 17/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "MyFabouritesViewController.h"
#import "LoginPopOverViewController.h"
#import "JobDetailsViewController.h"
#import "EmployerDetailsViewController.h"
#import "SearchDetailViewController.h"
#import <Google/Analytics.h>
#import "CreateProfileViewController.h"
@interface MyFabouritesViewController ()

@end

@implementation MyFabouritesViewController
@synthesize segmentControllFavourites,tableViewEmployers,tableViewJobs,tableViewSearches;

@synthesize myView,textfieldPassword,textFieldUsername;

int selectedSegmentIndex            = 0;
BOOL flagJobs                       = FALSE;
BOOL flagEmpoloyer                  = FALSE;
BOOL flagSearches                   = FALSE;
BOOL flagDeleteJobs                 = FALSE;
BOOL flagDeleteEmployer             = FALSE;
BOOL flagDeleteSearches             = FALSE;
BOOL flagDelete                     = FALSE;
BOOL flagLoginMyFavoriteView        = FALSE;
BOOL flagForgotPasswordMyFavorites    = FALSE;
long slectedIndexPathDelete;
NSString *stringEmpId               = @"";
NSString *stringEmpTitle            = @"";
NSString *stringsearchID            = @"";
NSString *stringsearchTitle         = @"";
NSString *deleteIdjob;
NSString *deleteIdEmployer;
NSString *deleteIdSearches;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //flagJobs = TRUE;
    
    [tableViewJobs setHidden:FALSE];
    [tableViewEmployers setHidden:TRUE];
    [tableViewSearches setHidden:TRUE];
    
    arrayFavouriteJobs = [[NSMutableArray alloc]init];
    arrayFavouriteEmployer = [[NSMutableArray alloc]init];
    arrayFavouriteSearches = [[NSMutableArray alloc]init];
    [segmentControllFavourites setSelectedSegmentIndex:0];
    
    // Refresh control
    refreshControlJob = [[UIRefreshControl alloc]init];
    [tableViewJobs addSubview:refreshControlJob];
    [refreshControlJob addTarget:self action:@selector(refreshTabelViewJobs) forControlEvents:UIControlEventValueChanged];
    
    refreshControlEmployer = [[UIRefreshControl alloc]init];
    [tableViewEmployers addSubview:refreshControlEmployer];
    [refreshControlEmployer addTarget:self action:@selector(refreshTabelViewEmployer) forControlEvents:UIControlEventValueChanged];
    
    refreshControlSearches = [[UIRefreshControl alloc]init];
    [tableViewSearches addSubview:refreshControlSearches];
    [refreshControlSearches addTarget:self action:@selector(refreshTabelViewSearches) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidLayoutSubviews{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textFieldUsername resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    return YES;
}

- (void) keyboardWillShow:(NSNotification *)note {
    //     if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    //         heightForScrollView = 500;
    //     }else{
    //        heightForScrollView = 800;
    //     }
    
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    frame.origin.y = -50;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    
    //    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    //        heightForScrollView = 500;
    //    }else{
    //        heightForScrollView = 800;
    //    }
    //heightForScrollView = 500;
    
    // move the view back to the origin
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

-(void)refreshTabelViewJobs{
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
        flagJobs = TRUE;
        [self callWebService];
        [refreshControlJob endRefreshing];
        [tableViewJobs reloadData];
    }
}

-(void)refreshTabelViewEmployer{
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
        flagEmpoloyer = TRUE;
        [self callWebServiceEmpolyer];
        [refreshControlEmployer endRefreshing];
        [tableViewEmployers reloadData];
    }
}

-(void)refreshTabelViewSearches{
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
        flagSearches = TRUE;
        [self callWebServiceSearches];
        [refreshControlSearches endRefreshing];
        [tableViewSearches reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_act_2_a.png"]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = NO;
    
    
    [textFieldUsername setText:@""];
    [textfieldPassword setText:@""];
    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Favorite Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if  (arrayFavouriteJobs.count !=0){
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    if  (arrayFavouriteEmployer.count !=0){
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    if  (arrayFavouriteSearches.count !=0){
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        
        if ([[appDelegate.loginDetails valueForKey:@"loginCheck"]isEqualToString:@"firstlogin"]) {
            
        }else {
            appDelegate.loginCheck      = YES;
            [appDelegate.loginDetails setObject:@"firstlogin" forKey:@"loginCheck"];
            flagJobs = TRUE;
            
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
                
                [self callWebService];
                
            }
        }
        
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        
        [myView setHidden: YES];
    }else {
        
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [myView setHidden: NO];
        
        //comment this
        //[self performSegueWithIdentifier:@"logonSegueFromMyFavourites" sender:self];
    }
    
    /*
     if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
     [self callWebService];
     }else {
     if (self.tabBarController.selectedIndex == 1) {
     if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
     
     }else{
     [self performSegueWithIdentifier:@"logonSegueFromMyFavourites" sender:self];
     }
     }else{
     [self performSegueWithIdentifier:@"logonSegueFromMyFavourites" sender:self];
     }
     }
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tableViewJobs) {
        
        if ([arrayFavouriteJobs count]==0) {
            return 1;
        }else{
            return [arrayFavouriteJobs count];
        }
    }
    if (tableView == tableViewEmployers) {
        //return [arrayFavouriteEmployer count];
        
        if ([arrayFavouriteEmployer count]==0) {
            return 1;
        }else{
            return [arrayFavouriteEmployer count];
        }
    }
    if (tableView == tableViewSearches) {
        //        return [arrayFavouriteSearches count];
        if ([arrayFavouriteSearches count]==0) {
            return 1;
        }else{
            return [arrayFavouriteSearches count];
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tableViewJobs){
        
        if ([arrayFavouriteJobs count]==0) {
            return 60;
        }else {
            int appliedValue = [[[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"Applied"] intValue];
            if (appliedValue == 0) {
                return 80;
            }else{
                return 100;
            }
        }
        
    }
    if (tableView == tableViewEmployers) {
        return 80;
    }
    if (tableView == tableViewSearches) {
        return 80;
    }
    else{
        return 80;
    }
}

NSString *stringNoResult = @"";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == tableViewJobs) {
        if ([arrayFavouriteJobs count]==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = stringNoResult;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            return cell;
        }else {
            static NSString *jobCellIdentifier = @"cellJobs";
            UITableViewCell *cellJobs = [tableView dequeueReusableCellWithIdentifier:jobCellIdentifier];
            UILabel *labelTitle = (UILabel *)[cellJobs viewWithTag:4254];
            UILabel *labelCompanyName = (UILabel *)[cellJobs viewWithTag:4255];
            //UILabel *labelAddress = (UILabel *)[cellJobs viewWithTag:4256];
            UILabel *labelDays = (UILabel *)[cellJobs viewWithTag:4257];
            UILabel *labelapplied = (UILabel *)[cellJobs viewWithTag:4258];
            
            labelTitle.text = [[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"JobTitle"];
            labelCompanyName.text = [[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"Location"];
            //labelAddress.text = [[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"Company"];
            labelDays.text = [[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"DateExpired"];
            
            int appliedValue = [[[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"Applied"] intValue];
            
            
            UIButton *buttonCompany = (UIButton *)[cellJobs viewWithTag:425811];
            buttonCompany.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            buttonCompany.titleLabel.numberOfLines = 2;
            [buttonCompany setTitle:[[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"Company"] forState:UIControlStateNormal];
            //[[buttonCompany layer] setBorderWidth:1.0f];
            //[[buttonCompany layer] setBorderColor:[UIColor grayColor].CGColor];
            
            if ([[[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"isConfidential"]intValue]==1) {
                
            }else{
                UITapGestureRecognizer *singleFingerTap =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonActionCompany:)];
                [buttonCompany addGestureRecognizer:singleFingerTap];
            }
            if (appliedValue == 0) {
                labelapplied.text = @"";
            }else {
                labelapplied.text = [NSString stringWithFormat:@"✓ Applied on %@",[[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"AppliedDate"]];
            }
            return cellJobs;
        }
    }
    if (tableView == tableViewEmployers) {
        if ([arrayFavouriteEmployer count]==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = stringNoResult;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            return cell;
        }else{
            static NSString *jobCellIdentifier = @"cellEmployers";
            UITableViewCell *cellEmployer = [tableView dequeueReusableCellWithIdentifier:jobCellIdentifier];
            
            UILabel *labelTitle = (UILabel *)[cellEmployer viewWithTag:450];
            UILabel *labelCompanyName = (UILabel *)[cellEmployer viewWithTag:451];
            //UILabel *labelAddress = (UILabel *)[cellEmployer viewWithTag:452];
            if ([arrayFavouriteEmployer count]==0) {
                
            }else {
                labelTitle.text = [[arrayFavouriteEmployer objectAtIndex:indexPath.row]valueForKey:@"JobCompany"];
                labelCompanyName.text = [NSString stringWithFormat:@"%@ Current Jobs",[[arrayFavouriteEmployer objectAtIndex:indexPath.row]valueForKey:@"TotalJobs"]];
            }
            return cellEmployer;
        }
    }
    if (tableView == tableViewSearches) {
        if ([arrayFavouriteSearches count]==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = stringNoResult;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            return cell;
        }else{
            static NSString *searchedCellIdentifier = @"cellSearches";
            UITableViewCell *cellSearches = [tableView dequeueReusableCellWithIdentifier:searchedCellIdentifier];
            
            UILabel *labelTitle = (UILabel *)[cellSearches viewWithTag:6675];
            UILabel *labelCompanyName = (UILabel *)[cellSearches viewWithTag:6676];
            UILabel *labelAddress = (UILabel *)[cellSearches viewWithTag:6677];
            if ([arrayFavouriteSearches count]==0) {
                
            }else {
                if ([[[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"Title"] length]==0) {
                    labelTitle.text =@"Title";
                }else{
                    labelTitle.text =[NSString stringWithFormat:@"%@",[[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"Title"]];
                }
                labelCompanyName.text = [[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"CreatedOn"];
                if ([[[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"TotalJobs"] intValue] ==0) {
                    labelAddress.text = @"No Current Job";
                }else{
                    labelAddress.text = [NSString stringWithFormat:@"%@ Current Jobs",[[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"TotalJobs"]];
                }
            }
            
            return cellSearches;
        }
    }else {
        static NSString *jobCellIdentifier = @"cellEmployers";
        UITableViewCell *cellEmployer = [tableView dequeueReusableCellWithIdentifier:jobCellIdentifier];
        return cellEmployer;
    }
}

-(void)buttonActionCompany:(UITapGestureRecognizer *)recognizer {
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
        CGPoint location = [recognizer locationInView: tableViewJobs];
        NSIndexPath *indexP = [tableViewJobs indexPathForRowAtPoint:location];
        slectedIndexPathDelete = indexP.row;
        NSLog(@"%ld",(long)indexP.row);
        
        if ([[[arrayFavouriteJobs objectAtIndex:indexP.row]valueForKey:@"isConfidential"]intValue]==1) {
            
        }else{
            [self performSegueWithIdentifier:@"SegueEmployerFavouriteJobs" sender:self];
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
        if (tableView == tableViewJobs) {
            if ([arrayFavouriteJobs count]>0)
                [self performSegueWithIdentifier:@"SegueJobDetailsFromFavourite" sender:self];
        }
        if (tableView == tableViewEmployers) {
            if ([arrayFavouriteEmployer count]>0){
                stringEmpTitle = [[arrayFavouriteEmployer objectAtIndex:indexPath.row]valueForKey:@"JobCompany"];
                stringEmpId = [[arrayFavouriteEmployer objectAtIndex:indexPath.row]valueForKey:@"EmployerID"];
                [self performSegueWithIdentifier:@"SegueEmployerDetailsFromFabouriteTab" sender:self];
            }
        }
        if (tableView == tableViewSearches) {
            if ([arrayFavouriteSearches count]>0){
                stringsearchID = [[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"SavedSearchID"];
                stringsearchTitle = [[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"Title"];
                [self performSegueWithIdentifier:@"SegueSearchDetailFromFavourite" sender:self];
            }
        }
        
        //    if (tableView == tableViewJobs) {
        //        if ([arrayFavouriteJobs count]==0)
        //            return NO;
        //        else
        //            return YES;
        //    }else if (tableView == tableViewEmployers) {
        //
        //            return NO;
        //        else
        //            return YES;
        //    }else if (tableView == tableViewSearches) {
        //        if ([arrayFavouriteSearches count]==0)
        //            return NO;
        //        else
        //            return YES;
        //
        //    }else {
        //        return NO;
        //    }
    }
}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    //Even if the method is empty you should be seeing both rearrangement icon and animation.
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == tableViewJobs) {
        if ([arrayFavouriteJobs count]==0)
            return NO;
        else
            return YES;
    }else if (tableView == tableViewEmployers) {
        if ([arrayFavouriteEmployer count]==0)
            return NO;
        else
            return YES;
    }else if (tableView == tableViewSearches) {
        if ([arrayFavouriteSearches count]==0)
            return NO;
        else
            return YES;
        
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == tableViewJobs) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            deleteIdjob = [[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"JobID"];
            alertDeleteJobs = [[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure you want to delete this job?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertDeleteJobs show];
        }else {
            
        }
    }
    if (tableView == tableViewEmployers ) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            deleteIdEmployer = [[arrayFavouriteEmployer objectAtIndex:indexPath.row]valueForKey:@"EmployerID"];
            alertDeleteEmployer = [[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure you want to delete this employer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertDeleteEmployer show];
            
        }else {
            
        }
        
    }
    if (tableView == tableViewSearches ) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            deleteIdSearches = [[arrayFavouriteSearches objectAtIndex:indexPath.row]valueForKey:@"SavedSearchID"];
            alertDeleteSearches = [[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure you want to delete this search?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertDeleteSearches show];
            
        }else {
            
        }
    }
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertDeleteJobs) {
        if (buttonIndex == 1) {
            flagDeleteJobs = TRUE;
            NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"memberID",deleteIdjob,@"jobID",nil];
            [self deleteFavouritesWithMethodName:@"DeleteSavedJob" withDictionary:parameterDict];
        }
    }
    if (alertView == alertDeleteEmployer) {
        if (buttonIndex == 1) {
            flagDeleteEmployer = TRUE;
            NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"ApplicantID",deleteIdEmployer,@"EmployerID",nil];
            [self deleteFavouritesWithMethodName:@"DeleteFavouriteEmployer" withDictionary:parameterDict];
        }
    }
    if (alertView == alertDeleteSearches) {
        if (buttonIndex == 1) {
            flagDeleteSearches = TRUE;
            NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: deleteIdSearches,@"SavedSearchID",nil];
            [self deleteFavouritesWithMethodName:@"DeleteFavouriteSavedSearches" withDictionary:parameterDict];
        }
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
    }
    if (alertView == alertPromt) {
        
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
        if ([textFieldUsername text]>0) {
            if ([self NSStringIsValidEmail:[textFieldUsername text]]==TRUE) {
                flagForgotPasswordMyFavorites = TRUE;
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
                
                NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[textFieldUsername text],@"email",nil];
                
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

    [self performSegueWithIdentifier:@"SegueRegisterNowMyProfile" sender:self];
}

-(void)loginAction{
    
    NSString *stringTextFieldUserName = [textFieldUsername text];
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
            NSString *rawString = [textFieldUsername text];
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
                    flagLoginMyFavoriteView = TRUE;
                    jsonParser3 = [APParser sharedParser];
                    jsonParser3.delegate = self;
                    
                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.delegate = self;
                    HUD.labelText = @"Loading";
                    [HUD show:YES];
                    NSString* methodName = @"ValidateLogin";
                    NSString* soapAction = @"http://tempuri.org/ValidateLogin";
                    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[textFieldUsername text],@"userName",[textfieldPassword text],@"password", nil];
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

-(void)deleteFavouritesWithMethodName : (NSString *) deleteMethodName withDictionary : (NSDictionary *)myDictionary {
    flagDelete = TRUE;
    jsonParser334 = [APParser sharedParser];
    jsonParser334.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD5 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD5];
    HUD5.delegate = self;
    HUD5.labelText = @"Loading";
    [HUD5 show:YES];
    
    NSString* methodName = deleteMethodName;
    NSString* soapAction = [NSString stringWithFormat:@"http://tempuri.org/%@",deleteMethodName];//@"http://tempuri.org/GetSavedJob";
    
    NSDictionary* parameterDict = myDictionary;
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser334 parseSoapWithJSONSoapContents:dictToSend];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableViewJobs setEditing:editing animated:YES];
    [tableViewEmployers setEditing:editing animated:YES];
    [tableViewSearches setEditing:editing animated:YES];
    if (editing) {
        //addButton.enabled = NO;
    }else {
        //addButton.enabled = YES;
    }
}

#pragma mark LoginView delegate method
-(void)sendResult : (NSDictionary *) resultDictionary{
    //[self callWebService];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"logonSegueFromMyProfile"]) {
        LoginPopOverViewController *loginPopOverViewController = [segue destinationViewController];
        loginPopOverViewController.delegateLogin = self;
        
        MyFabouritesViewController *myfav = segue.destinationViewController;
        [MyFabouritesViewController setPresentationStyleForSelfController:self presentingController:myfav];
        
    }
    if ([segue.identifier isEqualToString:@"SegueJobDetailsFromFavourite"]) {
        JobDetailsViewController *jobDetailsViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [tableViewJobs indexPathForSelectedRow];
        jobDetailsViewController.stringJobId = [[arrayFavouriteJobs objectAtIndex:indexPath.row]valueForKey:@"JobID"];
    }
    if ([segue.identifier isEqualToString:@"SegueEmployerDetailsFromFabouriteTab"]) {
        EmployerDetailsViewController *employerDetailsViewController = [segue destinationViewController];
        employerDetailsViewController.stringEmpTitle = stringEmpTitle;
        employerDetailsViewController.stringEmployerId = stringEmpId;
    }
    if ([segue.identifier isEqualToString:@"logonSegueFromMyFavourites"]) {
        LoginPopOverViewController *loginPopOverViewController = [segue destinationViewController];
        loginPopOverViewController.delegateLogin = self;
        
        MyFabouritesViewController *myfav = segue.destinationViewController;
        [MyFabouritesViewController setPresentationStyleForSelfController:self presentingController:myfav];
    }
    if ([segue.identifier isEqualToString:@"SegueSearchDetailFromFavourite"]) {
        SearchDetailViewController *searchDetailViewController = [segue destinationViewController];
        searchDetailViewController.searchID = stringsearchID;
        searchDetailViewController.searchTitle = stringsearchTitle;
    }
    if ([segue.identifier isEqualToString:@"SegueEmployerFavouriteJobs"]) {
        EmployerDetailsViewController *employerDetailsViewController = [segue destinationViewController];
        employerDetailsViewController.stringEmpTitle = [[arrayFavouriteJobs objectAtIndex:slectedIndexPathDelete]valueForKey:@"Company"];
        employerDetailsViewController.stringEmployerId = [[arrayFavouriteJobs objectAtIndex:slectedIndexPathDelete]valueForKey:@"CompanyID"];
    }
    if ([segue.identifier isEqualToString:@"SegueRegisterNowMyProfile"]) {
        CreateProfileViewController *createProfileViewController = [segue destinationViewController];
        createProfileViewController.stringEmailIDCreateProfile = @"";
    }
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController {
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}


#pragma mark Call web service
-(void)callWebService {
    jsonParser33 = [APParser sharedParser];
    jsonParser33.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD1];
    HUD1.delegate = self;
    HUD1.labelText = @"Loading";
    [HUD1 show:YES];
    
    NSString* methodName = @"GetSavedJob";
    NSString* soapAction = @"http://tempuri.org/GetSavedJob";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",nil];
    
    //    NSString* methodName = @"Get_Report_VEAL_ONTARIO_DIRECT_TO_PACKER";
    //    NSString* soapAction = @"http://tempuri.org/Get_Report_VEAL_ONTARIO_DIRECT_TO_PACKER";
    //
    //    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: nil,nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser33 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceEmpolyer {
    jsonParser331 = [APParser sharedParser];
    jsonParser331.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD2 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD2];
    HUD2.delegate = self;
    HUD2.labelText = @"Loading";
    [HUD2 show:YES];
    
    NSString* methodName = @"GetFavouriteEmployerList";
    NSString* soapAction = @"http://tempuri.org/GetFavouriteEmployerList";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"ApplicantID",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser331 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceSearches {
    
    jsonParser332 = [APParser sharedParser];
    jsonParser332.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD3 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD3];
    HUD3.delegate = self;
    HUD3.labelText = @"Loading";
    [HUD3 show:YES];
    
    NSString* methodName = @"GetFavouriteSaveSearchesList";
    NSString* soapAction = @"http://tempuri.org/GetFavouriteSaveSearchesList";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"ApplicantID",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser332 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD1 hide:YES];
    [HUD2 hide:YES];
    [HUD3 hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    //[[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    [textFieldUsername resignFirstResponder];
    [textfieldPassword resignFirstResponder];
    
    if (flagJobs == TRUE) {
        flagJobs = FALSE;
        [HUD1 hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayFavouriteJobs = [JSONDict valueForKey:@"JobList"];
        
        if  (arrayFavouriteJobs.count !=0){
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }//
        stringNoResult = @"No saved jobs to display";
        [tableViewJobs reloadData];
    }
    if (flagEmpoloyer == TRUE) {
        flagEmpoloyer = FALSE;
        [HUD2 hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayFavouriteEmployer = [JSONDict valueForKey:@"EmployersList"];
        
        if  (arrayFavouriteEmployer.count !=0){
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        stringNoResult = @"No saved employer to display";
        [tableViewEmployers reloadData];
    }
    if (flagSearches == TRUE) {
        flagSearches = FALSE;
        
        [HUD3 hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        arrayFavouriteSearches = [JSONDict valueForKey:@"searchList"];
        
        if  (arrayFavouriteSearches.count !=0){
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        stringNoResult = @"No saved Searches to display";
        [tableViewSearches reloadData];
    }
    if (flagDelete == TRUE) {
        flagDelete = FALSE;
        [HUD5 hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        
        if (flagDeleteJobs==TRUE) {
            flagDeleteJobs = FALSE;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sucess" message:@"Deleted Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            flagJobs = TRUE;
            [self callWebService];
        }
        if (flagDeleteEmployer==TRUE) {
            flagDeleteEmployer = FALSE;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sucess" message:@"Deleted Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            flagEmpoloyer = TRUE;
            [self callWebServiceEmpolyer];
        }
        if (flagDeleteSearches==TRUE) {
            flagDeleteSearches = FALSE;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sucess" message:@"Deleted Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            flagSearches = TRUE;
            [self callWebServiceSearches];
        }
    }
    if (flagLoginMyFavoriteView == TRUE){
        [HUD hide:YES];
        flagLoginMyFavoriteView = FALSE;
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
            [myView setHidden:YES];
            flagJobs = TRUE;
            [self callWebService];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered an incorrect username/password and/or you are not approved to use the site.If you continue to have problems, please contact agcareers@agcareers.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (flagForgotPasswordMyFavorites == TRUE){
        flagForgotPasswordMyFavorites = FALSE;
        
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
    }
}

- (IBAction)segmentActionFavourites:(id)sender {
    selectedSegmentIndex = [segmentControllFavourites selectedSegmentIndex];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internateStatus = [reach currentReachabilityStatus];
    if ((internateStatus != ReachableViaWiFi) && (internateStatus != ReachableViaWWAN)){
        /// Create an alert if connection doesn't work
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You must be online for the app to function." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [myAlert show];
    }
    else{
        if (selectedSegmentIndex == 0) {
            flagJobs = TRUE;
            [tableViewJobs setHidden:FALSE];
            [tableViewEmployers setHidden:TRUE];
            [tableViewSearches setHidden:TRUE];
            [self callWebService];
            segmentCount =0;
        }
        if (selectedSegmentIndex ==1) {
            flagEmpoloyer = TRUE;
            
            [tableViewJobs setHidden:TRUE];
            [tableViewEmployers setHidden:FALSE];
            [tableViewSearches setHidden:TRUE];
            [self callWebServiceEmpolyer];
        }
        if (selectedSegmentIndex ==2) {
            flagSearches = TRUE;
            [self callWebServiceSearches];
            [tableViewJobs setHidden:TRUE];
            [tableViewEmployers setHidden:TRUE];
            [tableViewSearches setHidden:FALSE];
        }
    }
}

- (IBAction)buttonActionLoginOnView:(id)sender {
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
        //        alertLogin =[[UIAlertView alloc ] initWithTitle:@"Login" message:@"Enter Username & Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        //        alertLogin.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        //        [alertLogin textFieldAtIndex:0].placeholder = @"Username";
        //        [alertLogin addButtonWithTitle:@"Login"];
        //        [alertLogin addButtonWithTitle:@"Forgot Password?"];
        //        [alertLogin show];
        [self loginAction];
        //[self performSegueWithIdentifier:@"logonSegueFromMyFavourites" sender:self];
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

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertCommon = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertCommon show];
}


- (IBAction)buttonActionForgotPassword:(id)sender {
    [self forgotPassword];
}
@end