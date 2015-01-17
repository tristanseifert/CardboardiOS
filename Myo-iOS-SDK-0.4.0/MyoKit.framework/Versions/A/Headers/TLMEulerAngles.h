//
//  TLMEulerAngles.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>
#import "TLMMath.h"
#import "TLMAngle.h"

/**
   The Euler angle representation of a particular orientation.
 */
@interface TLMEulerAngles : NSObject <NSCopying>

/**
   The pitch of the Myo. This is the vertical angle between your arm exended and a line pointing directly to the
   horizon. The values will range between -90 to 90 degrees.
 */
@property (nonatomic, strong, readonly) TLMAngle *pitch;

/**
   The roll of the Myo. This is the angle at which your arm is rotated. Think of a "screwing a lightbulb" motion.
   The values will range between -180 to 180 degrees.
 */
@property (nonatomic, strong, readonly) TLMAngle *roll;

/**
   The yaw of the Myo. This is the angle your arm is making with respect to the north pole. Imagine your arm as a compass.
   The values will range between -180 to 180 degrees.
 */
@property (nonatomic, strong, readonly) TLMAngle *yaw;

/**
   Creates and returns the Euler angles corresponding to the given quaternion.
 */
+ (instancetype)anglesWithQuaternion:(TLMQuaternion)quaternion;

@end
