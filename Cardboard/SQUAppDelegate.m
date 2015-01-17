//
//  SQUAppDelegate.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUGLController.h"
#import "SQUFlugenRenderer.h"
#import "SQUWatermelonLandRenderer.h"

#import "SQUAppDelegate.h"

#import "CardboardKit.h"
#import <MyoKit/MyoKit.h>

@implementation SQUAppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	_watermelon = [[SQUWatermelonLandRenderer alloc] init];
	_flugen = [[SQUFlugenRenderer alloc] init];
	
	// create main controller
	_mainController = [[SQUGLController alloc] initWithRenderer:_flugen];
	
	// create window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor blackColor];
	_window.rootViewController = _mainController;
	[_window makeKeyAndVisible];
	
	// initialise cardboard kit, pls
	[[SQUCardboardKit sharedInstance] configureSensors];
	
	// no
	NSString *meep = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
	[[TLMHub sharedHub] setApplicationIdentifier:meep];
	
	// present the UI plss
	dispatch_async(dispatch_get_main_queue(), ^{
		UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
		[_mainController presentViewController:controller animated:YES completion:nil];
	});
	
	return YES;
}

@end
