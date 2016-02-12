//
//  WebDetailsViewController.m
//  AgCareers
//
//  Created by Unicorn on 01/07/15.
//  Copyright (c) 2015 VLWebtek. All rights reserved.
//

#import "WebDetailsViewController.h"

@interface WebDetailsViewController ()

@end

@implementation WebDetailsViewController
@synthesize webViewDetails;
@synthesize activityIndicatior;
@synthesize labelLoading;
@synthesize stringURL;
@synthesize stringTitleScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    [webViewDetails loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]]];
    self.title = stringTitleScreen;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark WebVeiw delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatior startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatior stopAnimating];
    activityIndicatior.hidden = YES;
    labelLoading.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
