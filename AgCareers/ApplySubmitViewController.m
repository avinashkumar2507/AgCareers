//
//  ApplySubmitViewController.m
//  AgCareers
//
//  Created by Unicorn on 08/09/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "ApplySubmitViewController.h"

@interface ApplySubmitViewController ()

@end

@implementation ApplySubmitViewController

@synthesize buttonBrowse,buttonUpload,labelResumeName,buttonBrowseCoverLetter,buttonUploadCoverLetter,labelCoverLetterName,textFieldReferrence,switchAccept;
@synthesize pickerParentView,myPicker,buttonCancel,stringIdCareersApply,stringIdIndustryApply;

@synthesize viewAcceptTOS,viewHowDid;

@synthesize switchResumeSecond,switchResumeFrist,labelResumeFirst,labelResumeSecond;

BOOL flagReferrenceApplySubmit                  = FALSE;
BOOL flagUploadResumeApplySubmit                = FALSE;
BOOL flagUploadCoverApplySubmit                 = FALSE;
BOOL flagSubmitApplySubmit                      = FALSE;
BOOL flagUploadResumeOrNotApplySubmit           = FALSE;
BOOL flagGetResumeListApply                     = FALSE;
BOOL flagApplyNewJob                            = FALSE;
NSString *stringReferrenceApplySubmit           = @"";
NSString *stringResumeFileNameApplySubmit       = @"";
NSString *stringCoverFileNameApplySubmit        = @"";

NSString *stringResumeFileNameApplySubmitText   = @"";
NSString *stringCoverFileNameApplySubmitText    = @"";
NSString *uploadSucessApplySubmit               = @"";
NSString *stringResumeIdUpload                  = @"";
@synthesize applyConditionSumit;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([applyConditionSumit isEqualToString:@"ApplyWithOutLogin"]) {
        [switchResumeFrist setHidden:YES];
        [switchResumeSecond setHidden:YES];
        [labelResumeFirst setText:@""];
        [labelResumeSecond setText:@""];
        viewHowDid.hidden = YES;
        viewAcceptTOS.hidden = NO;
    }else{
        [switchAccept setOn:YES];
        [textFieldReferrence setText:@""];
        stringReferrenceApplySubmit = @"";
        
        flagGetResumeListApply = TRUE;
        [self callWebServiceGetResumeList];
        viewHowDid.hidden = YES;
        viewAcceptTOS.hidden = YES;
    }
    
    pickerParentView.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [myPicker addGestureRecognizer:singleFingerTap];
}

-(void)callWebServiceGetResumeList {
    
    jsonParser4 = [APParser sharedParser];
    jsonParser4.delegate = self;
    
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
    [jsonParser4 parseSoapWithJSONSoapContents:dictToSend];
}


-(void)viewWillAppear:(BOOL)animated {
    
    //uploadSucessApplySubmit = @"FALSE";
    flagUploadResumeOrNotApplySubmit = FALSE;
    stringResumeIdUpload = @"";
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SuceessStatus"]isEqualToString:@"Success"]) {
        
    }else {
        if ([applyConditionSumit isEqualToString:@"ApplyWithOutLogin"]) {
            
        }else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueDropBoxApply"]) {
        
    }
    if ([segue.identifier isEqualToString:@"SegueGoogleDriveApply"]) {
        
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
        if (buttonIndex==0){
            [self dropBoxCall];
        }
        if (buttonIndex==1) {
            [self googleDriveCall];
        }
    }
}

-(void)dropBoxCall{
    [self performSegueWithIdentifier:@"SegueDropBoxApply" sender:self];
}

-(void)googleDriveCall{
    [self performSegueWithIdentifier:@"SegueGoogleDriveApply" sender:self];
}


-(void)uploadFileToServer{
    
    double fileSizeInDouble = 0;
    NSArray *filePathsArrayName = [[NSArray alloc]init];
    NSString *filepath;
    
    if (flagUploadResumeApplySubmit == TRUE) {
        
        flagUploadResumeApplySubmit = FALSE;
        flagUploadResumeOrNotApplySubmit = TRUE;
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
    if (flagUploadCoverApplySubmit == TRUE) {
        
        flagUploadCoverApplySubmit = FALSE;
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
        
        if ([[filePathsArrayName objectAtIndex:0] rangeOfString:@".docx"].location!=NSNotFound ||[[filePathsArrayName objectAtIndex:0] rangeOfString:@".doc"].location!=NSNotFound ||[[filePathsArrayName objectAtIndex:0] rangeOfString:@".pdf"].location!=NSNotFound ||[[filePathsArrayName objectAtIndex:0] rangeOfString:@".txt"].location!=NSNotFound) {
            
            //if ([[filePathsArrayName objectAtIndex:0] rangeOfString:@".rtf"].location!=NSNotFound ){
            
            if (fileSizeInDouble > 5000000) {
                [self showAlertViewWithMessage:@"Permissible file size is upto 5MB" withTitle:@"Error"];
            }else{
                
                HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD1];
                HUD1.delegate = self;
                HUD1.labelText = @"Uploading the file";
                //HUD1.detailsLabelText = [NSString stringWithFormat:@"%1.f %%",request.percentCompleted*100];   //request.percentCompleted;
                [HUD1 show:YES];
                
                
                uploadData = [NSData dataWithContentsOfFile: filepath];
                uploadFile1 = [[BRRequestUpload alloc] initWithDelegate: self];
                
                //----- for anonymous login just leave the username and password nil
                //uploadFile.path = @"www\\agcareers08.vlinteractive\\www\\MobileUploads\\Coursework aims.docx";
                //----- for anonymous login just leave the username and password nil
                
                NSString *stringUploadName;
                
                if ([applyConditionSumit isEqualToString:@"ApplyWithOutLogin"]) {
                    stringUploadName =  [NSString stringWithFormat:@"%@",[filePathsArrayName objectAtIndex:0]];
                }else{
                    stringUploadName =  [NSString stringWithFormat:@"%@_%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],[filePathsArrayName objectAtIndex:0]];
                }
                
                uploadFile1.path = [NSString stringWithFormat:@"root\\dev.agcareers.farmsstaging.com\\www\\AgUploads\\%@",stringUploadName]; // Resume path
                uploadFile1.hostname = @"192.168.24.45";
                uploadFile1.username = @"Rohit.singh";
                uploadFile1.password = @"P@ssw0rd2012";
                
                //we start the request
                [uploadFile1 start];
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
    
    if (request == uploadFile1) {
        NSLog(@"%@ completed!", request);
        if (flagUploadResumeOrNotApplySubmit ==TRUE) {
            flagUploadResumeOrNotApplySubmit = FALSE;
            uploadSucessApplySubmit = @"TRUE";
        }else{
            //uploadSucessApplySubmit = @"FALSE";
        }
        [HUD1 hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"File uploaded successfully"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        uploadFile1 = nil;
    }
}

-(void) requestFailed:(BRRequest *) request {
    
    if (request == uploadFile1) {
        
        NSLog(@"%@", request.error.message);
        
        //        [HUD1 hide:YES];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
        //                                                        message:@"Some error occured while uploading the document. Please try again."
        //                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        uploadFile1 = nil;
    }else{
        
        
        NSLog(@"Avinash unknown error apply submit");
        [HUD1 hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Some error occured while uploading the document. Please try again."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        uploadFile1 = nil;
    }
}

- (NSData *) requestDataToSend: (BRRequestUpload *) request {
    NSData *temp = uploadData;   // this is a shallow copy of the pointer
    uploadData = nil;            // next time around, return nil...
    return temp;
}

- (IBAction) cancelAction :(id)sender {
    if (uploadFile1) {
        [uploadFile1 cancelRequest];
    }
}

// Picker view single tap
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    CGRect frame = myPicker.frame;
    CGRect selectorFrame = CGRectInset(frame, 0.0, myPicker.bounds.size.height * 0.85 / 2.0);
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        
        if (flagReferrenceApplySubmit == TRUE) {
            
            flagReferrenceApplySubmit = FALSE;
            [textFieldReferrence setText:[[arrayPickerData valueForKey:@"Name"] objectAtIndex:[myPicker selectedRowInComponent:0]]];
            stringReferrenceApplySubmit = [[arrayPickerData valueForKey:@"ID"] objectAtIndex:[myPicker selectedRowInComponent:0]];
            NSLog(@"stringReferrenceMyProfile :%@",stringReferrenceApplySubmit);
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
    if ([applyConditionSumit isEqualToString:@"ApplyWithOutLogin"]) {
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"MemberID",
                                       stringResumeIdUpload,@"ResumeID",
                                       @"",@"DescriptiveName",
                                       stringResumeFileNameApplySubmit,@"FileName",
                                       @"",@"theFile",
                                       @"0",@"FileUploadID",
                                       stringCoverFileNameApplySubmit,@"CoverTitle",
                                       @"",@"CoverLetter",
                                       stringCoverFileNameApplySubmit,@"FullFileName",
                                       @"0",@"CLID",
                                       stringReferrenceApplySubmit,@"ReferredBy",
                                       @"",@"CLFolderName",
                                       nil];
        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
        
        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
        [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
    }else{
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"],@"MemberID",
                                       stringResumeIdUpload,@"ResumeID",
                                       @"",@"DescriptiveName",
                                       stringResumeFileNameApplySubmit,@"FileName",
                                       @"",@"theFile",
                                       @"0",@"FileUploadID",
                                       stringCoverFileNameApplySubmit,@"CoverTitle",
                                       @"",@"CoverLetter",
                                       stringCoverFileNameApplySubmit,@"FullFileName",
                                       @"0",@"CLID",
                                       stringReferrenceApplySubmit,@"ReferredBy",
                                       @"",@"CLFolderName",
                                       nil];
        NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
        
        [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
        [jsonParser2 parseSoapWithJSONSoapContents:dictToSend];
        
    }
}

-(void)callWebServiceNewJobApply {
    flagApplyNewJob = TRUE;
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
    NSString *strinJobId = appDelegate.stringJobIdCreateProfile;
    NSString *stringmemberId;
    if ([applyConditionSumit isEqualToString:@"ApplyWithOutLogin"]) {
        stringmemberId = @"0";
    }else{
        stringmemberId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"];
    }
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:strinJobId,@"JobID",
                                   stringmemberId,@"MemberID",
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
                                   stringResumeFileNameApplySubmit,@"ResumeFileName",
                                   stringResumeFileNameApplySubmitText,@"DescriptiveName",
                                   stringResumeIdUpload,@"ResumeUploadID",
                                   @"",@"siteURL",
                                   stringCoverFileNameApplySubmit,@"CoverLetterFileName",
                                   stringCoverFileNameApplySubmitText,@"CoverLetter",
                                   @"",@"DEVICEID",
                                   @"",@"ApplyURL",
                                   @"",@"DesiredSalary",
                                   @"",@"CommutingDistance",
                                   @"",@"Relocate",
                                   @"",@"RelocateWhen",
                                   stringIdIndustryApply,@"iType",
                                   stringIdCareersApply,@"cType",
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
    
    if (flagReferrenceApplySubmit == TRUE) {
        
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
    //    if (flagSubmitApplySubmit == TRUE) {
    //        flagSubmitApplySubmit = FALSE;
    //        [HUD hide:YES];
    //        [self.tabBarController.view setUserInteractionEnabled:YES];
    //        NSError *error;
    //        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
    //                                                   options: NSJSONReadingMutableContainers
    //                                                     error: &error];
    //        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
    //            [self callWebServiceNewJobApply];
    //            //            alertSuccess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully applied to this job." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
    //            //            [alertSuccess show];
    //        }else{
    //            [self showAlertViewWithMessage:@"Some error occured. Please try again later." withTitle:@"Error"];
    //        }
    //    }
    if (flagApplyNewJob == TRUE) {
        flagApplyNewJob = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDict = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
        if ([[JSONDict valueForKey:@"Success"]intValue]==1) {
            uploadSucessApplySubmit = @"FALSE";
            
            alertSuccessApply = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully applied to this job." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [alertSuccessApply show];
            
        }else{
            [self showAlertViewWithMessage:@"Some error occured. Please try again later." withTitle:@"Error"];
        }
    }
    if (flagGetResumeListApply == TRUE) {
        flagGetResumeListApply = FALSE;
        [HUD hide:YES];
        [self.tabBarController.view setUserInteractionEnabled:YES];
        NSError *error;
        JSONDictResumeList = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                             options: NSJSONReadingMutableContainers
                                                               error: &error];
        if ([[JSONDictResumeList objectForKey:@"ErrorMsg"]isEqualToString:@"Fail"]) {
            [switchResumeFrist setHidden:YES];
            [switchResumeSecond setHidden:YES];
            [labelResumeFirst setText:@""];
            [labelResumeSecond setText:@""];
        }else{
            
            if ([[JSONDictResumeList objectForKey:@"ResumesList"]count]== 0) {
                [labelResumeName setText:@"Select Resume"];
                buttonBrowse.enabled = YES;
                buttonUpload.enabled = YES;
                [switchResumeFrist setHidden:YES];
                [switchResumeSecond setHidden:YES];
                [labelResumeFirst setText:@""];
                [labelResumeSecond setText:@""];
            }
            if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==1){
                [labelResumeFirst setText:[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"FileName"]];
                [labelResumeSecond setText:@""];
                [switchResumeSecond setHidden:YES];
            }
            if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==2){
                
                [labelResumeName setText:@"Select Resume"];
                
                [buttonBrowse setHidden:YES];
                [buttonUpload setHidden:YES];
                
                [labelResumeFirst setText:[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"FileName"]];
                [labelResumeSecond setText:[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:1]valueForKey:@"FileName"]];
            }
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
        //HUD1 = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        flagUploadResumeApplySubmit = TRUE;
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
    //    [self uploadFileToServer];
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
        flagUploadCoverApplySubmit = TRUE;
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
    //    [self uploadFileToServer];
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
        flagReferrenceApplySubmit = TRUE;
        [self callWebServiceReferrence];
    }
}

- (IBAction)buttonActionCancel:(id)sender {
    flagReferrenceApplySubmit = FALSE;
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
    }else {
        
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
            if ([switchResumeFrist isOn]==TRUE || [switchResumeSecond isOn]==TRUE) {
                if (switchAccept.isOn == TRUE) {
                    flagSubmitApplySubmit = TRUE;
                    if ([switchResumeFrist isOn]==TRUE) {
                        stringResumeFileNameApplySubmit = myResume;
                        stringResumeFileNameApplySubmitText = labelResumeFirst.text;
                        if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                            stringCoverFileNameApplySubmit = @"";
                            stringCoverFileNameApplySubmitText = @"";
                        }else{
                            stringCoverFileNameApplySubmit = myCover;//labelCoverLetterName.text;
                            stringCoverFileNameApplySubmitText = labelCoverLetterName.text;
                        }
                        stringResumeIdUpload = [[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"ResumeID"];
                    }else{
                        stringResumeFileNameApplySubmit = myResume;
                        stringResumeFileNameApplySubmitText = labelResumeSecond.text;
                        if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                            stringCoverFileNameApplySubmit = @"";
                            stringCoverFileNameApplySubmitText = @"";
                        }else{
                            stringCoverFileNameApplySubmit = myCover;//labelCoverLetterName.text;
                            stringCoverFileNameApplySubmitText = labelCoverLetterName.text;
                        }
                        stringResumeIdUpload = [[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:1]valueForKey:@"ResumeID"];
                    }
                    //[self callWebServiceSaveResumeFile];
                    [self callWebServiceNewJobApply];
                }else{
                    [self showAlertViewWithMessage:@"Please accept the AgCareers TOS" withTitle:@"Error"];
                }
            }else {
                [self showAlertViewWithMessage:@"Please upload resume file" withTitle:@"Error"];
            }
        }
        if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==1) {
            if ([switchResumeFrist isOn]==TRUE) {
                if (switchAccept.isOn == TRUE) {
                    flagSubmitApplySubmit = TRUE;
                    stringResumeFileNameApplySubmit = myResume;
                    stringResumeFileNameApplySubmitText = labelResumeFirst.text;
                    if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                        stringCoverFileNameApplySubmit = @"";
                        stringCoverFileNameApplySubmitText = @"";
                    }else{
                        stringCoverFileNameApplySubmit = myCover;//labelCoverLetterName.text;
                        stringCoverFileNameApplySubmitText = labelCoverLetterName.text;
                    }
                    stringResumeIdUpload = [[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"ResumeID"];
                    //[self callWebServiceSaveResumeFile];
                    [self callWebServiceNewJobApply];
                    
                }else{
                    [self showAlertViewWithMessage:@"Please accept the AgCareers TOS" withTitle:@"Error"];
                }
            }else if([uploadSucessApplySubmit isEqualToString:@"TRUE"]) {
                if (switchAccept.isOn == TRUE) {
                    flagSubmitApplySubmit = TRUE;
                    stringResumeFileNameApplySubmit = myResume;//labelResumeName.text;
                    stringResumeFileNameApplySubmitText = labelResumeName.text;
                    if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                        stringCoverFileNameApplySubmit = @"";
                        stringCoverFileNameApplySubmitText = @"";
                    }else{
                        stringCoverFileNameApplySubmit = myCover;//labelCoverLetterName.text;
                        stringCoverFileNameApplySubmitText = labelCoverLetterName.text;
                    }
                    
                    stringResumeIdUpload = @"0";//[[[JSONDictResumeList objectForKey:@"ResumesList"]objectAtIndex:0]valueForKey:@"ResumeID"];
                    
                    //[self callWebServiceSaveResumeFile];
                    [self callWebServiceNewJobApply];
                }else{
                    [self showAlertViewWithMessage:@"Please accept the AgCareers TOS" withTitle:@"Error"];
                }
            }else{
                [self showAlertViewWithMessage:@"Please upload resume file" withTitle:@"Error"];
            }
        }
        if([[JSONDictResumeList objectForKey:@"ResumesList"]count]==0){
            
            if ([uploadSucessApplySubmit isEqualToString:@"TRUE"]) {
                if (switchAccept.isOn == TRUE) {
                    stringResumeFileNameApplySubmit = myResume;//[NSString stringWithFormat:@"%@",labelResumeName.text];
                    stringResumeFileNameApplySubmitText = labelResumeName.text;
                    if ([labelCoverLetterName.text isEqualToString:@"Select cover letter"]) {
                        stringCoverFileNameApplySubmit = @"";
                        stringCoverFileNameApplySubmitText = @"";
                    }else{
                        stringCoverFileNameApplySubmit = myCover;//labelCoverLetterName.text;
                        stringCoverFileNameApplySubmitText = labelCoverLetterName.text;
                    }
                    flagSubmitApplySubmit = TRUE;
                    //[self callWebServiceSaveResumeFile];
                    
                    stringResumeIdUpload = @"0";
                    
                    [self callWebServiceNewJobApply];
                    
                }else{
                    [self showAlertViewWithMessage:@"Please accept the AgCareers TOS" withTitle:@"Error"];
                }
            }else {
                [self showAlertViewWithMessage:@"Please upload resume file" withTitle:@"Error"];
            }
        }
    }
}

-(void)showAlertViewWithMessage :(NSString *)message withTitle : (NSString *)title {
    alertForCheck = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertForCheck show];
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alertSuccess) {
        if (buttonIndex == 0) {
            [self.tabBarController setSelectedIndex:0];
        }
    }
    if (alertView == alertSuccessApply) {
        if (buttonIndex == 0) {
            if (self.tabBarController.selectedIndex == 1) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }else{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
    }
}

- (IBAction)switchActionResumeFirst:(id)sender{
    if ([switchResumeFrist isOn]==TRUE) {
        [switchResumeSecond setOn:FALSE];
    }else{
        [switchResumeSecond setOn:TRUE];
    }
}

- (IBAction)switchActionResumeSecond:(id)sender{
    if ([switchResumeSecond isOn]==TRUE) {
        [switchResumeFrist setOn:FALSE];
    }else{
        [switchResumeFrist setOn:TRUE];
    }
}

@end
