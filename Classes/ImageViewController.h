//
//  ImageViewController.h
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewController : UIViewController <UIScrollViewDelegate> {
	UIImageView *imageView;
	UIScrollView *scrollView;
	NSData *flickrImage;
	UIImage *image;
}

@property (copy) NSData *flickrImage;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImage *image;

@end
