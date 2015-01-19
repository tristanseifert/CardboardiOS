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
#import "SQUPhotoSphereRenderer.h"

#import "SQUAppDelegate.h"

#import "CardboardKit/CardboardKit.h"
#import <KVNProgress/KVNProgress.h>

@implementation SQUAppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	// Set up KVNProgress
	KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
	configuration.fullScreen = YES;
	[KVNProgress setConfiguration:configuration];
	
	// create demo controllers
	_watermelon = [[SQUWatermelonLandRenderer alloc] init];
	_flugen = [[SQUFlugenRenderer alloc] init];
	_sphere = [[SQUPhotoSphereRenderer alloc] init];
	
	// create main controller
	_mainController = [[SQUGLController alloc] initWithRenderer:_sphere];
	_flugen.rootVC = _mainController;
	
	// create window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
	_window.rootViewController = _mainController;
	[_window makeKeyAndVisible];
	
	// initialise CardboardKit
	[[SQUCardboardKit sharedInstance] requestAuthorization];
	
	return YES;
}

@end
