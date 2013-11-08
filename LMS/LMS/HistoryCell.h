//
//  HistoryCell.h
//  LMS
//
//  Created by Adrien Guffens on 9/18/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *historyLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
