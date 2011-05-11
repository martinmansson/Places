//
//  MostRecentTableViewController.h
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MostRecentTableViewController : UITableViewController {
	
	NSMutableArray *recentPhotos;
}

@property (nonatomic, retain) NSMutableArray *recentPhotos;

- (id)initWithTabBar;

@end
