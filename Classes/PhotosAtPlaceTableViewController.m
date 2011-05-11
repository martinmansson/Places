//
//  PhotosAtPlaceTableViewController.m
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import "PhotosAtPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import	"ImageViewController.h"
#import "MostRecentTableViewController.h"


@implementation PhotosAtPlaceTableViewController

@synthesize photosAtPlace, recents, sections;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (NSMutableArray *)sections
{
	if (!sections)
		sections = [[NSMutableArray alloc] init];
	for (int i = 0; i < self.photosAtPlace.count-1; i++) {
		NSDate *timeNow = [NSDate date];
		NSTimeInterval timeSince1970 = [timeNow timeIntervalSince1970];
		NSInteger secondsForUploadSince1970 = [[[photosAtPlace objectAtIndex:i] objectForKey:@"dateupload"] integerValue];
		NSInteger timeSinceUploadInHours = (timeSince1970 - secondsForUploadSince1970) / 3600;
		if (![sections containsObject:[NSString stringWithFormat:@"%d", timeSinceUploadInHours]])
			[sections addObject:[NSString stringWithFormat:@"%d", timeSinceUploadInHours]];
	}
	return sections;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	int cnt = 0;
	for (int i = 0; i < photosAtPlace.count-1; i++) {
		NSDate *timeNow = [NSDate date];
		NSTimeInterval timeSince1970 = [timeNow timeIntervalSince1970];
		NSInteger timeSinceUploadInHours = (timeSince1970 - [[[photosAtPlace objectAtIndex:i] objectForKey:@"dateupload"] integerValue]) / 3600;
		if (timeSinceUploadInHours == [[sections objectAtIndex:section] integerValue])
			cnt++;
	}
	return cnt;	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([[sections objectAtIndex:section] integerValue] == 0)
		return @"Right Now";
	return [NSString stringWithFormat:@"%d Hours Ago", [[sections objectAtIndex:section] integerValue]];
}

- (NSArray *)arrayAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray *itemsInSection = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < photosAtPlace.count-1; i++) {
		NSDate *timeNow = [NSDate date];
		NSTimeInterval timeSince1970 = [timeNow timeIntervalSince1970];
		NSInteger timeSinceUploadInHours = (timeSince1970 - [[[photosAtPlace objectAtIndex:i] objectForKey:@"dateupload"] integerValue]) / 3600;
		if (timeSinceUploadInHours == [[sections objectAtIndex:indexPath.section] integerValue])
			[itemsInSection addObject:[photosAtPlace objectAtIndex:i]];
	}
	return itemsInSection;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *itemsInSection = [self arrayAtIndexPath:indexPath];
	NSString *title = [[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"title"];
	NSString *description = [[[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"description"] objectForKey:@"_content"];
	if ([title length] != 0) {
		cell.textLabel.text = title;
		cell.detailTextLabel.text = description;
	} else if ([title length] == 0 && [description length] != 0) {
		cell.textLabel.text = description;
	} else {
		cell.textLabel.text = @"Unknown";
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)storeRecentViewedPhoto:(id)recentPhoto
{
	recents = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"RecentlyViewed"] mutableCopy];
	if (!recents)
		recents = [[NSMutableArray alloc] init];
	if ([recents count] == 10) {
		[recents removeObjectAtIndex:0];
	}
	if (![recents containsObject:recentPhoto])
		[recents addObject:recentPhoto];
	[[NSUserDefaults standardUserDefaults] setObject:recents forKey:@"RecentlyViewed"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[recents release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	ImageViewController *ivc = [[ImageViewController alloc] init];
	NSArray *itemsInSection = [self arrayAtIndexPath:indexPath];
	ivc.flickrImage = [FlickrFetcher imageDataForPhotoWithFlickrInfo:[itemsInSection objectAtIndex:indexPath.row] format:FlickrFetcherPhotoFormatLarge];
	NSString *title = [[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"title"];
	NSString *description = [[[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"description"] objectForKey:@"_content"];
	if ([title length] != 0) {
		ivc.title = title;
	} else if ([title length] == 0 && [description length] != 0) {
		ivc.title = description;
	} else {
		ivc.title = @"Unknown";
	}
	[self storeRecentViewedPhoto:[itemsInSection objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:ivc animated:YES];
	[ivc release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

