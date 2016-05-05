//
//  AppDelegate.m
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import <Google/Analytics.h>

@interface AppDelegate ()

@end

// http://stackoverflow.com/questions/32137582/how-to-install-ios-7-and-onwards-simulators-in-xcode-7-beta-5

// https://developer.apple.com/support/app-store/

@implementation AppDelegate
@synthesize loginCheck,loginDetails;
@synthesize applyDetailsDictionary,applyProfileDictionary,applySubmitDictionary,stringCompany,stringATSJob;

- (void) tabBarController: (UITabBarController *) tabBarController didSelectViewController: (UIViewController *) viewController {
    int tabitem = tabBarController.selectedIndex;
    if (tabitem == 1 || tabitem == 2) {
        
        [[tabBarController.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:YES];
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    
    [NSThread sleepForTimeInterval:3.0];
    
    loginCheck = NO;
    loginDetails = [[NSMutableDictionary alloc]init];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.delegate = self;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tabBarItem2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tabBarItem3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    tabBarItem4.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"TestNav.png"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIColor *red = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Arial-Bold" size:0.0];
    //    NSShadow *shadow = [[NSShadow alloc] init];
    //    shadow.shadowColor = [UIColor blackColor];
    //    shadow.shadowBlurRadius = 0.0;
    //    shadow.shadowOffset = CGSizeMake(0.0, 2.0);
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:font forKey:NSFontAttributeName];
    [navBarTextAttributes setObject:red forKey:NSForegroundColorAttributeName ];
    // [navBarTextAttributes setObject:shadow forKey:NSShadowAttributeName];
    [[UINavigationBar appearance]setTitleTextAttributes:navBarTextAttributes];
    
    /****************** DropBox ********************/
    
//    DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"0boomhae7ass0bd"
//                                                   appSecret:@"ittagygx1m5a9pd"
//                                                        root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox

    
    /*** 29 Feb 2016 ***/
//    DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"38dgfl7idwht60y"
//                                                   appSecret:@"7353ka8vwf9ymg1"
//                                                        root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox
    
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"fz8gdm3y3k4cg13"
                                                   appSecret:@"hvfingk6bsf20cc"
                                                        root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox

    [DBSession setSharedSession:dbSession];
    
    /****************** Push Notificaton ********************/
    
//#ifdef __IPHONE_8_0
//    
//    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    
//#else
//    //register to receive notifications
//    //Right, that is the point
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
//                                                                                         |UIRemoteNotificationTypeSound
//                                                                                         |UIRemoteNotificationTypeAlert) categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    
//#endif
    
    return YES;
}


//#pragma mark Push notification for Device token
//#ifdef __IPHONE_8_0
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    //register to receive notifications
//    [application registerForRemoteNotifications];
//}
//
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
//{
//    //handle the actions
//    if ([identifier isEqualToString:@"declineAction"]){
//    }
//    else if ([identifier isEqualToString:@"answerAction"]){
//    }
//}
//#endif
//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // Prepare the Device Token for Registration (remove spaces and < >)
//    NSString *devToken = [[[[deviceToken description]
//                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                           stringByReplacingOccurrencesOfString:@">" withString:@""]
//                          stringByReplacingOccurrencesOfString: @" " withString: @""];
//    
//    NSString* tokenString = [NSString stringWithFormat:@"Device Token=%@",devToken];
//    NSLog(@"%@",tokenString);// e13b81b38b38d455ca636c33a495fc699fabd953de00826a3f725cbc784f0f89 - iPhone 5c
//    // 3f5a8da292316bf75e3f4768d1458c2907f339c0da63b0f71a2a150938ce7a57 - iPad
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
//    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
//    NSLog(@"%@",str);
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackgroundNotification" object:self];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[self ShowAlert];
    
}

//-(void)ShowAlert{
//    
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"CriticalUpdateValue"]isEqualToString:@"TRUE"]) {
//        
//        alertForCriticalUpdate = [[UIAlertView alloc] initWithTitle:@"Update required" message:@"critical" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertForCriticalUpdate show];
//    }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"CriticalUpdateValue"]isEqualToString:@"FALSE"]) {
//        alertForUpdate = [[UIAlertView alloc] initWithTitle:@"Update available" message:@"my message " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
//        [alertForUpdate show];
//    }else{
//        
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);{
//    
//    if (alertView == alertForCriticalUpdate){
//        if(buttonIndex == 0){
//            NSString *iTunesLink = @"https://itunes.apple.com/ca/app/farms.com-used-farm-equipment/id908984991?mt=8";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
//        }
//    }else if(alertView == alertForUpdate){
//        if(buttonIndex == 0){
//            NSLog(@"Cancel");
//        }else{
//            NSLog(@"OK");
//        }
//    }
//
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.vlwebtek.AgCareers" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AgCareers" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AgCareers.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark DropBox
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            
            //            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            //            DropboxViewController *yourController = (DropboxViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DropboxSegue"];
            //            self.window.rootViewController = yourController;
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end
