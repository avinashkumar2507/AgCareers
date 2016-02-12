/*
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "QEUtilities.h"

@implementation QEUtilities
+ (UIAlertView *)showLoadingMessageWithTitle:(NSString *)title
                                    delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [alert addSubview:progress];
    [progress startAnimating];
    [alert show];
    return alert;
}
+(UIAlertView*) progressAlertWithTitle:(NSString*) title andMessage:(NSString*) message andDelegate:(id)delegate{
    UIAlertView *progressAlert = [[UIAlertView alloc] init];
    [progressAlert setTitle:title];
    [progressAlert setMessage:message];
    [progressAlert setDelegate:delegate];
    UIActivityIndicatorView *progress=nil;
    progress= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [progressAlert addSubview:progress];
    [progress startAnimating];
    
    [progressAlert show];
    
    progress.frame=CGRectMake(progressAlert.frame.size.width/2-progress.frame.size.width, progressAlert.frame.size.height-progress.frame.size.height*2, progress.frame.size.width, progress.frame.size.height);
    
    
    return progressAlert;
}
+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
