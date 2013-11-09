//
//  UIViewController+Extension.m
//  Parkadom
//
//  Created by Romain Rivollier on 02/07/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <REFrostedViewController.h>
#import "KGNoise.h"

@implementation UIViewController (Extension)

- (CGRect)boundsFittingAvailableScreenSpace
{
    // start with applicationFrame's bounds
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    bounds.origin.y = 0;
    
    // subtract space taken by navigation controller
    if (self.navigationController)
    {
        if (self.navigationController.navigationBarHidden == NO)
        {
            bounds.size.height -= self.navigationController.navigationBar.bounds.size.height;
        }
        if (self.navigationController.toolbarHidden == NO)
        {
            bounds.size.height -= self.navigationController.toolbar.bounds.size.height;
        }
    }
    
    // subtract space taken by tab bar controller
    if (self.tabBarController)
    {
        bounds.size.height -= self.tabBarController.tabBar.bounds.size.height;
    }
    
    return bounds;
}

- (UIButton *)createBackButtonWithTitle:(NSString*)title
{
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBut.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:11.0];
    cancelBut.frame = CGRectMake(0, 0, 55.0, 44.0);
    //    [cancelBut setTitleColor:[UIColor bleuParkadom] forState:UIControlStateHighlighted];
    [cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBut setTitle:title forState:UIControlStateNormal];
    
    return cancelBut;
}

- (UIButton *)createNextButtonWithTitle:(NSString*)title
{
    UIButton *nextBut = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBut.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:11.0];
    nextBut.frame = CGRectMake(20, 0, 60, 44.0);
    [nextBut setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //    [nextBut setTitleColor:[UIColor bleuParkadom] forState:UIControlStateHighlighted];
    [nextBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBut setTitle:title forState:UIControlStateNormal];
    
    return nextBut;
}

- (UIView *)generateRadielGradiantBackgoundView
{
    KGNoiseRadialGradientView *gradientBack = [[KGNoiseRadialGradientView alloc] initWithFrame:self.view.bounds];
    gradientBack.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    gradientBack.backgroundColor = [UIColor secondBackground];
    //    gradientBack.alternateBackgroundColor = [UIColor defaultBackground];
    gradientBack.noiseOpacity = 0.2;
    
    return gradientBack;
}

- (UIView *)generateBlueRadialGradientBackgroundView
{
    KGNoiseRadialGradientView *gradientBack = [[KGNoiseRadialGradientView alloc] initWithFrame:self.view.bounds];
    gradientBack.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    gradientBack.backgroundColor = [UIColor bleuSombreParkadom];
    //    gradientBack.alternateBackgroundColor = [UIColor bleuParkadom];
    gradientBack.noiseOpacity = 0.1;
    
    return gradientBack;
}

- (void)configureMenuLeftButtonWithBackButon:(BOOL)backButttonEnabled
{
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15.0;
    
    //menu
	
    UIImage* menuImg = [UIImage imageNamed:@"navicone"];
    CGRect frameimg = CGRectMake(0, 0, menuImg.size.width, menuImg.size.height);
    UIButton *menuButton = [[UIButton alloc] initWithFrame:frameimg];
    [menuButton setBackgroundImage:menuImg forState:UIControlStateHighlighted];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"navicone"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(leftBackButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    

    if (backButttonEnabled == YES) {
        //back button
        UIImage* backButtonImg = [UIImage imageNamed:@"back"];
        CGRect frameBack = CGRectMake(0, 0, backButtonImg.size.width, backButtonImg.size.height);
        UIButton *backButton = [[UIButton alloc] initWithFrame:frameBack];
        [backButton setBackgroundImage:backButtonImg forState:UIControlStateHighlighted];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItems = @[spaceItem, backButtonItem];
    }
    else {
        self.navigationItem.leftBarButtonItems = @[menuButtonItem];
    }
}

- (void)backButtonPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBackButtonPress:(id)sender {
    [self.frostedViewController presentMenuViewController];
}


@end
