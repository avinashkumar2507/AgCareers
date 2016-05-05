//
//  AppDelegate.h
//  AgCareers
//
//  Created by Unicorn on 13/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,DBSessionDelegate,DBNetworkRequestDelegate,UIAlertViewDelegate>{
    NSMutableDictionary *loginDetails;
    NSString *relinkUserId;
    UIAlertView *alertForUpdate,*alertForCriticalUpdate;
}

@property (nonatomic,retain) NSDictionary               *applyProfileDictionary;
@property (nonatomic,retain) NSDictionary               *applyDetailsDictionary;
@property (nonatomic,retain) NSDictionary               *applySubmitDictionary;
@property (nonatomic,retain) NSString                   *stringApplyWhileCreating;
@property (nonatomic,retain) NSString                   *stringJobIdCreateProfile;
@property (nonatomic,retain) NSString                   *stringATSJob;
@property (nonatomic,retain) NSString                   *stringCompany;
@property (nonatomic,strong) NSString                   *loginSuccessStatus;
@property (nonatomic,strong) NSString                   *loginMemberId;

@property (nonatomic, retain) NSMutableDictionary       *loginDetails;
@property (nonatomic, assign) BOOL                      loginCheck;
@property (strong, nonatomic) UIWindow                  *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end