/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

@protocol ScanOverlayProtocol;

@interface ScanOverlayView : UIView {
	UIImageView *imageView;
	NSMutableArray *_points;
	//UIButton *cancelButton;
	UILabel *topLabel;
	UILabel *centerLabel;
	id<ScanOverlayProtocol> delegate;
	BOOL oneDMode;
	CGRect cropRect;
	NSString *displayedMessage;	
	CGRect viseurRect;
	UIImageView *bottomImage;
	NSTimer* displayTimer;
	UIButton *batteryButtonImg;
    float batteryLevelWarning;
	//
}

@property (nonatomic, retain) NSMutableArray*  points;
@property (nonatomic, strong) id<ScanOverlayProtocol> delegate;
@property (nonatomic, assign) BOOL oneDMode;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) CGRect viseurRect;
@property (nonatomic, copy) NSString *displayedMessage;

- (id)initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled;

//- (void)refreshBattery;

- (void)displayInfo:(NSString *)infos withColor:(UIColor *)backColor withImage:(UIImage *)img withComplement:(NSString *)complement;

@end

@protocol ScanOverlayProtocol
- (void)cancelled;
- (void)torch;
@end