//
//  SearchResultViewController.h
//  AgCareers
//
//  Created by Unicorn on 12/05/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APParser.h"
@interface SearchResultViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UISearchBarDelegate>{
    APParser *jsonParser1,*jsonParser2,*jsonParser3,*jsonParser4;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict,*JSONDictSave;
    NSMutableArray *arrayResult;
    NSMutableArray *arrayRecruiter;
    UIAlertView *alertForLogin,*alertLogin,*alertPromt,*alertSaveTitle,*alertForCheck;
    
}
@property (weak, nonatomic) IBOutlet UIButton *buttonLoadMoreRecruiter;
@property (weak, nonatomic) IBOutlet UIButton *buttonLoadMoreEmpoloyer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKeywordEmployer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKeywordRecruiter;
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UIView *viewFooterRecruiter;
- (IBAction)buttonActiionLoadMore:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewResult;
@property (weak, nonatomic) IBOutlet UITableView *tableViewRecruiter;
- (IBAction)segmentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentRecruiter;
- (IBAction)buttonActionSave:(id)sender;
- (IBAction)buttonActionBack:(id)sender;

@property (nonatomic,strong)NSString *stringKeyword;
@property (nonatomic,strong)NSString *stringFromPageCount;
@property (nonatomic,strong)NSString *stringToPageCount;
@property (nonatomic,strong)NSString *stringLocation;
@property (nonatomic,strong)NSString *stringSectors;
@property (nonatomic,strong)NSString *stringTypes;
@property (nonatomic,strong)NSString *stringCareers;
@property (nonatomic,strong)NSString *stringEmpoloyer;
@property(nonatomic, assign) UIAlertViewStyle alertViewStyle;

@end
