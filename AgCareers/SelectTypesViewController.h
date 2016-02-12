//
//  SelectTypesViewController.h
//  AgCareers
//
//  Created by Unicorn on 11/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol typesProtocol <NSObject>

@optional
-(void)sendTypesDictionary : (NSMutableDictionary *) typesDictionary;
@end



@interface SelectTypesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    id<typesProtocol>delegateTypes;
    Parser *jsonParser;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    
    NSArray *arrayValues;
    NSArray *arrayId;
    NSMutableArray *newArray;
    NSMutableArray *newArrayId;
}
@property (strong, nonatomic) NSString *stringValues;
@property (strong, nonatomic) NSString *stringId;
@property (nonatomic,strong)id delegateTypes;
@property (weak, nonatomic) IBOutlet UITableView *tableViewTypes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;

- (IBAction)buttonActionCancel:(id)sender;
- (IBAction)buttonActionDone:(id)sender;

@end
