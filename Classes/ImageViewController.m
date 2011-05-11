    //
//  ImageViewController.m
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import "ImageViewController.h"


@implementation ImageViewController

@synthesize flickrImage;
@synthesize scrollView;
@synthesize image;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (UIScrollView *)scrollView
{
	if (!scrollView) {
		CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
		scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
	}
	return scrollView;	
}

- (UIImage *)image
{
	if (!image)
		image = [UIImage imageWithData:self.flickrImage];
	return image;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	imageView = [[UIImageView alloc] initWithImage:self.image];
	self.scrollView.contentSize = self.image.size;
	[self.scrollView addSubview:imageView];	
	[imageView release];
	self.scrollView.delegate = self;	
	self.view = self.scrollView;
	[scrollView release];
}

- (void)centerImageInScrollView:(UIScrollView *)scrollView
{
	CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)? 
	(self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)? 
	(self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, 
                                   self.scrollView.contentSize.height * 0.5 + offsetY);	
}

- (void)setInitialZoom:(UIScrollView *)scrollView
{
	CGSize scrollSize = self.scrollView.bounds.size;
	CGFloat widthRatio = scrollSize.width / self.image.size.width;
	CGFloat heightRatio = scrollSize.height / self.image.size.height;
	CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
	self.scrollView.minimumZoomScale = initialZoom;
	self.scrollView.maximumZoomScale = 2.0;
	self.scrollView.zoomScale = initialZoom;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self centerImageInScrollView:self.scrollView];
	[self setInitialZoom:self.scrollView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self centerImageInScrollView:self.scrollView];
	[self setInitialZoom:self.scrollView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerImageInScrollView:self.scrollView];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
