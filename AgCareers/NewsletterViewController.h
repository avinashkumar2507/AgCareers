//
//  NewsletterViewController.h
//  AgCareers
//
//  Created by Unicorn on 06/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"

@interface NewsletterViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    NSArray *arrayPickerData;
    APParser *jsonParser,*jsonParser1;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    UIAlertView *alertForCheck;
    
}
@property (weak, nonatomic) IBOutlet UITextField *textFeildEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCountry;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSubmit;

@property (weak, nonatomic) IBOutlet UIButton *buttonCountry;

- (IBAction)buttonActionCountry:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCountry;

- (IBAction)buttonActionSubmit:(id)sender;

@end
