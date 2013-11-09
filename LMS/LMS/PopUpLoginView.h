//
//  PopUpLoginView.h
//  AB
//
//  Created by Adrien Guffens on 1/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpLoginView : UIView


@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *cancelButtonItem;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndocator;

- (IBAction)cancelButtonHandler:(id)sender;

@end
