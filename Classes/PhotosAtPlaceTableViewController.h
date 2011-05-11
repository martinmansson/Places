//
//  PhotosAtPlaceTableViewController.h
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotosAtPlaceTableViewController : UITableViewController {
	
	NSArray *photosAtPlace;
	NSMutableArray *recents, *sections;
	UIView *imageView;
}

@property (copy) NSArray *photosAtPlace;
@property (nonatomic, retain) NSMutableArray *recents, *sections;

@end
