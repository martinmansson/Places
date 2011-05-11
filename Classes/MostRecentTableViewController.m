//
//  MostRecentTableViewController.m
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import "MostRecentTableViewController.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"

@implementation MostRecentTableViewController

@synthesize recentPhotos;

- (NSMutableArray *)recentPhotos
{
	recentPhotos = [[[[[[NSUserDefaults standardUserDefaults] arrayForKey:@"RecentlyViewed"] mutableCopy] reverseObjectEnumerator] allObjects] retain];
	return recentPhotos;
}


#pragma mark -
#pragma mark Initialization

- (void)setup
{
	self.title = @"Recents";
	UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
	self.tabBarItem = item;
	[item release];
}

- (id)initWithTabBar 
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ([self init]) {
        [self setup];
    }
    return self;
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

/* Action sent when the delete all button is pressed.
 Deletes all recents from the list and updates the table */
-(IBAction)deleteAllRecents:(id)sender
{
	NSLog(@"All recents deleted ;)");
	[self.recentPhotos removeAllObjects];
	[[NSUserDefaults standardUserDefaults] setObject:[[recentPhotos reverseObjectEnumerator] allObjects] forKey:@"RecentlyViewed"];
	[self.tableView reloadData];
}

/* Override the editbutton action to show the delete all button */
- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing)
    {
        NSLog(@"editMode on");
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete All" 
																				 style:UIBarButtonItemStylePlain 
																				target:self 
																				action:@selector(deleteAllRecents:)];
    }
    else
    {
        NSLog(@"Done leave editmode");
		self.navigationItem.leftBarButtonItem = nil;
    }
}

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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.recentPhotos.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *title = [[recentPhotos objectAtIndex:indexPath.row] objectForKey:@"title"];
	NSString *description = [[[recentPhotos objectAtIndex:indexPath.row] objectForKey:@"description"] objectForKey:@"_content"];
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



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		[self.recentPhotos removeObjectAtIndex:indexPath.row];
		[[NSUserDefaults standardUserDefaults] setObject:[[recentPhotos reverseObjectEnumerator] allObjects] forKey:@"RecentlyViewed"];
		// Delete the row from the table.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}



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
	ivc.flickrImage = [FlickrFetcher imageDataForPhotoWithFlickrInfo:[recentPhotos objectAtIndex:indexPath.row] format:FlickrFetcherPhotoFormatLarge];
	NSString *title = [[recentPhotos objectAtIndex:indexPath.row] objectForKey:@"title"];
	NSString *description = [[[recentPhotos objectAtIndex:indexPath.row] objectForKey:@"description"] objectForKey:@"_content"];
	if ([title length] != 0) {
		ivc.title = title;
	} else if ([title length] == 0 && [description length] != 0) {
		ivc.title = description;
	} else {
		ivc.title = @"Unknown";
	}
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
	[recentPhotos release];
    [super dealloc];
}


@end

