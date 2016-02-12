//
//  LoginViewController.h
//  AgCareers
//
//  Created by Unicorn on 14/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    Parser *jsonParser;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

- (IBAction)buttonActionBack:(id)sender;
- (IBAction)buttonActionLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchButtonStaySigned;
@property (weak, nonatomic) IBOutlet UIButton *ButtonCreateMember;
- (IBAction)ButtonActionCreateMember:(id)sender;

@end
