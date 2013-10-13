//
//  UIViewController+Extension.h
//  Parkadom
//
//  Created by Romain Rivollier on 02/07/13.
//  Copyright (c) 2013 MEETINEO. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const     pBackButtonTitle = @"RETOUR";
static NSString * const     pCancelButtonTitle = @"ANNULER";
static NSString * const     pAddButtonTitle = @"AJOUTER";
static NSString * const     pModifyButtonTitle = @"MODIFIER";
static NSString * const     pApplyButtonTitle = @"VALIDER";
static NSString * const     pFnishButtonTitle = @"TERMINER";
static NSString * const     pNextButtonTitle = @"SUIVANT";

@interface UIViewController (Extension)

- (CGRect)boundsFittingAvailableScreenSpace;
- (UIButton *)createBackButtonWithTitle:(NSString*)title;
- (UIButton *)createNextButtonWithTitle:(NSString*)title;
- (UIView *)generateRadielGradiantBackgoundView;
- (UIView *)generateBlueRadialGradientBackgroundView;
- (void)configureMenuLeftButtonWithBackButon:(BOOL)backButttonEnabled;

@end
