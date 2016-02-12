//
//  SelectCareersViewController.h
//  AgCareers
//
//  Created by Unicorn on 11/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol careersProtocoal <NSObject>

@optional
-(void)sendCareersDictionary : (NSMutableDictionary *) careersDictionary;

@end


@interface SelectCareersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    id<careersProtocoal> delegateCareers;
    
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

@property (nonatomic, strong)id delegateCareers;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCareer;
- (IBAction)buttonActionCancel:(id)sender;
- (IBAction)buttonActionDone:(id)sender;

@end
