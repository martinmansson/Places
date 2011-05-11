//
//  TopRatedTableViewController.m
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import "TopRatedTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosAtPlaceTableViewController.h"

@interface TopRatedTableViewController()

@property (nonatomic, retain) NSArray *topPlaces;
@property (nonatomic, retain) NSMutableArray *sections;

@end


@implementation TopRatedTableViewController

@synthesize topPlaces, sections;

#pragma mark -
#pragma mark Initialization

- (NSArray *)topPlaces
{
	if (!topPlaces) {
		NSSortDescriptor *sort = [[[NSSortDescriptor alloc] initWithKey:@"_content" ascending:YES] autorelease];
		topPlaces = [[[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] retain];
	}
	return topPlaces;
}

- (NSMutableArray *)sections
{
	if (!sections)
		sections = [[NSMutableArray alloc] init];
	for (int i = 0; i < self.topPlaces.count-1; i++) {
		//get the first char of each place
		char alphabet = [[[topPlaces objectAtIndex:i] objectForKey:@"_content"] characterAtIndex:0];
		NSString *uniChar = [NSString stringWithFormat:@"%C", alphabet];
		
		//add each letter to the sections array
		if (![sections containsObject:uniChar])			  
			[sections addObject:uniChar];
	}
	return sections;
}

- (void)setup
{
	UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:0];
	self.tabBarItem = item;
	self.title = @"Places";
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


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
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
    return self.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_content BEGINSWITH[c] %@", [sections objectAtIndex:section]];
	NSArray *itemsInSection = [topPlaces filteredArrayUsingPredicate:predicate];
	return itemsInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sections objectAtIndex:section];
}

- (NSArray *)arrayAtIndexPath:(NSIndexPath *)indexPath
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_content BEGINSWITH[c] %@", [sections objectAtIndex:indexPath.section]];
	return [topPlaces filteredArrayUsingPredicate:predicate];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PlacesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *itemsInSection = [self arrayAtIndexPath:indexPath];
	NSString *place = [[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"_content"];
	NSRange range = [place rangeOfString:@","];
	cell.textLabel.text = [place substringToIndex:range.location];
	cell.detailTextLabel.text = [place substringFromIndex:range.location+2];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.sections;
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



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



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
	NSLog(@"Activating network indicator but it is not showing");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	PhotosAtPlaceTableViewController *photosAtPlaceVC = [[PhotosAtPlaceTableViewController alloc] init];
	NSArray *itemsInSection = [self arrayAtIndexPath:indexPath];
	photosAtPlaceVC.photosAtPlace = [FlickrFetcher photosAtPlace:[[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"place_id"]];
	NSString *place = [[itemsInSection objectAtIndex:indexPath.row] objectForKey:@"_content"];
	NSRange range = [place rangeOfString:@","];
	photosAtPlaceVC.title = [place substringToIndex:range.location];
	[self.navigationController pushViewController:photosAtPlaceVC animated:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[photosAtPlaceVC release];
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

