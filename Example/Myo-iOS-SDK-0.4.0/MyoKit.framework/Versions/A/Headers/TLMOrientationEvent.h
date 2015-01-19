//
//  TLMOrientationEvent.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>
#import "TLMMath.h"
#import "TLMEulerAngles.h"

@class TLMMyo;

/**
   Represents the orientation of a TLMMyo. The orientation is represented via a quaternion.
 */
@interface TLMOrientationEvent : NSObject <NSCopying>

/**
   The TLMMyo whose orientation changed.
 */
@property (nonatomic, weak, readonly) TLMMyo *myo;

/**
   Orientation representation as a normalized quaternion.
 */
@property (nonatomic, readonly) TLMQuaternion quaternion;

/**
   The timestamp associated with the orientation.
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
