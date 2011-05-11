//
//  TopRatedTableViewController.h
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopRatedTableViewController : UITableViewController {
	
	NSArray *topPlaces;
	NSMutableArray *sections;
}

- (id)initWithTabBar;

@end
