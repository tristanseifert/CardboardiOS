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

@interface SQUCardboardKit : NSObject {
	
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, readonly) SCNVector3 cameraAngle;

+ (instancetype) sharedInstance;

- (void) configureSensors;

@end
