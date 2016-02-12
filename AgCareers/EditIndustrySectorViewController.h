//
//  EditIndustrySectorViewController.h
//  AgCareers
//
//  Created by Unicorn on 30/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProtocolStates <NSObject>

@optional
-(void)sendStatesDictionary : (NSMutableDictionary *) dictionaryStates;
@end


@interface EditIndustrySectorViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    id<ProtocolStates>delegateStates;
    Parser *jsonParser;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    NSArray *arr;
}

@property (strong, nonatomic) NSString *stringCountryId;
@property (strong, nonatomic) NSString *stringRegionId;
@property (nonatomic,strong)id delegateStates;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEditIndustry;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
- (IBAction)buttonActionDone:(id)sender;
- (IBAction)buttonActionCancel:(id)sender;

@end
