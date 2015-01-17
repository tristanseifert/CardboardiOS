//
//  TLMArmSyncEvent.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>

@class TLMMyo;

@interface TLMArmSyncEvent : NSObject <NSCopying>

/**
 An enum representing the arm location of a TLMMyo.
 */
typedef NS_ENUM (NSInteger, TLMArm) {
    TLMArmUnknown,  /**< Myo location is not known.*/
    TLMArmRight,    /**< Myo is on the right arm.*/
    TLMArmLeft      /**< Myo is on the left arm.*/
};

/**
 An enum representing the direction of the +x axis of a TLMMyo.
 */
typedef NS_ENUM (NSInteger, TLMArmXDirection) {
    TLMArmXDirectionUnknown,        /**< Myo's +x axis is not known.*/
    TLMArmXDirectionTowardWrist,    /**< Myo's +x axis is pointing toward the user's wrist.*/
    TLMArmXDirectionTowardElbow     /**< Myo's +x axis is pointing toward the user's elbow.*/
};

/**
 The TLMMyo that has been synced with an arm.
 */
@property (nonatomic, weak, readonly) TLMMyo *myo;

/**
 The arm that the Myo armband is on.
 */
@property (nonatomic, readonly) TLMArm arm;

/**
 The +x axis direction of the Myo armband relative to a user's arm.
 */
@property (nonatomic, readonly) TLMArmXDirection xDirection;

/**
 The timestamp associated with the arm sync event.
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
