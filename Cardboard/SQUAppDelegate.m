//
//  SQUAppDelegate.m
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import "SQUGLController.h"
#import "SQUFlugenRenderer.h"
#import "SQUWatermelonLandRenderer.h"
#import "SQUPhotoSphereRenderer.h"

#import "SQUAppDelegate.h"

#import "CardboardKit.h"
#import <MyoKit/MyoKit.h>
#import <KVNProgress/KVNProgress.h>

@implementation SQUAppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	
    // Set up KVNProgress
	KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
	configuration.fullScreen = YES;
	[KVNProgress setConfiguration:configuration];
	
	// Initialse Myo library — optional additional UI control device
	/*NSString *meep = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
	[[TLMHub sharedHub] setApplicationIdentifier:meep];*/
	
	// create demo controllers
	_watermelon = [[SQUWatermelonLandRenderer alloc] init];
	_flugen = [[SQUFlugenRenderer alloc] init];
	_sphere = [[SQUPhotoSphereRenderer alloc] init];
	
	// create main controller
	_mainController = [[SQUGLController alloc] initWithRenderer:_sphere];
	_flugen.rootVC = _mainController;
	
	// create window — only slightly important
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
	_window.rootViewController = _mainController;
	[_window makeKeyAndVisible];
	
	// Connect to Myo
	//[_flugen doMyoInit];
	
	// initialise cardboard kit
	[[SQUCardboardKit sharedInstance] configureSensors];
	
	return YES;
}

@end
