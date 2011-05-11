//
//  PlacesAppDelegate.h
//  Places
//
//  Created by Martin Månsson on 2011-04-26.
//  Copyright 2011 Capgemini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tbc;
	BOOL iPad;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tbc;
@property (readonly) BOOL iPad;

@end

