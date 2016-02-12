//
//  CountrySelectionViewController.h
//  AgCareers
//
//  Created by Unicorn on 06/08/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProtocolCountry <NSObject>

@optional
-(void)sendCountryDictionary : (NSMutableDictionary *) dictionaryCountry;
@end

@interface CountrySelectionViewController : UIViewController{
    id<ProtocolCountry>delegateCountry;
    APParser *jsonParser,*jsonParser2;
    MBProgressHUD *HUD;
    NSDictionary *JSONDict;
    NSMutableDictionary *dataDictionary;
}

@property (weak, nonatomic) IBOutlet UITableView *tableVeiwCountry;
@property (nonatomic,strong)id delegateCountry;

@end
