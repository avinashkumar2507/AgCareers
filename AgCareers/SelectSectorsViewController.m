//
//  SelectSectorsViewController.m
//  AgCareers
//
//  Created by Unicorn on 17/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "SelectSectorsViewController.h"
#import "SearchViewController.h"
@interface SelectSectorsViewController ()

// A simple array of strings for the data model.
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SelectSectorsViewController
@synthesize dataArray,tableViewSectors,buttonCancel,buttonDone;
@synthesize delegateSectors;
@synthesize stringValues,stringId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.tabBarController selectedIndex]==1) {
        newArray = [[NSMutableArray alloc]init];
        newArrayId = [[NSMutableArray alloc]init];
        
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
    }
    
    if ([self.tabBarController selectedIndex]==0) {
        newArray = [[NSMutableArray alloc]init];
        newArrayId = [[NSMutableArray alloc]init];
        
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
    }

    //    self.navigationController.view.backgroundColor = [UIColor clearColor];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    jsonParser = [Parser sharedParser];
    jsonParser.delegate = self;
    [self callWebService];
    [tableViewSectors setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
    //dataArray = [NSMutableArray new];
    NSString *itemFormatString = NSLocalizedString(@"Item %d", @"Format string for item");
    //    for (unsigned int itemNumber = 1; itemNumber <= 12; itemNumber++) {
    //        NSString *itemName = [NSString stringWithFormat:itemFormatString, itemNumber];
    //        //[self.dataArray addObject:itemName];
    //    }
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
        if ([self.tabBarController selectedIndex]==1) {//[self.tabBarController selectedIndex]==0
            [newArray removeObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
            NSString *strId = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"];
            [newArrayId removeObject:strId];
        }
        if ([self.tabBarController selectedIndex]==0) {//
            [newArray removeObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
            NSString *strId = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"];
            [newArrayId removeObject:strId];
        }
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
        if ([self.tabBarController selectedIndex]==1) {//[self.tabBarController selectedIndex]==0
            [newArray addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
            [newArrayId addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]];
        }
        if ([self.tabBarController selectedIndex]==0) {//[self.tabBarController selectedIndex]==0
            [newArray addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"]];
            [newArrayId addObject:[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]];
        }
        [self updateButtonsToMatchTableState];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure a cell to show the corresponding string from the array.
    // Configure a cell to show the corresponding string from the array.
    if ([self.tabBarController selectedIndex]==1) {
        static NSString *kCellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3471];
        newLabel.text = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"];//CategoryID
        
        for (int i = 0; i<[newArrayId count]; i++) {
            NSString *str = [newArrayId objectAtIndex:i];
            if ([[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]isEqualToString:str] ) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                //[cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        return cell;
        
    }
    if ([self.tabBarController selectedIndex]==0) {
        static NSString *kCellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3471];
        newLabel.text = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"];//CategoryID
        
        for (int i = 0; i<[newArrayId count]; i++) {
            NSString *str = [newArrayId objectAtIndex:i];
            if ([[[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryID"]isEqualToString:str] ) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else{
                //[cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        return cell;
        
    }
    
    else{
        static NSString *kCellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3471];
        newLabel.text = [[[JSONDict valueForKey:@"CategorysList"]objectAtIndex:indexPath.row]valueForKey:@"CategoryName"];//CategoryID
        
        //cell.textLabel.text =
        
        return cell;
    }    /*  pre selected cell
          
          NSInteger anIndex = [self.dataArray indexOfObject:@"Item 3"];
          if ([[self.dataArray objectAtIndex:indexPath.row]isEqualToString:@"Item 3"] ) {
          [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
          [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
          }else{
          [cell setAccessoryType:UITableViewCellAccessoryNone];
          }
          */
}


#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState {
    
    if (tableViewSectors.editing) {
        //         Show the option to cancel the edit.
        self.navigationItem.rightBarButtonItem = buttonDone;
        //
        [self updateDeleteButtonTitle];
        //
        //        // Show the delete button.
        self.navigationItem.leftBarButtonItem = buttonCancel;
    }
    else {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDeleteButtonTitle {
    
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [tableViewSectors indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected) {
        //        self.deleteButton.title = NSLocalizedString(@"Delete All", @"");
    }
    else {
        //        NSString *titleFormatString =
        //        NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
        //        self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)buttonActionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

NSMutableDictionary *dataDictionary;

- (IBAction)buttonActionDone:(id)sender {
    NSArray *selectedRows = [tableViewSectors indexPathsForSelectedRows];
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
    
    if ([self.tabBarController selectedIndex]==1) {
        [dataDictionary setObject:newArrayId forKey:@"arraySectorIds"];
        [dataDictionary setObject:newArray forKey:@"arraySectorName"];
        //    SearchViewController *searchViewController = [[SearchViewController alloc]init];
        //    searchViewController.arraySectors = arraySelected;
        [delegateSectors sendSectorDictionary:dataDictionary ];
        
    }else{
        [dataDictionary setObject:arraySelected forKey:@"arraySectorIds"];
        [dataDictionary setObject:arrayNames forKey:@"arraySectorName"];
        //    SearchViewController *searchViewController = [[SearchViewController alloc]init];
        //    searchViewController.arraySectors = arraySelected;
        [delegateSectors sendSectorDictionary:dataDictionary ];
    }
    
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
    
    NSString* methodName = @"GetIndustrySectors";
    NSString* soapAction = @"http://tempuri.org/GetIndustrySectors";
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]);
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil];
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
    //NSArray* contents = [JSONDict valueForKey:@"CategorysList"];
    [tableViewSectors reloadData];
}

@end
