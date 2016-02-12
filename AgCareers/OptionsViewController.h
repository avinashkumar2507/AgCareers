//
//  OptionsViewController.h
//  AgCareers
//
//  Created by Unicorn on 23/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"
@protocol optionsProtocol <NSObject>
@optional
-(void)sendSectorDictionary : (NSString *)selectedString;
@end

@interface OptionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    id<optionsProtocol> delegateOptions;
    APParser *jsonParser111;
    
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
}
@property (nonatomic,strong) id delegateOptions;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOptions;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *buttonCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *buttonDone;
- (IBAction)buttonActionCancel:(id)sender;
- (IBAction)buttonActionDone:(id)sender;

@property (nonatomic,strong)NSString *methodNameString;

@end
