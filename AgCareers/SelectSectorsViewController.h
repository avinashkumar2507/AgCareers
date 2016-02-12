//
//  SelectSectorsViewController.h
//  AgCareers
//
//  Created by Unicorn on 17/04/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sectorsProtocol <NSObject>
@optional
-(void)sendSectorDictionary : (NSMutableDictionary *)sectorsDictionary;
@end


@interface SelectSectorsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{

    id<sectorsProtocol> delegateSectors;
    
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

@property (nonatomic,strong) id delegateSectors;

@property (weak, nonatomic) IBOutlet UITableView *tableViewSectors;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *buttonCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *buttonDone;
- (IBAction)buttonActionCancel:(id)sender;
- (IBAction)buttonActionDone:(id)sender;
@end
