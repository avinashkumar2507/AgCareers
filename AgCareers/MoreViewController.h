//
//  MoreViewController.h
//  AgCareers
//
//  Created by Unicorn on 24/06/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDelegate> {
    UIAlertView *alertLogOff;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewMore;

@end
