//
//  IndustryAndCareerViewController.m
//  AgCareers
//
//  Created by Unicorn on 09/11/15.
//  Copyright © 2015 VLWebtek. All rights reserved.
//

#import "IndustryAndCareerViewController.h"

@interface IndustryAndCareerViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

// CellIndustryCareer //7105

@implementation IndustryAndCareerViewController
@synthesize buttonCancel,buttonDone,tableViewIndustryCareer;
@synthesize delegateIndustryCareerProtocol;
@synthesize stringValues,stringId,stringTitle;
@synthesize dataArray;
@synthesize stringWSName;
- (void)viewDidLoad {
    [super viewDidLoad];
    newArray = [[NSMutableArray alloc]init];
    newArrayId = [[NSMutableArray alloc]init];
    self.title = stringTitle;
    if ([stringValues length]>0) {
        arrayValues = [stringValues componentsSeparatedByString:@","];
    }
    if ([stringId length]>0) {
        arrayId = [stringId componentsSeparatedByString:@","];
    }
    for (int i = 0; i<[arrayValues count]; i++) {
        NSString *str = [arrayValues objectAtIndex:i];
        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@","];
        [newArray addObject:str];
    }
    for (int i = 0; i<[arrayId count]; i++) {
        [newArrayId addObject:[arrayId objectAtIndex:i]];
    }
    jsonParser = [Parser sharedParser];
    jsonParser.delegate = self;
    [self callWebService];
    [tableViewIndustryCareer setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_act_2_a.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[JSONDict valueForKey:@"CategorysList"] count];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        [newArray removeObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
        NSString *strId = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"];
        [newArrayId removeObject:strId];
        [self updateDeleteButtonTitle];
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
    }else {
        if ([newArray count]<=4) {
            [newArray addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
            [newArrayId addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]];
            [self updateButtonsToMatchTableState];
        }else{
            [tableViewIndustryCareer deselectRowAtIndexPath:indexPath animated:NO];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You can select a maximum of five types" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"CellIndustryCareer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    UILabel *newLabel = (UILabel *)[cell viewWithTag:7105];
    newLabel.text = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"];//CategoryID
    
    for (int i = 0; i<[newArrayId count]; i++) {
        NSString *str = [newArrayId objectAtIndex:i];
        if ([[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]isEqualToString:str] ) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
        }
    }
    return cell;
}


#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState {
    
    if (tableViewIndustryCareer.editing) {
        self.navigationItem.rightBarButtonItem = buttonDone;
        [self updateDeleteButtonTitle];
        self.navigationItem.leftBarButtonItem = buttonCancel;
    }
    else {

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateDeleteButtonTitle {
    
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [tableViewIndustryCareer indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)buttonActionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

NSMutableDictionary *dataDictionary;

- (IBAction)buttonActionDone:(id)sender {
    NSArray *selectedRows = [tableViewIndustryCareer indexPathsForSelectedRows];
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
    
    [dataDictionary setObject:newArrayId forKey:@"arraySectorIds"];
    [dataDictionary setObject:newArray forKey:@"arraySectorName"];
    [delegateIndustryCareerProtocol sendIndustryCareerDictionary:dataDictionary ];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Call web service
-(void)callWebService {
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    if ([stringWSName isEqualToString:@"GetCareerTypes"]) {
        NSString* methodName = @"GetCareerTypes";
        NSString* soapAction = @"http://tempuri.org/GetCareerTypes";
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil];
        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
        
        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
        [jsonParser parseSoapWithJSONSoapContents:dictToSend];
    }
    if ([stringWSName isEqualToString:@"GetIndustryTypes"]) {
        NSString* methodName = @"GetIndustryTypes";
        NSString* soapAction = @"http://tempuri.org/GetIndustryTypes";
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil];
        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
        
        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
        [jsonParser parseSoapWithJSONSoapContents:dictToSend];
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

#pragma mark response
-(void)receiveJsonResponse:(NSDictionary*)responseDict{
    
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    NSError *error;
    JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                               options: NSJSONReadingMutableContainers
                                                 error: &error];
    //NSArray* contents = [JSONDict valueForKey:@"CategorysList"];
    [tableViewIndustryCareer reloadData];
}

@end
