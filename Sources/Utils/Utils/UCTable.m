//
//  UCTable.m
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

#import "UCTable.h"

@implementation UCTable

@synthesize CellIdentifier;
@synthesize Items;
@synthesize TableView;

@synthesize RefreshControl;
@synthesize SearchBar;

@synthesize Delegate;

- (id)initWithFrame:(CGRect)frame andKindOfCell:(NSString *)cellIdentifier andOption:(tableOption)option {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		Items = [[NSMutableArray alloc] init];
		CellIdentifier = cellIdentifier;
		self->_option = option;
		//
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		UITableViewStyle tableStyle = self->_option.style ? self->_option.style : UITableViewStylePlain;
		
		TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:tableStyle];//UITableViewStylePlain];
		[TableView setDelegate:self];
		[TableView setDataSource:self];
        [TableView setBackgroundColor:[UIColor clearColor]];
		
		
		[TableView setAutoresizesSubviews:YES];
		[TableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		
		
		//
		if (self->_option.refresh) {//INFO: may be check for under ios6
			// Create the refresh control
			RefreshControl = [[UIRefreshControl alloc] init];
			
			// Set the action
			[RefreshControl addTarget:self action:@selector(refreshControlRequest)
					 forControlEvents:UIControlEventValueChanged];
			
			// Optional tint
			//[RefreshControl setTintColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.630 alpha:1.000]];
			[self.TableView addSubview:RefreshControl];
		}
		if (self->_option.search) {
				self.TableView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y/* + 44*/, self.bounds.size.width, self.bounds.size.height/* - 44*/);
				
				self.SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
				self.SearchBar.tintColor = [UIColor blackColor];
				self.SearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				[self.SearchBar setDelegate:self];
				[self.SearchBar setPlaceholder:@"Search"];
				//[self addSubview:self->_searchBar];
				//INFO: add search bar to the header
				[self.TableView setTableHeaderView:self.SearchBar];
		}
		if (self->_option.section) {
			
		}
		[self addSubview:TableView];
    }
    return self;
}

- (void)refreshControlRequest
{
	if (self->_option.refresh) {
		NSLog(@"refreshing...");
		
		//[RefreshControl endRefreshing];
		
		// Update the table
		
		[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(testRefreshControl:) userInfo:nil repeats:NO];
	}
}

- (void)testRefreshControl:(NSTimer *)timer {
	[RefreshControl endRefreshing];
}

- (void)reloadData {
	[TableView reloadData];
}

//- (void)setItems:(NSMutableArray *)items {
//	
//}

- (NSDictionary *)getDictionaryAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dictionary = nil;
	NSInteger row = [indexPath row];
	
	if (self->_option.section)
	{
		//NSString *key = [self->_keys objectAtIndex:section];
		NSMutableArray *sectionList = [Items objectAtIndex:indexPath.section];//[self->_indexList objectForKey:key];
		dictionary = [sectionList objectAtIndex:row];
	}
	else
	{
		dictionary = [Items objectAtIndex:row];
	}

	return dictionary;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	[DebugTools addDebug:self
			 withMethode:@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath"
				 andType:information
			   andDetail:@""];*/
	
	id cell = [TableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
		Class typeClass = NSClassFromString(CellIdentifier);
		
		for (id oneCell in nib) {
			if ([oneCell isKindOfClass:[typeClass class]]) {
				cell = oneCell;
			}
		}

//		cell = [[UITableViewCell alloc] initWithStyle:tableView.style reuseIdentifier:CellIdentifier];
		
		if (self->_option.selection == NO)
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		NSDictionary *dictionary = [self getDictionaryAtIndexPath:indexPath];
		if ([Delegate respondsToSelector:@selector(dictionary:forCellForRowAtIndexPath:withCell:)]) {
			return [Delegate dictionary:dictionary forCellForRowAtIndexPath:indexPath withCell:cell];
		}
	}
	else {
		//INFO: update data
		NSDictionary *dictionary = [self getDictionaryAtIndexPath:indexPath];
		if ([Delegate respondsToSelector:@selector(dictionary:forCellForRowAtIndexPath:withCell:)]) {
			return [Delegate dictionary:dictionary forCellForRowAtIndexPath:indexPath withCell:cell];
		}
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self->_option.section) {
		NSMutableArray *sectionList = [Items objectAtIndex:section];
		return [sectionList count];
	}

	return [Items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self->_option.section) {
		return [Items count];
	}
	return 1;
}

#pragma mark - TableViewProtocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([Delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:andSender:)]) {
		return [Delegate tableView:tableView heightForRowAtIndexPath:indexPath andSender:self];
	}
	return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if ([Delegate respondsToSelector:@selector(dictionary:didSelectRowAtIndexPath:andSender:)]) {
		NSDictionary *dictionary = [self getDictionaryAtIndexPath:indexPath];
		[Delegate dictionary:dictionary didSelectRowAtIndexPath:indexPath andSender:self];
	}
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	/*	[DebugTools addDebug:self
			 withMethode:@"- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar"
				 andType:information
			   andDetail:@""];*/
	// only show the status bar’s cancel button while in edit mode
	self.SearchBar.showsCancelButton = YES;
	self.SearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	if ([self.Delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
		//[self.Delegate searchBarTextDidBeginEditing:self.SearchBar];
	}
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	/*[DebugTools addDebug:self
			 withMethode:@"- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar"
				 andType:information
			   andDetail:@""];*/
	self.SearchBar.showsCancelButton = NO;
#warning search JOB
	if ([self.Delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
		//[self.Delegate searchBarTextDidEndEditing:self.SearchText];
	}
	
	//job to do here
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	/*[DebugTools addDebug:self
			 withMethode:@"- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar"
				 andType:information
			   andDetail:@""];*/
	[searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
	searchBar.text = @"";
	if ([self.Delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
		//[self.Delegate searchBarCancelButtonClicked:searchBar];
	}
	[self.TableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
/*	[DebugTools addDebug:self
			 withMethode:@"- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar"
				 andType:information
			   andDetail:@""];*/
	[searchBar resignFirstResponder];
	//INFO: selector faux
	if ([self.Delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
		//[self->_delegate searchBarCancelButtonClicked:searchBar];
	}
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//	[DebugTools addDebug:self
//			 withMethode:@"- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText"
//				 andType:information
//			   andDetail:@""];
	
	if ([searchText length] == 0) {
		//INFO: clear all
		return;
	}
	
	if ([self.Delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
		//[self.Delegate searchBar:searchBar textDidChange:searchText];
	}
	self.SearchText = searchText;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
