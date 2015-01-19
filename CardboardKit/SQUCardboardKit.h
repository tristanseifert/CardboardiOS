//
//  SQUCardboardKit.h
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <SceneKit/SceneKit.h>

#import "SQURenderDelegate.h"

#define kSQUCardboardKitButtonPressedNotification @"kSQUCardboardKitButtonPressedNotification"

@class SQUPositionalSensorInterface;
@interface SQUCardboardKit : NSObject <CLLocationManagerDelegate> {
	BOOL _buttonDownNotification;
}

/// Handles data from the sensors
@property (nonatomic, readonly) SQUPositionalSensorInterface *posSensors;

/// Euller's angles
@property (nonatomic, readonly) SCNVector3 cameraAngle;

/**
 * Gets the shared instance. It automatically initialises whatever else is required.
 */
+ (instancetype) sharedInstance;

/**
 * Requests authorization to access motion data.
 */
- (void) requestAuthorization;

@end
