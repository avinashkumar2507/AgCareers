
//
//  SearchDetailViewController.m
//  AgCareers
//
//  Created by Unicorn on 24/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "JobDetailsViewController.h"
#import "SearchEditViewController.h"
#import <Google/Analytics.h>
@interface UILabel (Boldify)
- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;
@end

@implementation UILabel (Boldify)
- (void)boldRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    self.attributedText = attributedText;
}

- (void)boldSubstring:(NSString*)substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

@end

@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController
@synthesize labelCountry,labelIndustorySector,labelIndustryType,labelRegion,labelState,labelTitle,lableCareersType,tableSearches;
@synthesize searchID,searchTitle,labelCurrentJobs;

NSString *strIndustrySector     = @"";
NSString *strIndustryTypes      = @"";
NSString *strCarrersType        = @"";
NSString *strCountry            = @"";
NSString *strRegion             = @"";
NSString *strState              = @"";
NSString *stringJobIDs          = @"";
BOOL flagdeleteSearch           = FALSE;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strIndustrySector     = @"";
    strIndustryTypes      = @"";
    strCarrersType        = @"";
    strCountry            = @"";
    strRegion             = @"";
    strState              = @"";
    stringJobIDs          = @"";
    
    
    backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_ar.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonActionBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    editButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"EditPp.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonActionEdit)];
    removeButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TrashPp.png"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonActionRemove)];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:editButton,removeButton, nil];
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    arrayJobsListing = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Search Criteria Details Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        if (self.tabBarController.selectedIndex == 1) {
            [self callWebService];
        }else{
            
        }
    }else {
        //User is not logged in
        [self.navigationController popViewControllerAnimated:YES];
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:NO completion:NULL];
    }
}

-(void)buttonActionBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonActionEdit{
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
        [self performSegueWithIdentifier:@"SegueSearchEdit" sender:self];
    }
}

-(void)buttonActionRemove{
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
        alertForDelete = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Are you sure you want to delete this search?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertForDelete show];
        
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
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellSearchesID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    UILabel *labelTitle = (UILabel *)[cell viewWithTag:651];
    UILabel *labelLocation = (UILabel *)[cell viewWithTag:652];
    UILabel *labelCompany = (UILabel *)[cell viewWithTag:653];
    UILabel *labelExpirationDate = (UILabel *)[cell viewWithTag:654];
    labelTitle.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"JobTitle"];
    labelLocation.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"Location"];
    labelCompany.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"Company"];
    labelExpirationDate.text = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"Dateexpire"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    stringJobIDs = [[arrayJobsListing objectAtIndex:indexPath.row]valueForKey:@"JobID"];
    [self performSegueWithIdentifier:@"SegueJobDetailsFromSearches" sender:self ];
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
    
    NSString* methodName = @"GetFavouriteSaveSearchDetails";
    NSString* soapAction = @"http://tempuri.org/GetFavouriteSaveSearchDetails";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: searchID,@"SaveSearchID",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:60];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice {
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self hideHUDandWebservice];
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertForNoDetails) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView == alertForDelete) {
        if (buttonIndex == 1) {
            flagdeleteSearch = TRUE;
            [self callDeleteWebservice];
        }
    }
    if (alertView == alertDeleteSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)callDeleteWebservice{
    jsonParser1 = [APParser sharedParser];
    jsonParser1.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD1];
    HUD1.delegate = self;
    HUD1.labelText = @"Loading";
    [HUD1 show:YES];
    
    NSString* methodName = @"DeleteFavouriteSavedSearches";
    NSString* soapAction = @"http://tempuri.org/DeleteFavouriteSavedSearches";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: searchID,@"SavedSearchID",nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:30];
    [jsonParser1 parseSoapWithJSONSoapContents:dictToSend];
}

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    
    if (successBool == YES) {
        if (flagdeleteSearch == TRUE) {
            flagdeleteSearch = FALSE;
            [HUD1 hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
                alertDeleteSuccess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Deleted Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertDeleteSuccess show];
            }else{
                alertDeleteFail = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertDeleteFail show];
            }
            
        }else{
            if (successBool == NO) {
                [HUD hide:YES];
                [self.tabBarController.view setUserInteractionEnabled:YES];
                alertForNoDetails = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertForNoDetails show];
            }else{
                [HUD hide:YES];
                [self.tabBarController.view setUserInteractionEnabled:YES];
                NSError *error;
                JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                           options: NSJSONReadingMutableContainers
                                                             error: &error];
                
                if ([[JSONDict valueForKey:@"ErrorMsg"] isEqualToString:@"No Records Found"]) {
                    alertForNoDetails = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No Records Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertForNoDetails show];
                }else{
                    labelTitle.text = searchTitle;
                    if ([searchTitle length]>0) {
                        labelTitle.text =  searchTitle;
                    }else {
                        labelTitle.text = @"";
                    }
                    if ([[JSONDict valueForKey:@"IndustrySector"] length]>0) {
                        strIndustrySector = [JSONDict valueForKey:@"IndustrySector"];
                        strIndustrySector = [strIndustrySector substringToIndex:strIndustrySector.length-(strIndustrySector.length>0)];
                        labelIndustorySector.text =  [NSString stringWithFormat:@"Industry Sector: %@",[strIndustrySector stringByReplacingOccurrencesOfString:@"#" withString:@","]];
                        [labelIndustorySector boldSubstring: @"Industry Sector:"];
                    }else {
                        labelIndustorySector.text = @"";
                    }
                    if ([[JSONDict valueForKey:@"IndustryType"] length]>0) {
                        strIndustryTypes = [JSONDict valueForKey:@"IndustryType"];
                        strIndustryTypes = [strIndustryTypes substringToIndex:strIndustryTypes.length-(strIndustryTypes.length>0)];
                        labelIndustryType.text =  [NSString stringWithFormat:@"Industry Type: %@",[strIndustryTypes stringByReplacingOccurrencesOfString:@"#" withString:@","]];
                        [labelIndustryType boldSubstring: @"Industry Type:"];
                    }else {
                        labelIndustryType.text = @"";
                    }
                    if ([[JSONDict valueForKey:@"CareersType"] length]>0) {
                        strCarrersType = [JSONDict valueForKey:@"CareersType"];
                        strCarrersType = [strCarrersType substringToIndex:strCarrersType.length-(strCarrersType.length>0)];
                        lableCareersType.text =  [NSString stringWithFormat:@"Carrers Type: %@",[strCarrersType stringByReplacingOccurrencesOfString:@"#" withString:@","]];
                        [lableCareersType boldSubstring: @"Carrers Type:"];
                    }else {
                        lableCareersType.text = @"";
                    }
                    if ([[JSONDict valueForKey:@"Countrys"] length]>0) {
                        strCountry = [JSONDict valueForKey:@"Countrys"];
                        labelCountry.text =  [NSString stringWithFormat:@"Country: %@",[strCountry  stringByReplacingOccurrencesOfString:@"#" withString:@","]];
                        [labelCountry boldSubstring: @"Country:"];
                    }else{
                        
                        labelCountry.text = @"";
                    }
                    if ([[JSONDict valueForKey:@"Regions"] length]>0) {
                        strRegion = [JSONDict valueForKey:@"Regions"];
                        
                        labelRegion.text =  [NSString stringWithFormat:@"Region: %@",[strRegion stringByReplacingOccurrencesOfString:@"#" withString:@","]];
                        [labelRegion boldSubstring: @"Region:"];
                    }else{
                        labelRegion.text = @"";
                    }
                    if ([[JSONDict valueForKey:@"States"] length]>0) {
                        strState = [JSONDict valueForKey:@"States"];
                        //strState = [strState substringToIndex:strState.length-(strState.length>0)];
                        labelState.text =  [NSString stringWithFormat:@"State: %@",[strState stringByReplacingOccurrencesOfString:@"#" withString:@","]];
                        [labelState boldSubstring: @"State:"];
                    }else {
                        labelState.text = @"";
                    }
                    
                    arrayJobsListing = [JSONDict valueForKey:@"JobsList"];
                    if ([arrayJobsListing count]>0) {
                        labelCurrentJobs.text = @"Current Jobs Listings";
                    }else {
                        labelCurrentJobs.text = @"No current Jobs";
                    }
                    [tableSearches reloadData];
                }
            }
        }
        
    }else{ //if (successBool == YES) {
        [HUD hide:YES];
        [HUD1 hide:YES];
        UIAlertView *alertSuccessStatus = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSuccessStatus show];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueJobDetailsFromSearches"]) {
        JobDetailsViewController *jobDetailsViewController = [segue destinationViewController];
        jobDetailsViewController.stringJobId = stringJobIDs;
    }
    if ([segue.identifier isEqualToString:@"SegueSearchEdit"]) {
        
        NSString *strIndSector = [JSONDict valueForKey:@"IndustrySectorIds"];
        NSString *strIndType = [JSONDict valueForKey:@"IndustryTypeIds"];
        NSString *strCarType = [JSONDict valueForKey:@"CareersTypeIds"];
        strIndSector = [strIndSector substringToIndex:strIndSector.length-(strIndSector.length>0)];
        strIndType = [strIndType substringToIndex:strIndType.length-(strIndType.length>0)];
        strCarType = [strCarType substringToIndex:strCarType.length-(strCarType.length>0)];
        
        SearchEditViewController *searchEditViewController = [segue destinationViewController];
        searchEditViewController.stringIndustrySector = strIndustrySector;
        searchEditViewController.stringIndustryType = strIndustryTypes;
        searchEditViewController.stringCarrersType = strCarrersType;
        searchEditViewController.stringCountry = strCountry;
        searchEditViewController.stringRegion = strRegion;
        searchEditViewController.stringState = strState;
        searchEditViewController.stringTitle = searchTitle;
        searchEditViewController.stringLocation = [JSONDict valueForKey:@"Location"];
        searchEditViewController.stringKeword = [JSONDict valueForKey:@"Keyword"];
        searchEditViewController.stringIndustrySectorId = strIndSector;
        searchEditViewController.stringIndustryTypeId = strIndType;
        searchEditViewController.stringCarrersTypeId = strCarType;
        searchEditViewController.stringEmployerId = [JSONDict valueForKey:@"EmployerID"];
        searchEditViewController.stringSearchId = [JSONDict valueForKey:@"SavedSearchID"];
        searchEditViewController.stringEmployerName = [JSONDict valueForKey:@"EmployerName"];
        if ([[JSONDict valueForKey:@"CountryIds"] length]>0 ) {
            searchEditViewController.stringCountryId = [JSONDict valueForKey:@"CountryIds"];
        }else{
            searchEditViewController.stringCountryId = @"0";
        }
        
        if ([[JSONDict valueForKey:@"RegionIds"] length] >0) {
            searchEditViewController.stringRegionId = [JSONDict valueForKey:@"RegionIds"];
        }else{
            searchEditViewController.stringRegionId = @"0";
        }
        
        searchEditViewController.stringStateId = [JSONDict valueForKey:@"StateIds"];
        
    }
}

@end