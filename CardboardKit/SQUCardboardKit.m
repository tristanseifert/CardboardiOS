//
//  SQUCardboardKit.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUCardboardKit.h"

static SQUCardboardKit *sharedInstance = nil;

@interface SQUCardboardKit ()

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation SQUCardboardKit

/**
 * Create shared instance
 */
+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SQUCardboardKit alloc] init];
	});
	
	return sharedInstance;
}

/**
 * Requests location permissions
 */
- (void) requestPermissions {
	//check on location data permissions
	_locationManager = [[CLLocationManager alloc]init];
	CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
	
	if(authStatus == (kCLAuthorizationStatusRestricted | kCLAuthorizationStatusDenied)){ //need to ask permission
		[_locationManager requestWhenInUseAuthorization]; //ask permission
	}
	
	// is heading available ??!?!?!????!
	if(_locationManager.headingAvailable){ //cool, let's set it up
		_locationManager.delegate = self;
		_locationManager.headingFilter = kCLHeadingFilterNone; //continuous survey of the magnetometer calling delegate
		[_locationManager startUpdatingHeading];
	} else{ //this is very unlikely to be called ever
		NSLog(@"go die");
	}
}

/**
 * Receives heading changes
 */
-(void) locationManager:(CLLocationManager *) manager didUpdateHeading:(CLHeading *) newHeading{
	NSLog(@"Heading: %@",newHeading);
	
	if(abs(180.0-abs(newHeading.y)) <= 40.0){
		NSLog(@"\n\n\nBUTTON PRESS!!!!\n\n\n");
	}
}


@end
