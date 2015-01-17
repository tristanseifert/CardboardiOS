//
//  TLMAccelerometerEvent.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>
#import "TLMMath.h"

@class TLMMyo;

/**
   Represents the current accelerometer values reported by a TLMMyo's accelerometer. Units are in Gs.
 */
@interface TLMAccelerometerEvent : NSObject <NSCopying>

/**
   The TLMMyo associated with the acceleration event.
 */
@property (nonatomic, weak, readonly) TLMMyo *myo;

/**
   A vector representing the TLMMyo's acceleration (in Gs).
 */
@property (nonatomic, readonly) TLMVector3 vector;

/**
   The timestamp associated with the acceleration event.
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
