//
//  IndustryAndCareerViewController.h
//  AgCareers
//
//  Created by Unicorn on 09/11/15.
//  Copyright © 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IndustryCareerProtocol <NSObject>
@optional
-(void)sendIndustryCareerDictionary : (NSMutableDictionary *)sectorsDictionary;
@end

@interface IndustryAndCareerViewController :  UIViewController <UITableViewDataSource,UITableViewDelegate>{
    
    id<IndustryCareerProtocol> delegateIndustryCareerProtocol;
    
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
@property (strong, nonatomic) NSString *stringWSName;
@property (strong, nonatomic) NSString *stringTitle;
@property (nonatomic, strong)id delegateIndustryCareerProtocol;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (weak, nonatomic) IBOutlet UITableView *tableViewIndustryCareer;
- (IBAction)buttonActionCancel:(id)sender;
- (IBAction)buttonActionDone:(id)sender;

@end
