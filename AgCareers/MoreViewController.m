//
//  MoreViewController.m
//  AgCareers
//
//  Created by Unicorn on 24/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "MoreViewController.h"
#import "WebDetailsViewController.h"
#import <MessageUI/MessageUI.h>
@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize tableViewMore;

NSString *strURL;
NSString *strTitleName = @"";

int numberOfRows;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"])
        numberOfRows = 6;
    else
        numberOfRows = 5;
    
    [tableViewMore reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {//SegueCreateProfileFromMore
    return numberOfRows;
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

-(void)showAlertSucess{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Email sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showAlertFailure{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some error occured while sending email. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        if (indexPath.row == 0) {

            
            NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
            NSString *webServiceString = [dictRoot objectForKey:@"MorePage"];
            NSString *stringURL = [NSString stringWithFormat:@"%@about-us.cfm",[[NSUserDefaults standardUserDefaults] valueForKey:@"MorePageURL"]];
            
            strURL = stringURL;
            strTitleName = @"About Us";
            [self performSegueWithIdentifier:@"SegueDetailsFromMore" sender:self];
            
        }
        if (indexPath.row == 1) {
            
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setToRecipients:[[NSArray alloc]initWithObjects:@"agcareers@agcareers.com", nil] ];// agcareers@agcareers.com
                [mailViewController setSubject:@""];
                [mailViewController setMessageBody:@"" isHTML:YES];
                [self presentViewController:mailViewController animated:YES completion:nil];
            }
        }
        if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"SegueNewsletterFromMore" sender:self];
        }
        if (indexPath.row == 3) {
            
            NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
            NSString *webServiceString = [dictRoot objectForKey:@"MorePage"];
            NSString *stringURL = [NSString stringWithFormat:@"%@privacy-policy.cfm",[[NSUserDefaults standardUserDefaults] valueForKey:@"MorePageURL"]];
            strURL = stringURL;
            strTitleName = @"Privacy Policy";
            [self performSegueWithIdentifier:@"SegueDetailsFromMore" sender:self];
        }
        if (indexPath.row == 4) {
            
            NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
            NSString *webServiceString = [dictRoot objectForKey:@"MorePage"];
            NSString *stringURL = [NSString stringWithFormat:@"%@terms-service.cfm",[[NSUserDefaults standardUserDefaults] valueForKey:@"MorePageURL"]];
            strURL = stringURL;
            strTitleName = @"Terms of Agreement";
            [self performSegueWithIdentifier:@"SegueDetailsFromMore" sender:self];
        }
        if (indexPath.row == 5) {
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
                alertLogOff = [[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Are you sure you want to Log Off?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [alertLogOff show];
            }else {
                
            }
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueNewsletterFromMore"]) {
        
    }
    if ([segue.identifier isEqualToString:@"SegueDetailsFromMore"]) {
        WebDetailsViewController *webDetailsViewController = [segue destinationViewController];
        webDetailsViewController.stringTitleScreen = strTitleName;
        webDetailsViewController.stringURL = strURL;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"CellAboutUs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(indexPath.row==0){
        
        static NSString *CellID = @"CellAboutUs";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3477];
        newLabel.text = @"About Us";
        
        UIImageView *newImageView = (UIImageView *)[cell viewWithTag:3577];
        newImageView.image = [UIImage imageNamed:@"icon_about.png"];
        
        //        cell.imageView.image = [UIImage imageNamed:@"icon_about.png"];
        //        cell.textLabel.text =
        return cell;
    }
    if(indexPath.row==1){
        
        static NSString *CellID = @"CellContactUs";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3478];
        newLabel.text = @"Contact Us";
        
        UIImageView *newImageView = (UIImageView *)[cell viewWithTag:3578];
        newImageView.image = [UIImage imageNamed:@"icon_contact.png"];
        
        
        //        cell.imageView.image = [UIImage imageNamed:@"icon_contact.png"];
        //        cell.textLabel.text = @"Contact Us";
        return cell;
    }
    if(indexPath.row==2){
        
        static NSString *CellID = @"CellNewsletter";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3479];
        newLabel.text = @"Sign up for our Newsletter";
        
        UIImageView *newImageView = (UIImageView *)[cell viewWithTag:3579];
        newImageView.image = [UIImage imageNamed:@"news.png"];
        
        //        cell.imageView.image = [UIImage imageNamed:@"news.png"];
        //        cell.textLabel.text = @"Sign up for our Newsletter";
        return cell;
    }
    if(indexPath.row==3){
        
        static NSString *CellID = @"CellPrivacy";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3480];
        newLabel.text = @"Privacy Policy";
        
        UIImageView *newImageView = (UIImageView *)[cell viewWithTag:3580];
        newImageView.image = [UIImage imageNamed:@"Privasy.png"];
        
        //        cell.imageView.image = [UIImage imageNamed:@"Privasy.png"];
        //        cell.textLabel.text = @"Privacy Policy";
        return cell;
    }
    if(indexPath.row==4){
        
        static NSString *CellID = @"CellAgreement";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3481];
        newLabel.text = @"Terms of Agreement";
        
        UIImageView *newImageView = (UIImageView *)[cell viewWithTag:3581];
        newImageView.image = [UIImage imageNamed:@"agriment.png"];
        
        //        cell.imageView.image = [UIImage imageNamed:@"agriment.png"];
        //        cell.textLabel.text = @"Terms of Agreement";
        return cell;
    }
    if(indexPath.row==5){
        
        static NSString *CellID = @"CellLogOut";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        UILabel *newLabel = (UILabel *)[cell viewWithTag:3482];
        newLabel.text = @"Log Off";
        
        UIImageView *newImageView = (UIImageView *)[cell viewWithTag:3582];
        newImageView.image = [UIImage imageNamed:@"Logoff.png"];
        
        //        cell.imageView.image = [UIImage imageNamed:@"Logoff.png"];
        //        cell.textLabel.text = @"Log Off";
        return cell;
    }
    else{
        return cell;
    }
}

#pragma mark UIAlertView delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
        if (alertView == alertLogOff) {
            if (buttonIndex==1) {
                
                NSString *fileDoc;
                NSError *error;
                
                NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
                NSFileManager *localFileManager=[[NSFileManager alloc] init];
                NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
                while ((fileDoc = [dirEnum nextObject])) {
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docsDir,fileDoc];
                    [localFileManager removeItemAtPath: fullPath error:&error ];
                }
                NSString *docsDirCover = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
                NSFileManager *localFileManagerCover = [[NSFileManager alloc] init];
                NSDirectoryEnumerator *dirEnumCover = [localFileManagerCover enumeratorAtPath:docsDirCover];
                while ((fileDoc = [dirEnumCover nextObject])) {
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docsDirCover,fileDoc];
                    [localFileManagerCover removeItemAtPath: fullPath error:&error ];
                }
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SuceessStatus"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserId"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserEmail"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstLoad"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ResumeIdFromCreate"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                numberOfRows = 5;
                [tableViewMore reloadData];
                [self viewWillAppear:YES];
                [self.tabBarController setSelectedIndex:0];
            }
        }
    }
}

@end
