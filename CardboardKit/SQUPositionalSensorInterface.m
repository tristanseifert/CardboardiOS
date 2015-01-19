//
//  SQUMagnetometerInterface.m
//  CardboardKit
//
//  Created by Tristan Seifert on 1/18/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUPositionalSensorInterface.h"

#import <CoreMotion/CoreMotion.h>

#pragma mark - Private
#pragma mark Properties
@interface SQUPositionalSensorInterface ()

@property BOOL buttonPress;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end

#pragma mark Functions
@interface SQUPositionalSensorInterface ()

- (void) initMagnetometer;
- (void) initDeviceMotion;

@end

#pragma mark - Initialisation
@implementation SQUPositionalSensorInterface

/**
 * Initialises the motion controller. This has the side effect of registering for some
 * notifications, r.e. data.
 */
- (id) init {
	if(self = [super init]) {
		// Default configurations: 33.3ms refresh rate
		_updateInterval = (1.f/30.f);
		
		// create the motion manager
		_motionManager = [[CMMotionManager alloc] init];
		_motionManager.showsDeviceMovementDisplay = YES;
		
		// create the location manager
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		
		// Begin data collection, if authorised
		if(self.isAuthorized) {
			[self startDataCollection];
		}
	}
	
	return self;
}

#pragma mark - Data Collection
/**
 * Stops the gathering of data. This should be used to reduce battery consumption when
 * the app is backgrounded, or the VR view is not on-screen at the moment.
 */
- (void) stopDataCollection {
	[_locationManager stopUpdatingHeading];
	
	[_motionManager stopMagnetometerUpdates];
	[_motionManager stopDeviceMotionUpdates];
}

/**
 * Restarts collection of data. This need only be called if -stopDataCollection has
 * previously been called.
 */
- (void) startDataCollection {
	[_locationManager startUpdatingHeading];
	
	[self initMagnetometer];
	[self initDeviceMotion];
}

#pragma mark - Permissions
/**
 * Requests permission to access the current location, as well as motion data.
 */
- (void) requestLocationPermissions {
	// check on location data permissions
	CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
	
	// we must ask permission to get the motion data
	if(authStatus == (kCLAuthorizationStatusRestricted | kCLAuthorizationStatusDenied)) {
		[_locationManager requestWhenInUseAuthorization]; // ask permission
	}
	
	// is heading available?
	if([CLLocationManager headingAvailable]){
		_locationManager.delegate = self;
		_locationManager.headingFilter = kCLHeadingFilterNone;
		[_locationManager startUpdatingHeading];
	} else {
		NSAssert(NO, @"Device does not have heading data");
	}
}

/**
 * Determines whether we've been authorised to access location data.
 */
- (BOOL) isAuthorized {
	CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
	return !(authStatus == (kCLAuthorizationStatusRestricted | kCLAuthorizationStatusDenied));
}

/**
 * If the authorisation state for access of data changes, this method will determine the
 * new state, potentially initialising the listening of device updates.
 */
- (void) locationManager:(CLLocationManager *) manager didChangeAuthorizationStatus:(CLAuthorizationStatus) status {
	// Are we now authorised?
	if(self.isAuthorized) {
		[self initMagnetometer];
		[self initDeviceMotion];
	}
	
	// Laatly, send out a KVO notification
	[self willChangeValueForKey:@"isAuthorized"];
	[self didChangeValueForKey:@"isAuthorized"];
}

#pragma mark - Compass
/**
 * Stores the newly received heading.
 */
- (void) locationManager:(CLLocationManager *) manager
		didUpdateHeading:(CLHeading *) newHeading {
	[self willChangeValueForKey:@"heading"];
	_heading = newHeading;
	[self didChangeValueForKey:@"heading"];
}

#pragma mark - Magnetometer
/**
 * Initialises the magnetometer. It is queried by the framework at a specified interval.
 */
- (void) initMagnetometer {
	// check whether the device actually supports the features we need
	if(_motionManager.deviceMotionAvailable) {
		// configure update interval
		_motionManager.magnetometerUpdateInterval = _updateInterval;
		
		// request updates of magnetometer data
		[_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *data, NSError *error) {
			if(!error){
				[self willChangeValueForKey:@"magnetometerData"];
				_magnetometerData = data;
				[self didChangeValueForKey:@"magnetometerData"];
			} else {
				// TODO: Error handling
			}
		}];
	}
}

#pragma mark - Accelerometer
/**
 * Initialises the accelerometer.
 */
- (void) initDeviceMotion {
	if(_motionManager.deviceMotionAvailable) {
		// Set the update interval
		_motionManager.deviceMotionUpdateInterval = _updateInterval;
		
		// update full range of motion data
		[_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^void (CMDeviceMotion *data, NSError *error){
			if (error == nil){
				[self willChangeValueForKey:@"motionData"];
				_motionData = data;
				[self didChangeValueForKey:@"motionData"];
			} else{
				// TODO: Error handling
			}
		}];
	}
}
@end
