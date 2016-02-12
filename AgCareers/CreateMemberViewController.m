//
//  CreateMemberViewController.m
//  AgCareers
//
//  Created by Unicorn on 21/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "CreateMemberViewController.h"
#import "DropboxBrowserViewController.h"

@interface CreateMemberViewController ()

@end

@implementation CreateMemberViewController
@synthesize buttonLoginToDropBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateButtons];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDropboxBrowser"]) {
        // Get reference to the destination view controller
        UINavigationController *navigationController = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        DropboxBrowserViewController *dropboxBrowser = (DropboxBrowserViewController *)navigationController.topViewController;
        
        // dropboxBrowser.allowedFileTypes = @[@"doc", @"pdf"]; // Uncomment to filter file types. Create an array of allowed types. To allow all file types simply don't set the property
        // dropboxBrowser.tableCellID = @"DropboxBrowserCell"; // Uncomment to use a custom UITableViewCell ID. This property is not required
        
        // When a file is downloaded (either successfully or unsuccessfully) you can have DBBrowser notify the user with Notification Center. Default property is NO.
        dropboxBrowser.deliverDownloadNotifications = YES;
        
        // Dropbox Browser can display a UISearchBar to allow the user to search their Dropbox for a file or folder. Default property is NO.
        dropboxBrowser.shouldDisplaySearchBar = YES;
        
        // Set the delegate property to recieve delegate method calls
        dropboxBrowser.rootViewDelegate = self;
    }
    if ([[segue identifier]isEqualToString:@"GoogleSegue"]) {
        
    }
    
}


- (IBAction)buttonActionLoginToDropBox:(id)sender {
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
        if (![[DBSession sharedSession] isLinked]) {
            [[DBSession sharedSession] linkFromController:self];
        }else {
            [[DBSession sharedSession] unlinkAll];
            [[[UIAlertView alloc]
              initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
             show];
            [self updateButtons];
        }
    }
}

- (void)updateButtons {
    NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
    [buttonLoginToDropBox setTitle:title forState:UIControlStateNormal];
    
    //self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
}

- (IBAction)buttonActionListing:(id)sender{
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
        [self.restClient loadMetadata:@"/Photos/"];
    }
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (IBAction)buttonActionDownload:(id)sender {
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //    NSString *localPath = [self applicationDocumentsDirectory].path;
    //    //[sampleText writeToFile:path atomically:YES
    //      //             encoding:NSUTF8StringEncoding error:nil];
    //
    //    [self.restClient loadFile:@"/Photos/Tom_and_Jerry.jpg" intoPath:localPath];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //[self performSegueWithIdentifier:@"showDropboxBrowser" sender:self];
    
}

- (void) percentCompleted: (BRRequest *) request {
    NSLog(@"%f completed...", request.percentCompleted);
}

- (void) requestDataAvailable: (BRRequestDownload *) request{
    
}

- (long) requestDataSendSize: (BRRequestUpload *) request {
    return [uploadData length];
}

-(void) requestCompleted: (BRRequest *) request {
    
    if (request == uploadFile) {
        NSLog(@"%@ completed!", request);
        uploadFile = nil;
    }
}

-(void) requestFailed:(BRRequest *) request {
    
    if (request == uploadFile) {
        NSLog(@"%@", request.error.message);
        uploadFile = nil;
    }
}

- (NSData *) requestDataToSend: (BRRequestUpload *) request {
    NSData *temp = uploadData;   // this is a shallow copy of the pointer
    uploadData = nil;            // next time around, return nil...
    return temp;
}

- (IBAction) cancelAction :(id)sender {
    if (uploadFile) {
        [uploadFile cancelRequest];
    }
}

- (IBAction)buttonActionUploadToServer:(id)sender {
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
        NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filepath = [NSString stringWithFormat: @"%@/%@", applicationDocumentsDir, @"working-draft (1).txt"];
        uploadData = [NSData dataWithContentsOfFile: filepath];
        
        uploadFile = [[BRRequestUpload alloc] initWithDelegate: self];
        
        //----- for anonymous login just leave the username and password nil
        uploadFile.path = @"www\\agcareers08.vlinteractive\\www\\MobileUploads\\newTxt.txt";
        uploadFile.hostname = @"216.220.54.56";
        uploadFile.username = @"rohit.singh";
        uploadFile.password = @"Acc3ss2013!";
        
        //we start the request
        [uploadFile start];
        
        //    jsonParser = [Parser sharedParser];
        //    jsonParser.delegate = self;
        
        //[self callWebService];
        
        /*
         NSString *fileName =[NSString stringWithFormat: @"%@.pdf",@"Get Started with Dropbox"];
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0];
         NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
         NSData *data=[NSData dataWithContentsOfFile:path];
         NSString *convertedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         //[self.tabBarController.view setUserInteractionEnabled:NO ];
         HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
         NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
         [self.navigationController.view addSubview:HUD];
         HUD.delegate = self;
         HUD.labelText = @"Loading";
         [HUD show:YES];
         
         //[self.view setUserInteractionEnabled:NO];
         NSString* methodName = @"SaveResumeFile";
         NSString* soapAction = @"http://tempuri.org/SaveResumeFile";
         
         
         NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:@"208214",@"MemberID",@"0",@"ResumeID",@"TestFileAvinash",@"DescriptiveName",@"Get Started with Dropbox",@"FileName", convertedString,@"theFile",@"9105",@"FileUploadID",nil];
         NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"url",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
         
         [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:60];
         [jsonParser parseSoapWithJSONSoapContents:dictToSend];
         
         */
        
        
        /*
         NSData theData = [NSData dataWithData:[GTMBase64 decodeString:theBinary]]; //first transfer it to NSData.
         
         [m_oTestingWeb loadData:theData
         MIMEType:@"application/pdf"
         textEncodingName:@"UTF-8"
         baseURL:nil];
         */
        
        
        /*
         show docx on webview
         
         NSString *path = [urlFileInView path];
         NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
         
         
         webViewForDocsView.delegate = self;
         [webViewForDocsView loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:nil];
         */
    }
}

- (IBAction)buttonActionGoogleDrive:(id)sender {
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
        [self performSegueWithIdentifier:@"GoogleSegue" sender:self];
    }
}
#pragma mark Call web service
-(void)callWebService {
    
}

-(void)hideHUDandWebservice{
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

// For getting application document directory path
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}

@end