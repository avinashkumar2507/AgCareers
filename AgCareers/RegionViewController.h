//
//  RegionViewController.h
//  AgCareers
//
//  Created by Unicorn on 06/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProtocolRegion <NSObject>

@optional
-(void)sendRegionDictionary : (NSMutableDictionary *) dictionaryRegion;
@end


@interface RegionViewController : UIViewController{
    id<ProtocolRegion>delegateRegion;
    APParser *jsonParser,*jsonParser2;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    NSMutableDictionary *dataDictionary;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewRegion;

@property (strong ,nonatomic)id delegateRegion;
@property (strong, nonatomic) NSString *stringCoutnryId;
@end
