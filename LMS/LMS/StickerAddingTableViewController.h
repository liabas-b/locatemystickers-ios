//
//  StickerAddingTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 3/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSSticker.h"
#import "LMSTableViewController.h"

@class BButton;

@interface StickerAddingTableViewController : LMSTableViewController <UITextFieldDelegate>

@property (nonatomic, retain) LMSSticker *sticker;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UISlider *updateFrequencySlider;
@property (strong, nonatomic) IBOutlet UILabel *updateFrequencyLabel;
@property (strong, nonatomic) IBOutlet UITextField *labelsTextField;
@property (strong, nonatomic) IBOutlet BButton *finishedButton;

@property(nonatomic, strong) NSString *result;


- (IBAction)handleFinishedButton:(id)sender;


@end
