//
//  UCTable.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCTableProtocol.h"

typedef struct tableOption {
	UITableViewStyle style;
	BOOL search;
	BOOL refresh;
	BOOL section;
	BOOL selection;
} tableOption;

@interface UCTable : UIView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
	tableOption _option;
}

@property(nonatomic, strong)NSString *CellIdentifier;
@property(nonatomic, strong)NSMutableArray *Items;
@property(nonatomic, strong)UITableView *TableView;
@property(nonatomic, strong)UIRefreshControl *RefreshControl;
@property(nonatomic, strong)UISearchBar *SearchBar;
@property(nonatomic, strong)NSString *SearchText;

@property(nonatomic, strong)id<UCTableProtocol> Delegate;

- (id)initWithFrame:(CGRect)frame andKindOfCell:(NSString *)CellIdentifier andOption:(tableOption)option;
- (void)reloadData;

- (NSDictionary *)getDictionaryAtIndexPath:(NSIndexPath *)indexPath;

@end
