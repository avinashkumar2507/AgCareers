//
//  MyProfileSubmitViewController.m
//  AgCareers
//
//  Created by Unicorn on 26/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "MyProfileSubmitViewController.h"

@interface MyProfileSubmitViewController ()

@end

@implementation MyProfileSubmitViewController

@synthesize buttonBrowse,buttonUpload,labelResumeName,buttonBrowseCoverLetter,buttonUploadCoverLetter,labelCoverLetterName,textFieldReferrence,switchAccept;
@synthesize pickerParentView,myPicker,buttonCancel;
@synthesize switchResumeFrist,switchResumeSecond;
@synthesize labelResumeFirst,labelResumeSecond;
@synthesize strMemIdSubmit;
@synthesize viewAccept;
@synthesize labelFirstNumber,labelSecondNumber;
BOOL flagReferrenceMyProfile        = FALSE;
BOOL flagGetResumeList              = FALSE;
BOOL flagSubmitMyProfile            = FALSE;
BOOL flagUploadResumeOrNot          = FALSE;
BOOL flagUploadResumeMyProfile      = FALSE;
BOOL flagUploadCoverMyProfile       = FALSE;
NSString *stringResumeFileName      = @"";
NSString *stringCoverFileName       = @"";
NSString *uploadSucess              = @"";
NSString *stringReferrenceMyProfile = @"";
NSString *stringResumeFileNameText  = @"";
NSString *stringCoverFileNameText   = @"";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    flagGetResumeList = TRUE;
    [self callWebServiceGetResumeList];
    
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
}

-(void)viewWillAppear:(BOOL)animated {
    stringReferrenceMyProfile = @"";
    [switchResumeFrist setHidden:YES];
    [switchResumeSecond setHidden:YES];
    flagUploadResumeOrNot = FALSE;
    
    flagUploadResumeMyProfile      = FALSE;
    flagUploadCoverMyProfile       = FALSE;
    
    [viewAccept setHidden:YES];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    if ([filePathsArray count]>0) {
        for (int i = 0; i< [filePathsArray count]; i++) {
            NSString *newStr = [[filePathsArray objectAtIndex:i] substringWithRange:NSMakeRange(11, [[filePathsArray objectAtIndex:i] length]-11)];
            labelResumeName.text = newStr;
        }
    }else {
        labelResumeName.text = @"Select resume";
    }
    
    NSString *documentsDirectoryCover = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
    NSArray *filePathsArrayCover = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectoryCover  error:nil];
    
    if ([filePathsArrayCover count]>0) {
        for (int i = 0; i< [filePathsArrayCover count]; i++) {
            NSString *newStr = [[filePathsArrayCover objectAtIndex:i] substringWithRange:NSMakeRange(11, [[filePathsArrayCover objectAtIndex:i] length]-11)];
            labelCoverLetterName.text = newStr;
        }
    }else {
        labelCoverLetterName.text = @"Select cover letter";
    }
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDropboxBrowserMyProfileSubmit"]) {
        
    }
    if ([segue.identifier isEqualToString:@"showGoogleDriveMyProfileSubmit"]) {
        
    }
}

- (void)showActionSheet{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController *alertController;
        UIAlertAction *logoutAction;
        UIAlertAction *aboutUsAction;
        UIAlertAction *cancelAction;
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        logoutAction = [UIAlertAction actionWithTitle:@"DropBox" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dropBoxCall];
        }];
        aboutUsAction = [UIAlertAction actionWithTitle:@"Google Drive" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self googleDriveCall];
        }];
        cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:logoutAction];
        [alertController addAction:aboutUsAction];
        [alertController addAction:cancelAction];
        alertController.modalInPopover = YES;
        /** Use this code for barbutton item **/
        //alertController.popoverPresentationController.barButtonItem = _barButtonOptions;
        //alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        //alertController.popoverPresentationController.delegate = self;
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        popPresenter.sourceView = buttonBrowse;
        popPresenter.sourceRect = buttonBrowse.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        myActionSheet = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"Cancel"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"DropBox", @"Google Drive", nil];
        [myActionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0){
        [self dropBoxCall];
    }
    if (buttonIndex==1) {
        [self googleDriveCall];
    }
}

-(void)dropBoxCall{
    [self performSegueWithIdentifier:@"showDropboxBrowserMyProfileSubmit" sender:self];
}

-(void)googleDriveCall{
    [self performSegueWithIdentifier:@"showGoogleDriveMyProfileSubmit" sender:self];
}

-(void)uploadFileToServer{
    
    double fileSizeInDouble = 0;
    NSArray *filePathsArrayName = [[NSArray alloc]init];
    NSString *filepath;
    
    if (flagUploadResumeMyProfile == TRUE) {
        //        NSFileManager *fileManager = [[NSFileManager alloc]init];  //
        flagUploadResumeMyProfile = FALSE;
        flagUploadResumeOrNot = TRUE;
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
        filePathsArrayName = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:docsDir  error:nil];
        filepath = [NSString stringWithFormat: @"%@/%@", docsDir, [filePathsArrayName objectAtIndex:0]];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
        
        if(fileAttributes != nil){
            NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
            fileSizeInDouble = [fileSize doubleValue];
            NSLog(@"File size: %@ kb", fileSize);
        }
    }
    if (flagUploadCoverMyProfile == TRUE) {
        
        flagUploadCoverMyProfile = FALSE;
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
        filePathsArrayName = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:docsDir  error:nil];
        filepath = [NSString stringWithFormat: @"%@/%@", docsDir, [filePathsArrayName objectAtIndex:0]];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
        
        if(fileAttributes != nil){
            NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
            fileSizeInDouble = [fileSize doubleValue];
            NSLog(@"File size: %@ kb", fileSize);
        }
    }
    
    if ([[filePathsArrayName objectAtIndex:0]containsString:@"DS_Store"]) {
        
    }else {
        
        
        //if ([textFieldKeyword.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        
        //if ([[filePathsArrayName objectAtIndex:0] rangeOfString:@".rtf"].location==NSNotFound ) {
        if ([[filePathsArrayName objectAtIndex:0] rangeOfString:@".docx"].location!=NSNotFound ||[[filePathsArrayName objectAtIndex:0] rangeOfString:@".doc"].location!=NSNotFound ||[[filePathsArrayName objectAtIndex:0] rangeOfString:@".pdf"].location!=NSNotFound ||[[filePathsArrayName objectAtIndex:0] rangeOfString:@".txt"].location!=NSNotFound) {
            
            if (fileSizeInDouble > 5000000) {
                [self showAlertViewWithMessage:@"Permissible file size is upto 5MB" withTitle:@"Error"];
            }else{
                
                HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD1];
                HUD1.delegate = self;
                HUD1.labelText = @"Uploading the file";
                [HUD1 show:YES];
                
                
                uploadData = [NSData dataWithContentsOfFile: filepath];
                uploadFile = [[BRRequestUpload alloc] initWithDelegate: self];
                
                
                NSString *stringUploadName =  [NSString stringWithFormat:@"%@_%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],[filePathsArrayName objectAtIndex:0]];
                
                //                uploadFile.path = [NSString stringWithFormat:@"root\\dev.agcareers.farmsstaging.com\\www\\AgUploads\\%@",stringUploadName]; // Resume path
                //                uploadFile.hostname = @"192.168.24.45";
                //                uploadFile.username = @"Rohit.singh";
                //                uploadFile.password = @"P@ssw0rd2012";
                
                //                uploadFile.path = [NSString stringWithFormat:@"root\\agcareers.farmsstaging.com\\www\\AgUploads\\%@",stringUploadName]; // Resume path
                //
                //                uploadFile.hostname = @"216.220.44.186";
                //                uploadFile.username = @"Rohit.singh";
                //                uploadFile.password = @"P@ssw0rd2012";
                
                uploadFile.path = [NSString stringWithFormat:@"aguploads\\%@",stringUploadName]; // Resume path
                
                uploadFile.hostname = [[NSUserDefaults standardUserDefaults] valueForKey:@"GlobalFTP"];//@"216.220.44.186";
                uploadFile.username = @"mobileuploads";
                uploadFile.password = @"yeuEYrLiBk3OPSMlmLQG!";
                
                //we start the request
                [uploadFile start];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select a valid file" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

#pragma mark upload files to server
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
        if (flagUploadResumeOrNot==TRUE) {
            flagUploadResumeOrNot = FALSE;
            uploadSucess = @"TRUE";
        }else{
            //uploadSucess = @"FALSE";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"File uploaded successfully"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [HUD1 hide:YES];
        uploadFile = nil;
    }
    //----- handle Create Directory
    //    if (request == createDir) {
    //        NSLog(@"%@ completed!", request);
    //        createDir = nil;
    //    }
}

-(void) requestFailed:(BRRequest *) request {
    
    if (request == uploadFile) {
        NSLog(@"%@", request.error.message);
        //        [HUD1 hide:YES];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
        //                                                        message:@"Some error occured while uploading the document. Please try again."
        //                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        //        uploadFile = nil;
    }else{
        
        NSLog(@"Avinash unknown error update profile");
        
        [HUD1 hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Some error occured while uploading the document. Please try again."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        uploadFile = nil;
    }
    //    if (request == createDir)
    //    {
    //        NSLog(@"%@", request.error.message);
    //
    //        createDir = nil;
    //    }else{
    //
    //    }
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

// Picker view single tap
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagReferrenceMyProfile == TRUE) {
            
            flagReferrenceMyProfile = FALSE;
            [textFieldReferrence setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringReferrenceMyProfile = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringReferrenceMyProfile :%@",stringReferrenceMyProfile);
            pickerParentView.hidden = YES;
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

#pragma mark PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrayPickerData count] ;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[arrayPickerData objectAtIndex:row]valueForKey:@"Name"];
}

-(void)callWebServiceReferrence {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetReferencedBy";
    NSString* soapAction = @"http://tempuri.org/GetReferencedBy";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceSaveResumeFile {
    
    jsonParser2 = [APParser sharedParser];
    jsonParser2.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"SaveResumeFile";
    NSString* soapAction = @"http://tempuri.org/SaveResumeFile";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                   @"0",@"ResumeID",
                                   stringResumeFileNameText,@"DescriptiveName",
                                   stringResumeFileName,@"FileName",
                                   @"",@"theFile",
                                   @"0",@"FileUploadID",
                                   stringCoverFileNameText,@"CoverTitle",
                                   @"",@"CoverLetter",
                                   stringCoverFileName,@"FullFileName",
                                   @"0",@"CLID",
                                   stringReferrenceMyProfile,@"ReferredBy",
                                   @"",@"CLFolderName",
                                   nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceGetResumeList {
    
    jsonParser3 = [APParser sharedParser];
    jsonParser3.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"GetResumeFiles";
    NSString* soapAction = @"http://tempuri.org/GetResumeFiles";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"memberid",
                                   @"0",@"resumeid",
                                   nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self hideHUDandWebservice];
}

-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool {
    if (successBool == YES) {
        if (flagReferrenceMyProfile == TRUE) {
            
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            arrayPickerData = [JSONDict valueForKey:@"Rows"];
            pickerParentView.hidden = NO;
            [myPicker reloadAllComponents];
        }
        if (flagSubmitMyProfile == TRUE) {
            flagSubmitMyProfile = FALSE;
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
                
                uploadSucess = @"FALSE";
                
                alertSuccess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your profile has been updated succesfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alertSuccess show];
            }else {
                [self showAlertViewWithMessage:@"Some error occured. Please try again later." withTitle:@"Error"];
            }
        }
        if (flagGetResumeList == TRUE) {
            flagGetResumeList = FALSE;
            [HUD hide:YES];
            [self.tabBarController.view setUserInteractionEnabled:YES];
            NSError *error;
            JSONDictResumeList = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
            [textFieldReferrence setText:[JSONDictResumeList valueForKey:@"ReferredBy"]];
            if ([[JSONDictResumeList objectForKey:@"ErrorMsg"]isEqualToString:@"Fail"]) {
                //            [switchResumeFrist setHidden:YES];
                //            [switchResumeSecond setHidden:YES];
                [labelResumeFirst setText:@""];
                [labelResumeSecond setText:@""];
            }else{
                if ([[JSONDictResumeList objectForKey:@"ResumesList"]count]== 0) {
                    [labelResumeName setText:@"Select Resume"];
                    buttonBrowse.enabled = YES;
                    buttonUpload.enabled = YES;
                    //                [switchResumeFrist setHidden:YES];
                    //                [switchResumeSecond setHidden:YES];
                    [labelResumeFirst setText:@""];
                    [labelResumeSecond setText:@""];
                    [labelFirstNumber setText:@""];
                    [labelSecondNumber setText:@""];
                }
                if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==1){
                    [labelResumeFirst setText:[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"FileName"]];
                    [labelResumeSecond setText:@""];
                    //                [switchResumeSecond setHidden:YES];
                    
                    [labelSecondNumber setText:@""];
                    
                }
                if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==2){
                    
                    [labelResumeName setText:@"Recent resumes:"];
                    
                    [buttonBrowse setHidden:YES];
                    [buttonUpload setHidden:YES];
                    
                    [labelResumeFirst setText:[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"FileName"]];
                    [labelResumeSecond setText:[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:1]valueForKey:@"FileName"]];
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

-(IBAction)buttonUploadAction:(id)sender{
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
        //        HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        flagUploadResumeMyProfile = TRUE;
        
        
        NSArray *filePathsArrayName = [[NSArray alloc]init];
        NSString *filepath;
        
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
        filePathsArrayName = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:docsDir  error:nil];
        
        
        
        
        if ([filePathsArrayName count]>0) {
            [self uploadFileToServer];
        }else {
            [self showAlertViewWithMessage:@"Please download resume from browse button before uploading" withTitle:@"Error"];
        }
    }
}

-(IBAction)buttonBrowseAction:(id)sender{
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
        [[NSUserDefaults standardUserDefaults]setValue:@"BrowseResume" forKey:@"Resume"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self showActionSheet];
    }
}
- (IBAction)buttonActionUploadCoverLetter:(id)sender {
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
        //        HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        flagUploadCoverMyProfile = TRUE;
        
        NSArray *filePathsArrayName = [[NSArray alloc]init];
        NSString *filepath;
        
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
        filePathsArrayName = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:docsDir  error:nil];
        
        if ([filePathsArrayName count]>0) {
            [self uploadFileToServer];
        }else {
            [self showAlertViewWithMessage:@"Please download cover letter from browse button before uploading" withTitle:@"Error"];
        }
        
        //    [self uploadFileToServer];
    }
}

- (IBAction)buttonActionBrowseCoverLetter:(id)sender {
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
        [[NSUserDefaults standardUserDefaults]setValue:@"BrowseCover" forKey:@"Cover"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self showActionSheet];
    }
}

- (IBAction)buttonActionReferrence:(id)sender {
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
        flagReferrenceMyProfile = TRUE;
        [self callWebServiceReferrence];
    }
}
- (IBAction)buttonActionCancel:(id)sender {
    flagReferrenceMyProfile = FALSE;
    pickerParentView.hidden = YES;
}

- (IBAction)switchActionAccept:(id)sender {
    
}

- (IBAction)buttonActionUpdate:(id)sender {
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
        
        NSString *myResume,*myCover;
        
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
        NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
        
        if ([filePathsArray count]>0) {
            for (int i = 0; i< [filePathsArray count]; i++) {
                myResume = [filePathsArray objectAtIndex:i];
            }
        }else {
            myResume = @"Select resume";
        }
        
        NSString *documentsDirectoryCover = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
        NSArray *filePathsArrayCover = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectoryCover  error:nil];
        
        if ([filePathsArrayCover count]>0) {
            for (int i = 0; i< [filePathsArrayCover count]; i++) {
                myCover = [filePathsArrayCover objectAtIndex:i];
            }
        }else {
            myCover = @"Select cover letter";
        }
        
        
        
        if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==2){
            
            if ([textFieldReferrence.text length]>0) {
                flagSubmitMyProfile = TRUE;
                stringResumeFileName = myResume;//[NSString stringWithFormat:@"%@",labelResumeName.text];
                stringResumeFileNameText = labelResumeName.text;
                if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                    stringCoverFileName = @"";
                    stringCoverFileNameText = @"";
                }else{
                    stringCoverFileName = myCover;//labelCoverLetterName.text;
                    stringCoverFileNameText = labelCoverLetterName.text;
                }
                [self callWebServiceSaveResumeFile];
            }else{
                [self showAlertViewWithMessage:@"Please select one option from \"How did you hear about Agcareers?\" " withTitle:@"Error"];
            }
        }
        if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==1){
            
            //if([uploadSucess isEqualToString:@"TRUE"]) {
            
            if ([textFieldReferrence.text length]>0) {
                stringReferrenceMyProfile = textFieldReferrence.text;
                flagSubmitMyProfile = TRUE;
                stringResumeFileName = myResume;
                stringResumeFileNameText = labelResumeName.text;
                
                if ([labelResumeName.text isEqualToString:@"Select resume"]) {
                    stringResumeFileName = @"";
                    stringResumeFileNameText = @"";
                }else{
                    stringResumeFileName = myResume;
                    stringResumeFileNameText = labelResumeName.text;
                }
                
                if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                    stringCoverFileName = @"";
                    stringCoverFileNameText = @"";
                }else{
                    stringCoverFileName = myCover;//labelCoverLetterName.text;
                    stringCoverFileNameText = labelCoverLetterName.text;
                }
                [self callWebServiceSaveResumeFile];
            }else{
                [self showAlertViewWithMessage:@"Please select one option from \"How did you hear about Agcareers?\" " withTitle:@"Error"];
            }
            //            }else{
            //                [self showAlertViewWithMessage:@"Please upload resume file" withTitle:@"Error"];
            //            }
        }
        if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==0){
            
            //if ([uploadSucess isEqualToString:@"TRUE"]) {
            if ([textFieldReferrence.text length]>0) {
                stringReferrenceMyProfile = textFieldReferrence.text;
                flagSubmitMyProfile = TRUE;
                stringResumeFileName = myResume;//labelResumeName.text;
                stringResumeFileNameText = labelResumeName.text;
                if ([labelResumeName.text isEqualToString:@"Select resume"]) {
                    stringResumeFileName = @"";
                    stringResumeFileNameText = @"";
                }else{
                    stringResumeFileName = myResume;
                    stringResumeFileNameText = labelResumeName.text;
                }
                if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                    stringCoverFileName = @"";
                    stringCoverFileNameText = @"";
                }else{
                    stringCoverFileName = myCover;//labelCoverLetterName.text;
                    stringCoverFileNameText = labelCoverLetterName.text;
                }
                [self callWebServiceSaveResumeFile];
            }else{
                [self showAlertViewWithMessage:@"Please select one option from \"How did you hear about Agcareers?\" " withTitle:@"Error"];
            }
            //            }else{
            //                [self showAlertViewWithMessage:@"Please upload resume file" withTitle:@"Error"];
            //            }
        }
    }
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertSuccess) {
        if (buttonIndex == 0) {
            //[self.tabBarController setSelectedIndex:0];
        }
    }
}

- (IBAction)switchActionResumeFirst:(id)sender {
    //    if ([switchResumeFrist isOn]==TRUE) {
    //        [switchResumeSecond setOn:FALSE];
    //    }else{
    //        [switchResumeSecond setOn:TRUE];
    //    }
}

- (IBAction)switchActionResumeSecond:(id)sender {
    //    if ([switchResumeSecond isOn]==TRUE) {
    //        [switchResumeFrist setOn:FALSE];
    //    }else{
    //        [switchResumeFrist setOn:TRUE];
    //    }
}

@end