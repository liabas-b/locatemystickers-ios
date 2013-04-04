//
//  StickerAddingTableViewController.h
//  LMS
//
//  Created by Adrien Guffens on 3/21/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerAddingTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UISwitch *isActiveSwitch;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UISlider *updateFrequencySlider;
@property (strong, nonatomic) IBOutlet UITextField *labelsTextField;
@property (strong, nonatomic) IBOutlet UIButton *finishedButton;

@property(nonatomic, strong) NSString *result;

- (IBAction)handleFinishedButton:(id)sender;

@end
