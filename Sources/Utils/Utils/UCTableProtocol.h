//
//  UCTableProtocol.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCTable;

@protocol UCTableProtocol <NSObject>

- (UITableViewCell *)dictionary:(NSDictionary *)dictionary forCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(id)cell;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andSender:(UCTable *)sender;
- (void)dictionary:(NSDictionary *)dictionary didSelectRowAtIndexPath:(NSIndexPath *)indexPath andSender:(UCTable *)sender;

@end
