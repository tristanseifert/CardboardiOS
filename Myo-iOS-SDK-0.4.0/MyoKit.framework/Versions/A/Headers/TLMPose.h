//
//  TLMPose.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>

@class TLMMyo;

//---------
// TLMPose
//---------

/** Represents a hand pose detected by a TLMMyo. */
@interface TLMPose : NSObject <NSCopying>

/**
   Represents different hand poses.
 */
typedef NS_ENUM (NSInteger, TLMPoseType) {
    TLMPoseTypeRest,            /**< Rest pose.*/
    TLMPoseTypeFist,            /**< User is making a fist.*/
    TLMPoseTypeWaveIn,          /**< User has an open palm rotated towards the posterior of their wrist.*/
    TLMPoseTypeWaveOut,         /**< User has an open palm rotated towards the anterior of their wrist.*/
    TLMPoseTypeFingersSpread,   /**< User has an open palm with their fingers spread away from each other.*/
    TLMPoseTypeDoubleTap,       /**< User taps their thumb to their middle finger twice.*/
    TLMPoseTypeUnknown = 0xffff /**< Unknown pose.*/
};

/** The TLMMyo posting the pose. */
@property (nonatomic, weak, readonly) TLMMyo *myo;

/** The pose being recognized. */
@property (nonatomic, readonly) TLMPoseType type;

/** The time the pose was recognized. */
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
