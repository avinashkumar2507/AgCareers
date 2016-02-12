//
//  EditIndustrySectorViewController.m
//  AgCareers
//
//  Created by Unicorn on 30/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "EditIndustrySectorViewController.h"

@interface EditIndustrySectorViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation EditIndustrySectorViewController
@synthesize delegateStates,tableViewEditIndustry,buttonCancel,buttonDone;
@synthesize stringCountryId,stringRegionId;

NSMutableDictionary *dataDictionary;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    jsonParser = [Parser sharedParser];
    //    jsonParser.delegate = self;
    //    [self callWebService];
    [tableViewEditIndustry setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
    [self updateButtonsToMatchTableState];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        // User is already logged in
        jsonParser = [Parser sharedParser];
        jsonParser.delegate = self;
        [self callWebService];
        
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark Call web service
-(void)callWebService {
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetStates";
    NSString* soapAction = @"http://tempuri.org/GetStates";
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:stringCountryId,@"countryid",stringRegionId,@"regionid", nil];
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
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
-(void)receiveJsonResponse:(NSDictionary*)responseDict{
    
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
    NSError *error;
    JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                               options: NSJSONReadingMutableContainers
                                                 error: &error];
    
    [tableViewEditIndustry reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[JSONDict valueForKey:@"Rows"] count];
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
    }
    else{
        [self updateButtonsToMatchTableState];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure a cell to show the corresponding string from the array.
    static NSString *kCellID = @"cellIndustrySector";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    UILabel *newLabel = (UILabel *)[cell viewWithTag:3475];
    newLabel.text = [[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"Name"];//CategoryID
    
    //cell.textLabel.text = [[[JSONDict valueForKey:@"Rows"]objectAtIndex:indexPath.row]valueForKey:@"Name"];//CategoryID
    return cell;
}

#pragma mark - Updating button state
- (void)updateButtonsToMatchTableState {
    
    if (tableViewEditIndustry.editing) {
        //         Show the option to cancel the edit.
        self.navigationItem.rightBarButtonItem = buttonDone;
        //
        [self updateDeleteButtonTitle];
        //
        //        // Show the delete button.
        self.navigationItem.leftBarButtonItem = buttonCancel;
    }else {
        // Not in editing mode.
        //        self.navigationItem.leftBarButtonItem = self.addButton;
        //
        //        // Show the edit button, but disable the edit button if there's nothing to edit.
        //        if (self.dataArray.count > 0)
        //        {
        //            self.editButton.enabled = YES;
        //        }
        //        else
        //        {
        //            self.editButton.enabled = NO;
        //        }
        //        self.navigationItem.rightBarButtonItem = self.editButton;
    }
}

- (void)updateDeleteButtonTitle {
    
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [tableViewEditIndustry indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected) {
        //        self.deleteButton.title = NSLocalizedString(@"Delete All", @"");
    }else {
        //        NSString *titleFormatString =
        //        NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
        //        self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}

- (IBAction)buttonActionDone:(id)sender {
    
    NSArray *selectedRows = [tableViewEditIndustry indexPathsForSelectedRows];
    NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
    for (NSIndexPath *selectionIndex in selectedRows) {
        [indicesOfItemsToDelete addIndex:selectionIndex.row];
    }
    
    NSMutableArray *arraySelected = [[NSMutableArray alloc]init];
    NSMutableArray *arrayNames = [[NSMutableArray alloc]init];
    
    dataDictionary = [[NSMutableDictionary alloc]init];
    for (NSIndexPath *selectionIndex in selectedRows) {
        [arraySelected addObject:[[[JSONDict valueForKey:@"Rows"]objectAtIndex:selectionIndex.row]valueForKey:@"ID"]];
        [arrayNames addObject:[[[JSONDict valueForKey:@"Rows"]objectAtIndex:selectionIndex.row]valueForKey:@"Name"]];
    }
    
    [dataDictionary setObject:arraySelected forKey:@"arrayTypeIds"];
    [dataDictionary setObject:arrayNames forKey:@"arrayTypeName"];
    
    [delegateStates sendStatesDictionary:dataDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonActionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
