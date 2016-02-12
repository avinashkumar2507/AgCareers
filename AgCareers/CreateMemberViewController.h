//
//  CreateMemberViewController.h
//  AgCareers
//
//  Created by Unicorn on 21/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "BRRequestUpload.h"
@interface CreateMemberViewController : UIViewController<DBRestClientDelegate,BRRequestDelegate>{
    Parser *jsonParser;
    MBProgressHUD *HUD;
    BRRequestUpload *uploadFile;
    NSData *uploadData;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonLoginToDropBox;
- (IBAction)buttonActionLoginToDropBox:(id)sender;
@property (nonatomic, strong) DBRestClient *restClient;
- (IBAction)buttonActionListing:(id)sender;
- (IBAction)buttonActionDownload:(id)sender;
- (IBAction)buttonActionUploadToServer:(id)sender;
- (IBAction)buttonActionGoogleDrive:(id)sender;


@end
