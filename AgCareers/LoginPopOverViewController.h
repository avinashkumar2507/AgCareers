//
//  LoginPopOverViewController.h
//  AgCareers
//
//  Created by Unicorn on 29/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginProtocol <NSObject>
@optional

-(void)sendResult : (NSDictionary *) resultDictionary;

@end

@interface LoginPopOverViewController : UIViewController{
    id<LoginProtocol>delegateLogin;
    Parser *jsonParser;
    MBProgressHUD *HUD;
}
@property (nonatomic,strong)id delegateLogin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *ButtonCreateMember;
- (IBAction)ButtonActionCreateMember:(id)sender;

- (IBAction)buttonActionLogin:(id)sender;
- (IBAction)buttonActionCancel:(id)sender;


@end
