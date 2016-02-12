//
//  WebDetailsViewController.h
//  AgCareers
//
//  Created by Unicorn on 01/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebDetailsViewController : UIViewController<UIWebViewDelegate> {
    
}

@property (nonatomic,strong) NSString *stringTitleScreen;
@property (nonatomic,strong) NSString *stringURL;

@property (weak, nonatomic) IBOutlet UIWebView *webViewDetails;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;
@property (weak, nonatomic) IBOutlet UILabel *labelLoading;

@end
