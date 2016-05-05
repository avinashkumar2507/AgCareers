//
//  SearchViewController.m
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "SearchViewController.h"
#import <AddressBook/AddressBook.h>
#import "SelectSectorsViewController.h"
#import "SelectTypesViewController.h"
#import "SelectCareersViewController.h"
#import "SearchResultViewController.h"
#import "LoginPopOverViewController.h"
#import <Google/Analytics.h>
@interface SearchViewController ()
@property (strong ,nonatomic)NSString *(^printHi)(void);
@property (strong, nonatomic)int (^addition)(int,int);
@end

@implementation SearchViewController
@synthesize scrollViewSearch,viewSearch,textFieldEmployer,textFieldLocation,buttonTest,buttonLocation,textFieldCareer,textFieldSector,textFieldType,textFieldKeyword;
@synthesize dictionarySectors,arraySectors;

@synthesize viewNavigation;
NSString *_postalCode          = @"";
NSString *_country             = @"";
NSString *_administrativeArea  = @"";
NSString *currentLat           = @"";
NSString *currentLog           = @"";
NSString *stringEmpoloyerId;

int heightForScrollView = 450;
BOOL isShowMessage = FALSE;
BOOL isActive = FALSE;
BOOL isCriticalUpdate = FALSE;
BOOL isOnetime        = FALSE;
NSString *Message        = @"";
NSString *newVersion     = @"";
NSString *Success        = @"";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setGlobalValues];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationHasBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    NSUserActivity *newact = [[NSUserActivity alloc]initWithActivityType:@"com.agcareers.iphone"];
    newact.title = @"AgCareers";
    newact.eligibleForSearch = YES;
    
    NSSet *mySet = [[NSSet alloc]initWithObjects:@"Ag",@"AgCareer",@"Agriculture",@"Resume",@"Dropbox",@"Google Drive", nil];
    
    [newact setKeywords:mySet];
    self.userActivity = newact;
    newact.eligibleForHandoff = false;
    [newact becomeCurrent];
    
    NSError *error;
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dataPathResume = [documentsPath stringByAppendingPathComponent:@"/Resume"];
    NSString *dataPathCover = [documentsPath stringByAppendingPathComponent:@"/Cover"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPathResume])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPathResume withIntermediateDirectories:NO attributes:nil error:&error]; // Create folder
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPathCover])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPathCover withIntermediateDirectories:NO attributes:nil error:&error]; // Create folder
    
    textFieldKeyword.placeholder = [NSString stringWithFormat:@"%@ Jobs Title, Keywords",[[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D" ]] ;
    
    NSArray *myChoices = @[ @"A", @"B", @"C" ];
    
    NSMutableArray *result;
    
    [myChoices enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop) {
        
        if ( [obj isEqualToString:@"B"] ) {
            
            [result addObject:obj];
            
            *stop = YES;
        }
    }];
    
    NSLog( @"Result: %@", result.count ? result[ 0 ] : @"Not found" );
    [self viewDidLayoutSubviews];
    //[buttonLocation setHidden:YES];
    arraySectors = [[NSMutableArray alloc]init];
    dictionarySectors = [[NSMutableDictionary alloc] init];
    dictionaryTypes = [[NSMutableDictionary alloc] init];
    dictionaryCareers = [[NSMutableDictionary alloc] init];
    ////////////////////////////////////////////////////////////////////
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    [CLLocationManager locationServicesEnabled];
    // Check for iOS 8. and request location when App is in use
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    //////////////////////////////////////////////////////////////////////
    textFieldEmployer.delegate = self;
    
    [self callWebService];
}

-(void)applicationHasBecomeActive{
    [self callWebService];
}

-(void)setGlobalValues {
    /* Staging */
    [[NSUserDefaults standardUserDefaults]setValue:@"http://staging.agcareers.com/mobilewsnative/webservice/newjobsearch.asmx/" forKey:@"GlobalURL"];
    [[NSUserDefaults standardUserDefaults]setValue:@"http://staging.agcareers.com" forKey:@"JobShare"];
    [[NSUserDefaults standardUserDefaults]setValue:@"http://mstaging.agcareers.com/" forKey:@"MorePageURL"];
    [[NSUserDefaults standardUserDefaults]setValue:@"staging.agcareers.com" forKey:@"GlobalHost"];
    [[NSUserDefaults standardUserDefaults]setValue:@"216.220.44.186" forKey:@"GlobalFTP"];

    /* Production */
//    [[NSUserDefaults standardUserDefaults]setValue:@"http://www.agcareers.com/mobilewsnative/WebService/newjobsearch.asmx/" forKey:@"GlobalURL"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"http://www.agcareers.com" forKey:@"JobShare"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"http://m.agcareers.com/" forKey:@"MorePageURL"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"www.agcareers.com" forKey:@"GlobalHost"];
//    [[NSUserDefaults standardUserDefaults]setValue:@"216.220.44.165" forKey:@"GlobalFTP"];
}

- (void)getWebDomain{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    NSString *urlAsString = [NSString stringWithFormat:@"http://m.agcareers.com/webservice/agcareers.domains.cfc?method=getDomains"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            //[self.delegate fetchingGroupsFailedWithError:error];
        }else {
            //[self.delegate receivedGroupsJSON:data];
            
            //NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
            
            //NSString *someString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            JSONDict = [NSJSONSerialization JSONObjectWithData: data
                                                       options: NSJSONReadingMutableContainers
                                                         error: &error];
            
            NSString *webURLString = [NSString stringWithFormat:@"http://%@/mobilews/WebService/NewJobSearch.asmx/",[JSONDict valueForKey:@"WEB"]];
            NSString *moreURLString = [NSString stringWithFormat:@"http://%@/",[JSONDict valueForKey:@"MOBILE"]];
            [[NSUserDefaults standardUserDefaults]setValue:webURLString forKey:@"GlobalURL"];
            [[NSUserDefaults standardUserDefaults]setValue:moreURLString forKey:@"MorePageURL"];
            [[NSUserDefaults standardUserDefaults]setValue:[JSONDict valueForKey:@"WEB"] forKey:@"GlobalHost"];
            [[NSUserDefaults standardUserDefaults]setValue:[JSONDict valueForKey:@"FTP"] forKey:@"GlobalFTP"];
            
            
            //http://staging.agcareers.com/mobilewsnative/webservice/newjobsearch.asmx
            // host : staging.agcareers.com
            // FTP : 216.220.44.186
            // More page url : http://mstaging.agcareers.com/
            // web url : http://staging.agcareers.com/mobilews/WebService/NewJobSearch.asmx/
            [HUD hide:YES];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *parsed = [inFormat dateFromString:dateString];
    
    NSLog(@"\n"
          "now:        |%@| \n"
          "dateString: |%@| \n"
          "parsed:     |%@|", now, dateString, parsed);
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"iOS- Advanced Search Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    NSString *(^myName)(void);
    
    myName = ^(void){
        return @"Avinash";
    };
    
    NSLog(@"%@",myName());
    
    int (^addition)(int,int);
    
    addition = ^(int a,int b){
        return a+b;
    };
    
    NSLog(@"%d",addition(2,3));
    
    _addition = ^(int a,int b){
        return a+b;
    };
    
    NSLog(@"%d",_addition(2,3));
    
    _printHi = ^(void){
        return @"Hi";
    };
    
    NSLog(@"%@",_printHi());
    
    NSString *(^returnMyName)(void) = ^(void){
        return @"a";
    };
    
    NSLog(@"%@", returnMyName());
    
    NSString * (^returenMyName)(void);
    returenMyName = ^(void){
        return @"avinash";
    };
    
    NSLog(@"%@",returenMyName);
    
    int (^additionNew)(int, int);
    additionNew = ^int(int a,int b){
        return a+b;
    };
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

#pragma mark Call web service
-(void)callWebService {
    
    jsonParser = [APParser sharedParser];
    jsonParser.delegate = self;
    
    [self.tabBarController.view setUserInteractionEnabled:NO ];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    //[HUD show:YES];
    
    NSString* methodName = @"GetCurrentVersion";
    NSString* soapAction = @"http://tempuri.org/GetCurrentVersion";
    
    NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS",@"platform", nil];
    
    NSDictionary* dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict", nil];
    
    [self performSelector:@selector(hideHUDandWebservice) withObject:nil afterDelay:20];
    [jsonParser parseSoapWithJSONSoapContents:dictToSend];
}


-(void)receiveJsonResponse:(NSDictionary*)responseDict withSuccess:(BOOL)successBool {
    
    //[HUD hide:YES];
    
    //[HUD hide:YES];
    
    [self.tabBarController.view setUserInteractionEnabled:YES];
    
    NSError *error;
    JSONDict3433 = [NSJSONSerialization JSONObjectWithData: [[responseDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                   options: NSJSONReadingMutableContainers
                                                     error: &error];
    if ([[JSONDict3433 valueForKey:@"IsActive"]intValue]==1)
        isActive = TRUE;
    else
        isActive = FALSE;
    
    if (isActive == TRUE) {
        if ([[JSONDict3433 valueForKey:@"isShowMessage"]intValue]==1)
            isShowMessage = TRUE;
        else
            isShowMessage = FALSE;
        
        if ([[JSONDict3433 valueForKey:@"IsCriticalUpdate"]intValue]==1){
            isCriticalUpdate = TRUE;
            [[NSUserDefaults standardUserDefaults]setValue:@"TRUE" forKey:@"CriticalUpdateValue"];
            
        }else{
            isCriticalUpdate = FALSE;
            [[NSUserDefaults standardUserDefaults]setValue:@"FALSE" forKey:@"CriticalUpdateValue"];
        }
        
        if ([[JSONDict3433 valueForKey:@"Onetime"]intValue]==1){
            //[[NSUserDefaults standardUserDefaults] setValue:@"O" forKey:@"ONE_TIME"];
            isOnetime = TRUE;
        }else{
            isOnetime = FALSE;
            [[NSUserDefaults standardUserDefaults] setValue:@"O" forKey:@"ONE_TIME"];
        }
        Message = [JSONDict3433 valueForKey:@"Message"];
        newVersion = [JSONDict3433 valueForKey:@"Version"];
        Success = [JSONDict3433 valueForKey:@"Success"];
        
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleShortVersionString"];
        
        NSString *v1 = appVersion;
        NSString *v2 = newVersion;
        
        NSComparisonResult r = [v1 compare:v2 options:NSNumericSearch];
        
        if (r == NSOrderedSame || r == NSOrderedDescending) {
            NSLog(@"true");
        }else {
            NSLog(@"false");
            if (isShowMessage) {
                [self ShowAlert];
            }
        }
    }else{
        
    }
}

-(void)hideHUDandWebservice{
    [HUD hide:YES];
}

-(void)ShowAlert{
    
    if(isCriticalUpdate) {
        
        alertForCriticalUpdate = [[UIAlertView alloc] initWithTitle:@"Update required" message:Message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertForCriticalUpdate show];
    }else {
        if (isOnetime == TRUE) {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ONE_TIME"]isEqualToString:@"ONE"]) {

            } else {
                [[NSUserDefaults standardUserDefaults] setValue:@"ONE" forKey:@"ONE_TIME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                alertForUpdate = [[UIAlertView alloc] initWithTitle:@"Update available" message:Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
                [alertForUpdate show];
            }
        }else{
            alertForUpdate = [[UIAlertView alloc] initWithTitle:@"Update available" message:Message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            [alertForUpdate show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);{
    
    if (alertView == alertForCriticalUpdate){
        if(buttonIndex == 0){
            NSString *iTunesLink = @"https://itunes.apple.com/us/app/agcareers.com-jobs/id760266340?ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }else if(alertView == alertForUpdate){
        if(buttonIndex == 0){
            
        }else{
            NSString *iTunesLink = @"https://itunes.apple.com/us/app/agcareers.com-jobs/id760266340?ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }
}


-(void)viewWillLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [scrollViewSearch setContentSize:CGSizeMake(300, heightForScrollView)];
    }else{
        [scrollViewSearch setContentSize:CGSizeMake(300, heightForScrollView)];
    }
}

-(void)viewDidLayoutSubviews{
    [viewSearch sizeToFit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
}

- (void) keyboardWillShow:(NSNotification *)note {
    
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    NSLog(@"Keyboard Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // move the view up by 30 pts
    CGRect frame = self.view.frame;
    frame.origin.y = -50;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    
    // move the view back to the origin
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [manager stopUpdatingLocation];
    
    switch([error code]) {
        case kCLErrorNetwork: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User has denied to use current Location " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown network error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLat  = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
        currentLog = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:currentLat forKey:@"latKey"];
        [userDefaults setObject:currentLog forKey:@"logKey"];
        [userDefaults synchronize];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/xml?latlng=%@,%@&sensor=true",currentLat,currentLog]]];
        [request setHTTPMethod:@"POST"];
        [locationManager stopUpdatingLocation];
    }
    [locationManager stopUpdatingLocation];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _postalCode = placemark.postalCode;
            _country = placemark.country;
            _administrativeArea = placemark.administrativeArea;
            NSLog(@"postalCode          :%@",_postalCode);
            NSLog(@"country             :%@",placemark.country);
            NSLog(@"administrativeArea  :%@",placemark.administrativeArea);
            NSLog(@"locality            :%@",placemark.locality);
            NSLog(@"thoroughfare        :%@",placemark.thoroughfare);
            NSLog(@"subThoroughfare     :%@",placemark.subThoroughfare);
            NSLog(@"subLocality         :%@",placemark.subLocality);
            NSLog(@"name                :%@",[placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey]);
            //[textFieldLocation setText:[NSString stringWithFormat:@"%@, %@",[placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey],placemark.country]];
            
            //[textFieldLocation setText:[NSString stringWithFormat:@"%@, %@",placemark.administrativeArea,placemark.country]];
            [textFieldLocation setText:[NSString stringWithFormat:@"%@, %@",[placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey],placemark.country]];
        }else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

#pragma mark MPGTextField Delegate Methods
- (NSArray *)dataForPopoverInTextField:(MPGTextField *)textField {
    
    if ([textField isEqual:textFieldEmployer]) {
        if ([textFieldEmployer.text length]>1) {
            [self generateData];
        }
        return data1;
    }else {
        return nil;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    heightForScrollView = 700;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldSelect:(MPGTextField *)textField {
    [self viewWillLayoutSubviews];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    
    if (textField==textField) {
        stringEmpoloyerId = nil;
        if ( [text length] > 0 ) return YES; // adding = OK
        if ( range.length == 1 ){
            return YES; // removing one = OK
        }else {
        }
        if ( [text length] == range.length ) return NO; // remove all != OK
        return YES; // all else is ok (this includes autocorrection, cut/paste things)
    }
    
    return YES;
}

- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result {
    stringEmpoloyerId = [[result valueForKey:@"CustomObject"]valueForKey:@"EmployerID"];
}

- (void)generateData {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        
        NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ConfigFile" ofType:@"plist" ]];
        NSString *webServiceString = [dictRoot objectForKey:@"WebServiceURL"];
        NSString *baseHost = [dictRoot objectForKey:@"BaseHost"];
        
        
        data1 = [[NSMutableArray alloc] init];
        //        static NSString* base_url = @"http://agcareers-ws.farmsstaging.com/mobilews/webservice/newJobSearch.asmx/"; //live
        //        static NSString* base_host = @"agcareers-ws.farmsstaging.com";
        NSString* base_url = webServiceString;
        NSString* base_host = baseHost;
        
        
        NSString * soapActionString = @"http://tempuri.org/GetMemberByKeyWords";
        NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:textFieldEmployer.text,@"SearchText", nil];
        NSString * base = base_url;
        NSError* error = nil;
        NSString* finalUrlString = [base stringByAppendingString:@"GetMemberByKeyWords"];
        NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:100.0];
        [request addValue: soapActionString forHTTPHeaderField:@"SOAPAction"];
        [request addValue:base_host forHTTPHeaderField:@"Host"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:&error];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
        [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                //[ fetchingGroupsFailedWithError:error];
            } else {
                NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:data  options:kNilOptions error:nil];
                NSDictionary *JSONDict1 =
                [NSJSONSerialization JSONObjectWithData: [[returnDict objectForKey:@"d"] dataUsingEncoding:NSUTF8StringEncoding]
                                                options: NSJSONReadingMutableContainers
                                                  error: &error];
                NSArray* contents = [JSONDict1 valueForKey:@"MemberAutoCompletesList"];
                dispatch_async( dispatch_get_main_queue(), ^{
                    // results of the background processing
                    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [data1 addObject:
                         [NSDictionary dictionaryWithObjectsAndKeys:[[obj objectForKey:@"FirstName"] stringByAppendingString:[NSString stringWithFormat:@" %@", [obj objectForKey:@"LastName"]]], @"DisplayText", [obj objectForKey:@"Company"], @"DisplaySubText",obj,@"CustomObject", nil]];
                        [data1 addObject:
                         [NSDictionary dictionaryWithObjectsAndKeys:[obj objectForKey:@"Company"], @"DisplayText", [obj objectForKey:@"Company"], @"DisplaySubText",obj,@"CustomObject", nil]];
                    }];
                });
            }
        }];
    });
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSectorSegue"]) {
        SelectSectorsViewController *selectSectroViewController = [segue destinationViewController];
        selectSectroViewController.delegateSectors = self;
        selectSectroViewController.stringId = [[dictionarySectors objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
    }
    if ([segue.identifier isEqualToString:@"showTypesSegue"]) {
        SelectTypesViewController *selectTypesViewController = [segue destinationViewController];
        selectTypesViewController.delegateTypes = self;
        selectTypesViewController.stringId = [[dictionaryTypes objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
    }
    if ([segue.identifier isEqualToString:@"showCareersSegue"]) {
        SelectCareersViewController *selectCareersViewController = [segue destinationViewController];
        selectCareersViewController.delegateCareers = self;
        selectCareersViewController.stringId = [[dictionaryCareers objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
    }
    if ([segue.identifier isEqualToString:@"searchResultSegue"]) {
        
        SearchResultViewController *searchResultViewController = [segue destinationViewController];
        
        if (stringEmpoloyerId ==nil) {
            searchResultViewController.stringEmpoloyer = @"0";
        }else{
            if ([textFieldEmployer.text length]==0) {
                searchResultViewController.stringEmpoloyer = @"0";
            }else{
                searchResultViewController.stringEmpoloyer = stringEmpoloyerId;
            }
        }
        
        searchResultViewController.stringKeyword = textFieldKeyword.text;
        searchResultViewController.stringLocation = textFieldLocation.text;
        
        if ([[dictionarySectors objectForKey:@"arraySectorIds"]count]==0) {
            searchResultViewController.stringSectors = @"";
        }else{
            searchResultViewController.stringSectors = [[dictionarySectors objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
        }
        
        if ([[dictionaryTypes objectForKey:@"arraySectorIds"]count]==0) {
            searchResultViewController.stringTypes = @"";
        }else{
            searchResultViewController.stringTypes = [[dictionaryTypes objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
        }
        
        if ([[dictionaryCareers objectForKey:@"arraySectorIds"]count]==0) {
            searchResultViewController.stringCareers = @"";
        }else{
            searchResultViewController.stringCareers = [[dictionaryCareers objectForKey:@"arraySectorIds"] componentsJoinedByString:@","];
        }
        
        searchResultViewController.stringFromPageCount = @"1";
        searchResultViewController.stringToPageCount   = @"20";
    }
}

#pragma mark selectSectorsViewController delegate
-(void)sendSectorDictionary : (NSMutableDictionary *)sectorsDictionary{
    NSString *stringSectors = [[sectorsDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    textFieldSector.text = stringSectors;
    dictionarySectors = sectorsDictionary;
    //    NSLog(@"%@",sectorsDictionary);
}

#pragma mark selectTypesViewController delegate
-(void)sendTypesDictionary : (NSMutableDictionary *) typesDictionary{
    NSString *stringSectors = [[typesDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    textFieldType.text = stringSectors;
    dictionaryTypes = typesDictionary;
    //    NSLog(@"%@",typesDictionary);
}

#pragma mark selectCareersViewController delegate
-(void)sendCareersDictionary : (NSMutableDictionary *) careersDictionary{
    NSString *stringSectors = [[careersDictionary objectForKey:@"arraySectorName"] componentsJoinedByString:@","];
    textFieldCareer.text = stringSectors;
    dictionaryCareers = careersDictionary;
    //    NSLog(@"%@",careersDictionary);
}

#pragma mark Button Actions
- (IBAction)buttonActionLocation:(id)sender {
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
        [locationManager startUpdatingLocation];
    }
}

- (IBAction)buttonTestAction:(id)sender {
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
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ,()"] invertedSet];
        if ([textFieldLocation.text rangeOfCharacterFromSet:set].location != NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Special characters are not allowed in Location field." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else {
            //&& stringEmpoloyerId == nil
            if ([textFieldEmployer.text length] > 0 && stringEmpoloyerId == nil ) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered Invalid employer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                [self performSegueWithIdentifier:@"searchResultSegue" sender:self];
            }
            
            //            if ([textFieldEmployer.text length] > 0 && stringEmpoloyerId !=0 ) {
            //                [self performSegueWithIdentifier:@"searchResultSegue" sender:self];
            //            }else{
            //
            //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have entered Invalid employer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //                [alert show];
            //
            //            }
            
            /*
             
             if (stringEmpoloyerId ==nil) {
             searchResultViewController.stringEmpoloyer = @"0";
             }else{
             if ([textFieldEmployer.text length]==0) {
             searchResultViewController.stringEmpoloyer = @"0";
             }else{
             searchResultViewController.stringEmpoloyer = stringEmpoloyerId;
             }
             }
             */
            
        }
    }
}

- (IBAction)buttonActionSector:(id)sender {
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
        [self performSegueWithIdentifier:@"showSectorSegue" sender:self];
    }
}
- (IBAction)buttonActionType:(id)sender {
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
        [self performSegueWithIdentifier:@"showTypesSegue" sender:self];
    }
}

- (IBAction)buttonActionCareer:(id)sender {
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
        [self performSegueWithIdentifier:@"showCareersSegue" sender:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textFieldLocation resignFirstResponder];
    [textFieldKeyword resignFirstResponder];
    [textFieldEmployer resignFirstResponder];
    heightForScrollView = 450;
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
    }else{
        [scrollViewSearch setContentOffset:CGPointMake(0, -50)];
    }
    if (textField==textFieldEmployer) {
        return NO;
    }else
        return YES;
}

@end
