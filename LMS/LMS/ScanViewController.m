//
//  ScanViewController.m
//  LMS
//
//  Created by Adrien Guffens on 17/01/14.
//  Copyright (c) 2014 Team3000. All rights reserved.
//

#import "ScanViewController.h"

#import "RSCodeView.h"
#import "RSCodeGen.h"

@interface ScanViewController ()

@property (nonatomic, weak) IBOutlet RSCodeView *codeView;

@property (nonatomic, weak) IBOutlet UILabel *codeLabel;

@end

@implementation ScanViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self configure];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//		[self configure];
    }
    return self;
}

- (void)configure {
	__weak typeof(self) weakSelf = self;
	self.barcodesHandler = ^(NSArray *barcodeObjects) {
		if (barcodeObjects.count > 0) {
			NSMutableString *text = [[NSMutableString alloc] init];
			[barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[text appendString:[NSString stringWithFormat:@"%@: %@", [(AVMetadataObject *)obj type], [obj stringValue]]];
				if (idx != (barcodeObjects.count - 1)) {
					[text appendString:@"\n"];
				}
			}];
			dispatch_async(dispatch_get_main_queue(), ^{
				weakSelf.codeLabel.numberOfLines = [barcodeObjects count];
				weakSelf.codeLabel.text = text;
			});
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				weakSelf.codeLabel.text = @"";
			});
		}
	};
	
	self.tapGestureHandler = ^(CGPoint tapPoint) {
	};
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.codeView.code = [CodeGen genCodeWithContents:@"HelloWorld2014010906" machineReadableCodeObjectType:AVMetadataObjectTypeCode128Code];
    [self.view bringSubviewToFront:self.codeView];
    
    [self.view bringSubviewToFront:self.codeLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
