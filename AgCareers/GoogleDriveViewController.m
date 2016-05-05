//
//  GoogleDriveViewController.m
//  AgCareers
//
//  Created by Unicorn on 18/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "GoogleDriveViewController.h"
#import "GTLDrive.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "QEUtilities.h"

// Constants used for OAuth 2.0 authorization.
static NSString *const kKeychainItemName = @"iOSDriveSample: Google Drive";
static NSString *const kClientId = @"815397403816-j54p4ugt430gio35hpg2ap246n5rfnb4.apps.googleusercontent.com";//@"826331608693-h8q7u9cjo5pmpdbllej45i6cn0mtdcng.apps.googleusercontent.com";
static NSString *const kClientSecret = @"VDbJcHYI3r_XxwEZwG5jxVdM";//@"Kb0oqsw5YGuKk-14_n2jgqAQ";

@interface GoogleDriveViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *authButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (weak, readonly) GTLServiceDrive *driveService;
@property (retain) NSMutableArray *driveFiles;
@property BOOL isAuthorized;

- (IBAction)authButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;

- (void)toggleActionButtons:(BOOL)enabled;
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error;
- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth;
- (void)loadDriveFiles;


@end

@interface NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options;

@end

@implementation NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end

@implementation GoogleDriveViewController
@synthesize addButton = _addButton;
@synthesize authButton = _authButton;
@synthesize refreshButton = _refreshButton;
@synthesize driveFiles = _driveFiles;
@synthesize isAuthorized = _isAuthorized;
@synthesize googleDriveTableView;
@synthesize buttonCancel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check for authorization.
    GTMOAuth2Authentication *auth =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientId
                                                      clientSecret:kClientSecret];
    if ([auth canAuthorize]) {
        [self isAuthorizedWithAuthentication:auth];
    }
    
    // Refresh control
    refreshControl = [[UIRefreshControl alloc]init];
    [googleDriveTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    //TODO: refresh your data
    
    [self refreshButtonClicked:self];
    
    [refreshControl endRefreshing];
    [googleDriveTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Sort Drive Files by modified date (descending order).
    [self.driveFiles sortUsingComparator:^NSComparisonResult(GTLDriveFile *lhs,
                                                             GTLDriveFile *rhs) {
        return [rhs.modifiedDate.date compare:lhs.modifiedDate.date];
    }];
    [googleDriveTableView reloadData];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Alertview delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        // Delete or Remove files from document directory
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Resume"] isEqualToString:@"BrowseResume"]) {
            NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Resume/"];
            NSFileManager *localFileManager=[[NSFileManager alloc] init];
            NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
            
            NSString *fileDoc;
            NSError *error;
            
            while ((fileDoc = [dirEnum nextObject])) {
                
                NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docsDir,fileDoc];
                // process the document
                //[localFileManager removeItemAtPath: fullPath error:&error ]; // This will remove all files from document directory
                [localFileManager removeItemAtPath: fullPath error:&error];
            }
        }
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Cover"] isEqualToString:@"BrowseCover"]) {
            NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cover/"];
            NSFileManager *localFileManager=[[NSFileManager alloc] init];
            NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:docsDir];
            NSString *fileDoc;
            NSError *error;
            while ((fileDoc = [dirEnum nextObject])) {
                
                NSString *fullPath = [NSString stringWithFormat:@"%@/%@", docsDir,fileDoc];
                // process the document
                //[localFileManager removeItemAtPath: fullPath error:&error ]; // This will remove all files from document directory
                [localFileManager removeItemAtPath: fullPath error:&error ];
            }
        }
        
        
        NSIndexPath *indexPath = [googleDriveTableView indexPathForSelectedRow];
        
        GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
        //////////////////////////////////////
        NSString *downloadURL=[[self.driveFiles objectAtIndex:indexPath.row] downloadUrl];
        GTMHTTPFetcher *fetcher =
        [self.driveService.fetcherService fetcherWithURLString:downloadURL];
        
        UIAlertView *alert = [QEUtilities showLoadingMessageWithTitle:@"Downloading file" delegate:self];
        self.authButton.enabled = NO;
        buttonCancel.enabled = NO;
        [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            self.authButton.enabled = YES;
            buttonCancel.enabled = YES;
            
            NSLog(@"%@",file.fileSize);
            NSLog(@"%@",file.title);
            
            if(file.downloadUrl!= nil) {
                
                if (data!=nil) {
                    
                    //filename = file.title;
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Resume"] isEqualToString:@"BrowseResume"]) {
                        
                        NSString *dataPathResume = [documentsDirectory stringByAppendingPathComponent:@"/Resume"];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPathResume])
                            [[NSFileManager defaultManager] createDirectoryAtPath:dataPathResume withIntermediateDirectories:NO attributes:nil error:&error]; // Create folder
                        //Original
                        //documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"AvinashResume %@",file.title]];
                        NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
                        NSMutableString *stringRandom = [NSMutableString stringWithCapacity:10];
                        for (NSUInteger i = 0U; i < 10; i++) {
                            u_int32_t r = arc4random() % [alphabet length];
                            unichar c = [alphabet characterAtIndex:r];
                            [stringRandom appendFormat:@"%C", c];
                        }
                        
                        dataPathResume = [dataPathResume stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",stringRandom,file.title]];

                        //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Resume"];
                        [data writeToFile:dataPathResume atomically:YES];
                        
                    }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Cover"] isEqualToString:@"BrowseCover"]){
                        
                        NSString *dataPathCover = [documentsDirectory stringByAppendingPathComponent:@"/Cover"];
                        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPathCover])
                            [[NSFileManager defaultManager] createDirectoryAtPath:dataPathCover withIntermediateDirectories:NO attributes:nil error:&error]; // Create folder
                        NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
                        NSMutableString *stringRandom = [NSMutableString stringWithCapacity:10];
                        for (NSUInteger i = 0U; i < 10; i++) {
                            u_int32_t r = arc4random() % [alphabet length];
                            unichar c = [alphabet characterAtIndex:r];
                            [stringRandom appendFormat:@"%C", c];
                        }
                        dataPathCover = [dataPathCover stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",stringRandom,file.title]];
                        //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Cover"];
                        [data writeToFile:dataPathCover atomically:YES];
                        //                        documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"AvinashCover %@",file.title]];
                    }else{
                        documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",file.title]];
                    }
                    
                    //Original
                    //[data writeToFile:documentsDirectory atomically:YES];
                    
                    NSLog(@"my path:%@",documentsDirectory);
                }
            }
            else {
                NSLog(@"Error - %@", error.description);
            }
        }];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.driveFiles count] == 0) {
        return 2;
    }else {
        return self.driveFiles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.driveFiles count]==0) {
        // There are no files in the directory - let the user know
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            
            GTMOAuth2Authentication *auth =
            [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                  clientID:kClientId
                                                              clientSecret:kClientSecret];
            if ([auth canAuthorize]) {
                cell.textLabel.text = NSLocalizedString(@"Folder is Empty", @"DropboxBroswer: Empty Folder Text");
            }else{
                cell.textLabel.text = NSLocalizedString(@"Please Sign in", @"DropboxBroswer: Empty Folder Text");
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
        }
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoogleCell"];
        
        GTLDriveFile *file = [self.driveFiles objectAtIndex:indexPath.row];
        
        cell.textLabel.text = file.title;
        
        if ([file.title rangeOfString:@".doc" ].location != NSNotFound || [file.title rangeOfString:@".docx" ].location != NSNotFound) {
            cell.imageView.image =[UIImage imageNamed:@"page_white_word.png"];
        }
        else if ([file.title rangeOfString:@".txt" ].location != NSNotFound) {
            cell.imageView.image = [UIImage imageNamed:@"page_white_text.png"];
        }
        else if ([file.title rangeOfString:@".pdf" ].location != NSNotFound) {
            cell.imageView.image = [UIImage imageNamed:@"page_white_acrobat.png"];
        }
        else if ([file.title rangeOfString:@".xls" ].location != NSNotFound || [file.title rangeOfString:@".xlsx" ].location != NSNotFound) {
            cell.imageView.image = [UIImage imageNamed:@"page_white_excel.png"];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"page_white_import.png"];
        }
        return cell;
    }
    /******* Category test  *********/
    /*
     NSString *someString = @"Here is my string";
     NSRange isRange = [someString rangeOfString:@"is " options:NSCaseInsensitiveSearch];
     if(isRange.location == 0) {
     //found it...
     } else {
     NSRange isSpacedRange = [someString rangeOfString:@" is " options:NSCaseInsensitiveSearch];
     if(isSpacedRange.location != NSNotFound) {
     //found it...
     }
     }
     */
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.driveFiles count] > 0) {
        alertDownload = [[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Do you want to download this file?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertDownload show];
    }
}

- (NSInteger)didUpdateFileWithIndex:(NSInteger)index
                          driveFile:(GTLDriveFile *)driveFile {
    if (index == -1) {
        if (driveFile != nil) {
            // New file inserted.
            [self.driveFiles insertObject:driveFile atIndex:0];
            index = 0;
        }
    } else {
        if (driveFile != nil) {
            // File has been updated.
            [self.driveFiles replaceObjectAtIndex:index withObject:driveFile];
        } else {
            // File has been deleted.
            [self.driveFiles removeObjectAtIndex:index];
            index = -1;
        }
    }
    return index;
}

- (GTLServiceDrive *)driveService {
    static GTLServiceDrive *service = nil;
    
    if (!service) {
        service = [[GTLServiceDrive alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    }
    return service;
}


- (IBAction)authButtonClicked:(id)sender {
#pragma mark googel drive all files display
    // All files display initwithscope
    // change kGTLAuthScopeDriveFile to kGTLAuthScopeDrive
    
    if (!self.isAuthorized) {
        // Sign in.
        SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
        GTMOAuth2ViewControllerTouch *authViewController =
        [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDrive
                                                   clientID:kClientId
                                               clientSecret:kClientSecret
                                           keychainItemName:kKeychainItemName
                                                   delegate:self
                                           finishedSelector:finishedSelector];
        [self presentModalViewController:authViewController
                                animated:YES];
    } else {
        // Sign out
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        [[self driveService] setAuthorizer:nil];
        self.authButton.title = @"Sign in";
        self.isAuthorized = NO;
        [self toggleActionButtons:NO];
        [self.driveFiles removeAllObjects];
        [googleDriveTableView reloadData];
    }
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self loadDriveFiles];
}

- (void)toggleActionButtons:(BOOL)enabled {
    self.addButton.enabled = enabled;
    self.refreshButton.enabled = enabled;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
    if (error == nil) {
        [self isAuthorizedWithAuthentication:auth];
    }
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth {
    [[self driveService] setAuthorizer:auth];
    self.authButton.title = @"Sign out";
    self.isAuthorized = YES;
    [self toggleActionButtons:YES];
    [self loadDriveFiles];
}

- (void)loadDriveFiles {
    
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesList];
    query.q = @" mimeType = 'application/pdf' or mimeType = 'text/plain' or mimeType = 'application/msword' or mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ";
//    query.q = @" mimeType = 'application/pdf' or mimeType = 'text/plain' or mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or mimeType = 'application/msword' or mimeType = 'application/vnd.google-apps.document' or mimeType = 'application/vnd.google-apps.kix' or mimeType = 'application/vnd.google-apps.drawing' or mimeType = 'application/vnd.google-apps.file' or mimeType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ";
    //////////////// MIME Types //////////////////
    /*
     "xls"      =>'application/vnd.ms-excel',
     "xlsx"     =>'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     "xml"      =>'text/xml',
     "ods"      =>'application/vnd.oasis.opendocument.spreadsheet',
     "csv"      =>'text/plain',
     "tmpl"     =>'text/plain',
     "pdf"      => 'application/pdf',
     "php"      =>'application/x-httpd-php',
     "jpg"      =>'image/jpeg',
     "png"      =>'image/png',
     "gif"      =>'image/gif',
     "bmp"      =>'image/bmp',
     "txt"      =>'text/plain',
     "doc"      =>'application/msword',
     "js"       =>'text/js',
     "swf"      =>'application/x-shockwave-flash',
     "mp3"      =>'audio/mpeg',
     "zip"      =>'application/zip',
     "rar"      =>'application/rar',
     "tar"      =>'application/tar',
     "arj"      =>'application/arj',
     "cab"      =>'application/cab',
     "html"     =>'text/html',
     "htm"      =>'text/html',
     "default"  =>'application/octet-stream',
     "folder"   =>'application/vnd.google-apps.folder'
     
     .au        => audio/basic
     .avi       => video/msvideo, video/avi, video/x-msvideo
     .bmp       => image/bmp
     .bz2       => application/x-bzip2
     .css       => text/css
     .dtd       => application/xml-dtd
     .doc       => application/msword
     .docx      => application/vnd.openxmlformats-officedocument.wordprocessingml.document
     .dotx      => application/vnd.openxmlformats-officedocument.wordprocessingml.template
     .es        => application/ecmascript
     .exe       => application/octet-stream
     .gif       => image/gif
     .gz        => application/x-gzip
     .hqx       => application/mac-binhex40
     .html      => text/html
     .jar       => application/java-archive
     .jpg       => image/jpeg
     .js        => application/x-javascript
     .midi      => audio/x-midi
     .mp3       => audio/mpeg
     .mpeg      => video/mpeg
     .ogg       => audio/vorbis, application/ogg
     .pdf       => application/pdf
     .pl        => application/x-perl
     .png       => image/png
     .potx      => application/vnd.openxmlformats-officedocument.presentationml.template
     .ppsx      => application/vnd.openxmlformats-officedocument.presentationml.slideshow
     .ppt       => application/vnd.ms-powerpointtd>
     .pptx      => application/vnd.openxmlformats-officedocument.presentationml.presentation
     .ps        => application/postscript
     .qt        => video/quicktime
     .ra        => audio/x-pn-realaudio, audio/vnd.rn-realaudio
     .ram       => audio/x-pn-realaudio, audio/vnd.rn-realaudio
     .rdf       => application/rdf, application/rdf+xml
     .rtf       => application/rtf
     .sgml      => text/sgml
     .sit       => application/x-stuffit
     .sldx      => application/vnd.openxmlformats-officedocument.presentationml.slide
     .svg       => image/svg+xml
     .swf       => application/x-shockwave-flash
     .tar.gz	=> application/x-tar
     .tgz       => application/x-tar
     .tiff      => image/tiff
     .tsv       => text/tab-separated-values
     .txt       => text/plain
     .wav       => audio/wav, audio/x-wav
     .xlam      => application/vnd.ms-excel.addin.macroEnabled.12
     .xls       => application/vnd.ms-excel
     .xlsb      => application/vnd.ms-excel.sheet.binary.macroEnabled.12
     .xlsx      => application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
     .xltx      => application/vnd.openxmlformats-officedocument.spreadsheetml.template
     .xml       => application/xml
     .zip       => application/zip, application/x-compressed-zip
     */
    
    UIAlertView *alert = [QEUtilities showLoadingMessageWithTitle:@"Loading files" delegate:self];
    
    [self.driveService executeQuery:query completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFileList *files,
                                                              NSError *error) {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        if (error == nil) {
            if (self.driveFiles == nil) {
                self.driveFiles = [[NSMutableArray alloc] init];
            }
            [self.driveFiles removeAllObjects];
            [self.driveFiles addObjectsFromArray:files.items];
            [googleDriveTableView reloadData];
        } else {
            NSLog(@"An error occurred: %@", error);
            [QEUtilities showErrorMessageWithTitle:@"Unable to load files"
                                           message:[error description]
                                          delegate:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)buttonActionCancel:(id)sender {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Resume"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Cover"];

    [self.navigationController popViewControllerAnimated:YES];
}
@end
