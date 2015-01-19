//
//  SQUCardboardKit.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <SceneKit/SceneKit.h>

#import "SQURenderDelegate.h"

#define kSQUCardboardKitButtonPressedNotification @"kSQUCardboardKitButtonPressedNotification"

@interface SQUCardboardKit : NSObject <CLLocationManagerDelegate> {
	BOOL _buttonDownNotification;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

/// Euller's angles
@property (nonatomic, readonly) SCNVector3 cameraAngle;

+ (instancetype) sharedInstance;

- (void) configureSensors;

@end
