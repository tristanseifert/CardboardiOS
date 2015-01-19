//
//  TLMRotationRateData.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>
#import "TLMMath.h"

@class TLMMyo;

/**
   Represents the current gyroscope values reported by a TLMMyo's gyroscope. Units are in rad/s.
 */
@interface TLMGyroscopeEvent : NSObject <NSCopying>

/**
   The TLMMyo associated with the gyroscope event.
 */
@property (nonatomic, weak, readonly) TLMMyo *myo;

/**
   A vector representing the TLMMyo's gyroscope values (in rad/s).
 */
@property (nonatomic, readonly) TLMVector3 vector;

/**
   The timestamp associated with the gyroscope event.
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
