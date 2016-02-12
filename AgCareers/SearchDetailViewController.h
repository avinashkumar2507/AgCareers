//
//  SearchDetailViewController.h
//  AgCareers
//
//  Created by Unicorn on 24/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    APParser *jsonParser,*jsonParser1;
    MBProgressHUD *HUD,*HUD1;
    NSDictionary *JSONDict;
    NSArray *arrayJobsListing;
    UIBarButtonItem *backButton,*editButton, *removeButton;
    UIAlertView *alertForNoDetails, *alertForDelete, *alertDeleteSuccess,*alertDeleteFail;
}

@property (strong, nonatomic) NSString *searchID;
@property (strong, nonatomic) NSString *searchTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelIndustorySector;
@property (weak, nonatomic) IBOutlet UILabel *labelIndustryType;
@property (weak, nonatomic) IBOutlet UILabel *lableCareersType;
@property (weak, nonatomic) IBOutlet UILabel *labelCountry;
@property (weak, nonatomic) IBOutlet UILabel *labelRegion;
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UITableView *tableSearches;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentJobs;

@end
