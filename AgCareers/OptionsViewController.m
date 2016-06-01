//
//  OptionsViewController.m
//  AgCareers
//
//  Created by Unicorn on 23/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "OptionsViewController.h"
#import "MyProfileViewController.h"
@interface OptionsViewController ()

@end

@implementation OptionsViewController
@synthesize tableViewOptions,buttonCancel,buttonDone;
@synthesize methodNameString,delegateOptions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self callWebService];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_act_2_a.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [[NSUserDefaults standardUserDefaults]setValue:@"44" forKey:@"numberOfExperience"];
        //SearchViewController *searchViewController = [[SearchViewController alloc]init];
        //searchViewController.arraySectors = arraySelected;
        //[delegateSectors sendSectorDictionary:dataDictionary ];
        [delegateOptions sendSectorDictionary:@"1 Year"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure a cell to show the corresponding string from the array.
    static NSString *myCellID = @"cellOptions";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    cell.textLabel.text = [[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"Name"];
    
    return cell;
}
- (IBAction)buttonActionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

NSMutableDictionary *dataDictionary;

- (IBAction)buttonActionDone:(id)sender {
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
        NSArray *selectedRows = [tableViewOptions indexPathsForSelectedRows];
        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in selectedRows) {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
        }
        
        NSMutableArray *arraySelected = [[NSMutableArray alloc]init];
        NSMutableArray *arrayNames = [[NSMutableArray alloc]init];
        
        dataDictionary = [[NSMutableDictionary alloc]init];
        for (NSIndexPath *selectionIndex in selectedRows) {
            [arraySelected addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:selectionIndex.row]valueForKey:@"CategoryID"]];
            [arrayNames addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:selectionIndex.row]valueForKey:@"CategoryName"]];
        }
        [dataDictionary setObject:arraySelected forKey:@"arraySectorIds"];
        [dataDictionary setObject:arrayNames forKey:@"arraySectorName"];
        //SearchViewController *searchViewController = [[SearchViewController alloc]init];
        //searchViewController.arraySectors = arraySelected;
        //[delegateSectors sendSectorDictionary:dataDictionary ];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Call web service
-(void)callWebService {
    jsonParser111 = [APParser sharedParser];
    jsonParser111.delegate = self;
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = methodNameString;//@"GetExperiences";
    NSString* soapAction = [NSString stringWithFormat:@"http://tempuri.org/%@",methodNameString]; //@"http://tempuri.org/GetExperiences";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: nil,nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser111 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    [[Parser sharedParser]connectionCancel];
}

-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool{
    if (successBool == YES) {
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        [tableViewOptions reloadData];
    }else{ //if (successBool == YES) {
        [HUD hide:YES];
        
        UIAlertView *alertSuccessStatus = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSuccessStatus show];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}


//#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    MyProfileViewController *myProfileViewController = [segue destinationViewController];
//    myProfileViewController.stringNumberOfExperience = @"1 Year";
//}


@end
