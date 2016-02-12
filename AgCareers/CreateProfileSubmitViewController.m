//
//  CreateProfileSubmitViewController.m
//  AgCareers
//
//  Created by Unicorn on 19/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "CreateProfileSubmitViewController.h"
#import <Google/Analytics.h>
@interface CreateProfileSubmitViewController ()

@end

@implementation CreateProfileSubmitViewController

@synthesize buttonBrowse,buttonUpload,labelResumeName,buttonBrowseCoverLetter,buttonUploadCoverLetter,labelCoverLetterName,textFieldReferrence,switchAccept;
@synthesize pickerParentView,myPicker,buttonCancel;

@synthesize strMemIdSubmit,stringIdIndustrySubmit,stringIdCareersSubmit,stringResumeId;

BOOL flagReferrence                 = FALSE;
BOOL flagUploadResume               = FALSE;
BOOL flagUploadCover                = FALSE;
BOOL flagApplyWithCreateProfile     = FALSE;

NSString *stringReferrence;
NSString *uploadSucessCreate        = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uploadSucessCreate = @"";
    stringResumeId = @"0";
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
}

-(void)viewWillAppear:(BOOL)animated {
    
    flagUploadResumeOrNotCreate = FALSE;
    
    //#import <Google/Analytics.h>
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Create Profile Three Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
//    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
//    
//    //if ([[filePathsArray objectAtIndex:0]containsString:@"DS_Store"]) {  //AvinashCover
//    if ([filePathsArray count]>0) {
//        for (int i = 0; i< [filePathsArray count]; i++) {
//            labelResumeName.text = [filePathsArray objectAtIndex:i];
//        }
//    }else {
//        labelResumeName.text = @"Select resume";
//    }
//    
//    NSString *documentsDirectoryCover = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
//    NSArray *filePathsArrayCover = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectoryCover  error:nil];
//    
//    if ([filePathsArrayCover count]>0) {
//        for (int i = 0; i< [filePathsArrayCover count]; i++) {
//            labelCoverLetterName.text = [filePathsArrayCover objectAtIndex:i];
//        }
//    }else {
//        labelCoverLetterName.text = @"Select cover letter";
//    }
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    if ([filePathsArray count]>0) {
        for (int i = 0; i< [filePathsArray count]; i++) {
            NSString *newStr = [[filePathsArray objectAtIndex:i] substringWithRange:NSMakeRange(11, [[filePathsArray objectAtIndex:i] length]-11)];
            //labelResumeName.text = [filePathsArray objectAtIndex:i];
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
            //labelCoverLetterName.text = [filePathsArrayCover objectAtIndex:i];
        }
    }else {
        labelCoverLetterName.text = @"Select cover letter";
    }
}

-(void)showAlertViewWithMessage :(NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:@"Error" message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDropboxBrowserCreateProfileSubmit"]) {
        
    }
    if ([segue.identifier isEqualToString:@"ShowGoogleDriveCreateProfileSubmit"]) {
        
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

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == alertForApplySucess) {
        if (buttonIndex == 0) {
            if (self.tabBarController.selectedIndex == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
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
    [self performSegueWithIdentifier:@"showDropboxBrowserCreateProfileSubmit" sender:self];
}

-(void)googleDriveCall{
    [self performSegueWithIdentifier:@"ShowGoogleDriveCreateProfileSubmit" sender:self];
}

BOOL flagUploadResumeOrNotCreate        = FALSE;
NSString *stringResumeFileNameCreate    = @"";
NSString *stringCoverFileNameCreate     = @"";

NSString *stringResumeFileNameCreateText    = @"";
NSString *stringCoverFileNameCreateText     = @"";


-(void)uploadFileToServer{
    
    double fileSizeInDouble = 0;
    NSArray *filePathsArrayName = [[NSArray alloc]init];
    NSString *filepath;
    
    if (flagUploadResume == TRUE) {
        
        flagUploadResume = FALSE;
        flagUploadResumeOrNotCreate = TRUE;
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
    if (flagUploadCover == TRUE) {
        
        flagUploadCover = FALSE;
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
                
                uploadFile.path = [NSString stringWithFormat:@"root\\dev.agcareers.farmsstaging.com\\www\\AgUploads\\%@",stringUploadName]; // Resume path
                
                uploadFile.hostname = @"192.168.24.45";
                uploadFile.username = @"Rohit.singh";
                uploadFile.password = @"P@ssw0rd2012";
                
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
        if (flagUploadResumeOrNotCreate==TRUE) {
            flagUploadResumeOrNotCreate = FALSE;
            uploadSucessCreate = @"TRUE";
        }else{
            //uploadSucessCreate = @"FALSE";
        }
        
        [HUD1 hide:YES];
        uploadFile = nil;
        [HUD1 hide:YES];
        uploadFile = nil;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"File uploaded successfully"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) requestFailed:(BRRequest *) request {
    
    if (request == uploadFile) {
        NSLog(@"%@", request.error.message);
        
//        [HUD1 hide:YES];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:@"Some error occured while uploading the document. Please try again."
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        
//        uploadFile = nil;
    }else{
        
        NSLog(@"Avinash unknown error Create profile");
        
        [HUD1 hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Some error occured while uploading the document. Please try again."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
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

// Picker view single tap
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0 );
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagReferrence == TRUE) {
            
            flagReferrence = FALSE;
            [textFieldReferrence setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringReferrence = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringReferrence :%@",stringReferrence);
            pickerParentView.hidden = YES;
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

#pragma mark PickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
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


-(void)callWebServiceSaveResumeFile{
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //appDelegate.stringApplyWhileCreating = @"ApplyWhileCreating";

    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                   stringResumeId,@"ResumeID",
                                   stringResumeFileNameCreateText,@"DescriptiveName",
                                   stringResumeFileNameCreate,@"FileName",
                                   @"",@"theFile",
                                   @"0",@"FileUploadID",
                                   stringCoverFileNameCreateText,@"CoverTitle",
                                   @"",@"CoverLetter",
                                   stringCoverFileNameCreate,@"FullFileName",
                                   @"0",@"CLID",
                                   stringReferrence,@"ReferredBy",
                                   @"",@"CLFolderName",
                                   nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)callWebServiceNewJobApply {
    
    flagApplyWithCreateProfile = TRUE;
    jsonParser3 = [APParser sharedParser];
    jsonParser3.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    NSString* methodName = @"NewJobApply";
    NSString* soapAction = @"http://tempuri.org/NewJobApply";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDictionary *dictProfile = [[NSDictionary alloc]init];
    NSDictionary *dictDetails = [[NSDictionary alloc]init];
    dictProfile = appDelegate.applyProfileDictionary;
    dictDetails = appDelegate.applyDetailsDictionary;
    NSString *jobID = appDelegate.stringJobIdCreateProfile;
   
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:jobID,@"JobID",
                                   [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                   [dictProfile valueForKey:@"firstname"],@"firstname",
                                   [dictProfile valueForKey:@"lastname"],@"lastname",
                                   [dictProfile valueForKey:@"address"],@"Address1",
                                   [dictProfile valueForKey:@"address2"],@"Address2",
                                   [dictProfile valueForKey:@"city"],@"city",
                                   [dictProfile valueForKey:@"countryid"],@"CountryID",
                                   [dictProfile valueForKey:@"stateid"],@"StateID",
                                   [dictProfile valueForKey:@"postalcode"],@"PostalCode",
                                   [dictProfile valueForKey:@"email"],@"Email",
                                   [dictProfile valueForKey:@"PhoneWork"],@"PhoneWork",
                                   [dictDetails valueForKey:@"ExpYears"],@"ExperienceID",
                                   [dictDetails valueForKey:@"EduLevel"],@"MinEducationID",
                                   [dictDetails valueForKey:@"EduCategory"],@"MaxEducationID",
                                   [dictDetails valueForKey:@"Occupation"],@"Occupationid",
                                   stringResumeFileNameCreate,@"ResumeFileName",
                                   stringResumeFileNameCreateText,@"DescriptiveName",
                                   stringResumeId,@"ResumeUploadID",
                                   @"",@"siteURL",
                                   stringCoverFileNameCreate,@"CoverLetterFileName",
                                   stringCoverFileNameCreateText,@"CoverLetter",
                                   @"",@"DEVICEID",
                                   @"",@"ApplyURL",
                                   @"",@"DesiredSalary",
                                   @"",@"CommutingDistance",
                                   @"",@"Relocate",
                                   @"",@"RelocateWhen",
                                   stringIdIndustrySubmit,@"iType",
                                   stringIdCareersSubmit,@"cType",
                                   nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser3 parseSoapWithJSONSoapContents:dictToSend];
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
    [self.tabBarController.view setUserInteractionEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideHUDandWebservice];
}

-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool {
    
    if (flagReferrence == TRUE) {
        
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
    if (flagSubmitCreate == TRUE) {
        uploadSucessCreate = @"FALSE";
        
        flagSubmitCreate = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            
            alertSuccess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your profile has been created succesfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [alertSuccess show];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            if ([appDelegate.stringApplyWhileCreating isEqualToString:@"ApplyWhileCreating"]) {
                
                alertForApplySucess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully applied to job and created your profile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
                [alertForApplySucess show];
                //[self callWebServiceNewJobApply];
            }else{
                [self.tabBarController setSelectedIndex:0];
            }
        }else{
            [self showAlertViewWithMessage:@"Some error occured. Please try again." withTitle:@"Error"];
        }
    }
    if (flagApplyWithCreateProfile == TRUE) {
        flagApplyWithCreateProfile = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            
            alertForApplySucess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully applied to job and created your profile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ,nil];
            [alertForApplySucess show];
        }else {
            [self showAlertViewWithMessage:@"Some error occured. Please try again later." withTitle:@"Error"];
        }
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
        
        flagUploadResume = TRUE;
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
        //HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        flagUploadCover = TRUE;
        NSArray *filePathsArrayName = [[NSArray alloc]init];
        NSString *filepath;
        
        NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
        filePathsArrayName = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:docsDir  error:nil];
        
        if ([filePathsArrayName count]>0) {
            [self uploadFileToServer];
        }else {
            [self showAlertViewWithMessage:@"Please download cover letter from browse button before uploading" withTitle:@"Error"];
        }
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
        flagReferrence = TRUE;
        [self callWebServiceReferrence];
    }
}
- (IBAction)buttonActionCancel:(id)sender {
    flagReferrence = FALSE;
    pickerParentView.hidden = YES;
}

- (IBAction)switchActionAccept:(id)sender {
    
}
BOOL flagSubmitCreate = FALSE;
- (IBAction)buttonActionSubmit:(id)sender {
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

        if ([uploadSucessCreate isEqualToString:@"TRUE"]) {
            if ([textFieldReferrence.text length]>0) {
                if (switchAccept.isOn == TRUE) {
                    //                stringUploadName
                    
                    if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                        stringCoverFileNameCreate = @"";
                        stringCoverFileNameCreateText = @"";
                    }else{
                        stringCoverFileNameCreate = myCover;//labelCoverLetterName.text;
                        stringCoverFileNameCreateText = labelCoverLetterName.text;
                    }
                    stringResumeFileNameCreate = myResume;//labelResumeName.text;
                    stringResumeFileNameCreateText = labelResumeName.text;
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    //appDelegate.stringApplyWhileCreating = @"ApplyWhileCreating";

                    if ([appDelegate.stringApplyWhileCreating isEqualToString:@"ApplyWhileCreating"]) {
                        [self callWebServiceNewJobApply];
                    }else{
                        flagSubmitCreate = TRUE;
                        [self callWebServiceSaveResumeFile];
                    }
                }else{
                    [self showAlertViewWithMessage:@"Please accept the AgCareers TOS" withTitle:@"Error"];
                }
            }else{
                [self showAlertViewWithMessage:@"Please select one option from \"How did you hear about Agcareers?\" " withTitle:@"Error"];
            }
        }else {
            [self showAlertViewWithMessage:@"Please upload resume file" withTitle:@"Error"];
        }
    }
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}



@end