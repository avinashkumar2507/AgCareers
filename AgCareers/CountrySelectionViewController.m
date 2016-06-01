//
//  CountrySelectionViewController.m
//  AgCareers
//
//  Created by Unicorn on 06/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "CountrySelectionViewController.h"

@interface CountrySelectionViewController ()

@end

@implementation CountrySelectionViewController
@synthesize delegateCountry,tableVeiwCountry;
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self callWebServiceCountry];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        
        [self callWebServiceCountry];
        
    }else {
        //User is not logged in
        [self.navigationController popViewControllerAnimated:YES];
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginStoryboardId"];
        //        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:vc animated:NO completion:NULL];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[JSONDict valueForKey:@"Rows"]count];
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
        NSMutableArray *arraySelected = [[NSMutableArray alloc]init];
        NSMutableArray *arrayNames = [[NSMutableArray alloc]init];
        dataDictionary = [[NSMutableDictionary alloc]init];
        [arraySelected addObject:[[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"ID"]];
        [arrayNames addObject:[[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"Name"]];
        [dataDictionary setObject:arraySelected forKey:@"arrayTypeIds"];
        [dataDictionary setObject:arrayNames forKey:@"arrayTypeName"];
        
        [delegateCountry sendCountryDictionary:dataDictionary];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure a cell to show the corresponding string from the array.
    static NSString *kCellID = @"cellCountry";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    UILabel *newLabel = (UILabel *)[cell viewWithTag:3474];
    newLabel.text = [[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"Name"];
    //cell.textLabel.text = [[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"Name"];
    return cell;
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
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: nil,nil];
    
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
    if (successBool == YES) {
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        //NSArray* contents = [JSONDict valueForKey:@"CategorysList"];
        [tableVeiwCountry reloadData];
    }else{ //if (successBool == YES) {
        [HUD hide:YES];
        
        UIAlertView *alertSuccessStatus = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSuccessStatus show];
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

@end
