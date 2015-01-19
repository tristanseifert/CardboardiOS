//
//  SQUMagnetometerInterface.h
//  CardboardKit
//
//	Responsible for reading data from sensors, parsing it, and turning it into usable
// data. Uses the CoreMotion APIs.
//
//  Created by Tristan Seifert on 1/18/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CMDeviceMotion, CMMagnetometerData;

@interface SQUPositionalSensorInterface : NSObject <CLLocationManagerDelegate>

@property (readonly) CMDeviceMotion *motionData;
@property (readonly) CMDeviceMotion *motionDataLastVal;

@property (readonly) CMMagnetometerData *magnetometerData;

/// This is YES if we have been authorized to access the sensors required.
@property (readonly) BOOL isAuthorized;

/// Time interval, in seconds, at which data should be updated.
@property float updateInterval;

/// Last available heading data
@property (nonatomic) CLHeading *heading;

/**
 * Requests permission to access the current location, user motion data, and accelerometer
 * data. This should be called before utilising the framework.
 */
- (void) requestLocationPermissions;

/**
 * Stops the gathering of data. This should be used to reduce battery consumption when
 * the app is backgrounded, or the VR view is not on-screen at the moment.
 */
- (void) stopDataCollection;

/**
 * Restarts collection of data. This need only be called if -stopDataCollection has
 * previously been called.
 */
- (void) startDataCollection;

@end
