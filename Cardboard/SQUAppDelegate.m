//
//  SQUAppDelegate.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUGLController.h"

#import "SQUAppDelegate.h"

@implementation SQUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// create main controller
	_mainController = [[SQUGLController alloc] init];
	
	// create window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.backgroundColor = [UIColor whiteColor];
	_window.rootViewController = _mainController;
	[_window makeKeyAndVisible];
	
	// things
	DDLogInfo(@"Initialised main UI");
    
    //check on location data permissions
    _locationManager = [[CLLocationManager alloc]init];
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if(authStatus == (kCLAuthorizationStatusRestricted | kCLAuthorizationStatusDenied)){ //need to ask permission
        [_locationManager requestWhenInUseAuthorization]; //ask permission
    }
    if([_locationManager headingAvailable]){ //cool, let's set it up
        _locationManager.delegate = self;
        _locationManager.headingFilter = kCLHeadingFilterNone; //continuous survey of the magnetometer calling delegate
        [_locationManager startUpdatingHeading];
        NSLog(@"heading iniditated");
    }
    else{ //this is very unlikely to be called ever
        [[UIAlertView alloc]initWithTitle:@"Not Compatible" message:@"Your iOS device is not compatible with the magnetic button for lack of a proper digital compass/magnetometer. However, you can still try to use this app." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    }
	
	return YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"Heading: %@",newHeading);
    if(abs(180.0-abs(newHeading.y))<=40.0){
        NSLog(@"\n\n\nBUTTON PRESS!!!!\n\n\n");
    }
}

@end
