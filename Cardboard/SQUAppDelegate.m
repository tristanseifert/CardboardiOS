//
//  SQUAppDelegate.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUGLController.h"
#import "SQUWatermelonLandRenderer.h"

#import "SQUAppDelegate.h"

#import "CardboardKit.h"

@implementation SQUAppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	_watermelon = [[SQUWatermelonLandRenderer alloc] init];
	
	// create main controller
	_mainController = [[SQUGLController alloc] initWithRenderer:_watermelon];
	
	// create window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor whiteColor];
	_window.rootViewController = _mainController;
	[_window makeKeyAndVisible];
	
	// things
	DDLogInfo(@"Initialised main UI");
	
	// initialise cardboard kit, pls
	[[SQUCardboardKit sharedInstance] configureSensors];
	
	return YES;
}

@end
