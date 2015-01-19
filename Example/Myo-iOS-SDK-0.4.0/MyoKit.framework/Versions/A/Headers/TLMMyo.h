//
//  TLMMyo.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import "TLMOrientationEvent.h"
#import "TLMAccelerometerEvent.h"
#import "TLMPose.h"
#import "TLMArmSyncEvent.h"

//---------------
// Notifications
//---------------

/**
 @defgroup deviceNotifications NSNotificationCenter Device Constants
 These are notifications posted by the device when new data is available.
 They are posted by the default center on the main dispatch queue.
 Data associated with the notification can be found in the notification's userInfo dictionary.
 @see deviceNotificationDataKeys.

 @{
 */

/** 
 Posted when a new orientation event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.

 kTLMKeyOrientationEvent -> TLMOrientationEvent
 */
extern NSString *const TLMMyoDidReceiveOrientationEventNotification;

/** 
 Posted when a new accelerometer event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.

 kTLMKeyAccelerometerEvent -> TLMAccelerometerEvent
 */
extern NSString *const TLMMyoDidReceiveAccelerometerEventNotification;

/**
 Posted when a new gyroscope event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.

 kTLMKeyGyroscopeEvent -> TLMGyroscopeEvent
 */
extern NSString *const TLMMyoDidReceiveGyroscopeEventNotification;

/**
 Posted when a new pose is available from a TLMMyo.

 kTLMKeyPose -> TLMPose
 */
extern NSString *const TLMMyoDidReceivePoseChangedNotification;

/**
 Posted when a Myo armband is synced with an arm.

 kTLMKeyArmSyncEvent -> TLMArmSyncEvent
 */
extern NSString *const TLMMyoDidReceiveArmSyncEventNotification;

/**
 Posted when a Myo armband is moved or removed from the arm.

 kTLMKeyArmUnsyncEvent -> TLMArmUnsyncEvent
 */
extern NSString *const TLMMyoDidReceiveArmUnsyncEventNotification;

/**
 Posted when a Myo is unlocked.

 kTLMKeyUnlockEvent -> TLMUnlockEvent
 */
extern NSString *const TLMMyoDidReceiveUnlockEventNotification;

/**
 Posted when a Myo is locked.

 kTLMKeyLockEvent -> TLMLockEvent
 */
extern NSString *const TLMMyoDidReceiveLockEventNotification;

/** @} */

/**
 @defgroup deviceNotificationDataKeys NSNotificationCenter Device Data Key Constants
 These keys correspond to data stored in a notifications userInfo dictionary.
 @see deviceNotifications

  @{
 */

/**
 NSNotification userInfo key for a TLMOrientationEvent object.
 */
extern NSString *const kTLMKeyOrientationEvent;

/**
 NSNotification userInfo key for a TLMAccelerometerEvent object.
 */
extern NSString *const kTLMKeyAccelerometerEvent;

/**
 NSNotification userInfo key for a TLMGyroscopeEvent object.
 */
extern NSString *const kTLMKeyGyroscopeEvent;

/**
 NSNotification userInfo key for a TLMPose object.
 */
extern NSString *const kTLMKeyPose;

/**
 NSNotification userInfo key for a TLMArmSyncEvent object.
 */
extern NSString *const kTLMKeyArmSyncEvent;

/**
 NSNotification userInfo key for a TLMArmUnsyncEvent object.
 */
extern NSString *const kTLMKeyArmUnsyncEvent;

/**
 NSNotification userInfo key for a TLMUnlockEvent object.
 */
extern NSString *const kTLMKeyUnlockEvent;

/**
 NSNotification userInfo key for a TLMLockEvent object.
 */
extern NSString *const kTLMKeyLockEvent;

/** @} */

//--------
// TLMMyo
//--------

/**
 Represents a Myo.

 Do not implement NSCopying. You should not be able to copy TLMMyo. Do not subclass. Do not maintain strong
 references to instances of this class, as this can cause unexpected behaviour. TLMHub will keep track of TLMMyos.
 */
@interface TLMMyo : NSObject

/**
 Represents the connection state of a TLMMyo.
 */
typedef NS_ENUM (NSInteger, TLMMyoConnectionState) {
    TLMMyoConnectionStateConnected,   /**< TLMMyo is connected */
    TLMMyoConnectionStateConnecting,  /**< TLMMyo is in the process of connecting */
    TLMMyoConnectionStateDisconnected /**< TLMMyo is not connected */
};

/**
 Represents the different types of vibrations a TLMMyo can make.
 */
typedef NS_ENUM (NSInteger, TLMVibrationLength) {
    TLMVibrationLengthShort,  /**< A vibration lasting a small amount of time */
    TLMVibrationLengthMedium, /**< A vibration lasting a moderate amount of time */
    TLMVibrationLengthLong    /**< A vibration lasting a long amount of time */
};

/**
 Represents the different ways to unlock a TLMMyo.
 */
typedef NS_ENUM (NSInteger, TLMUnlockType) {
    TLMUnlockTypeTimed, /**< Unlock now and re-lock after a fixed time. */
    TLMUnlockTypeHold     /**< Unlock now and remain unlocked until a lock command is received. */
};

/**
 The name of the TLMMyo.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 The identifier for the TLMMyo.
 */
@property (nonatomic, strong, readonly) NSUUID *identifier;

/**
 A snapshot of the current state of the TLMMyo.
 */
@property (nonatomic, readonly) TLMMyoConnectionState state;

/**
 The current lock state of the Myo.
 */
@property (nonatomic, readonly) BOOL isLocked;

/**
 The current pose being recognized by the TLMMyo.
 */
@property (nonatomic, strong, readonly) TLMPose *pose;

/**
 The current orientation of the Myo.
 */
@property (nonatomic, strong, readonly) TLMOrientationEvent *orientation;

/**
 The arm that the TLMMyo is currently being worn on.
 */
@property (nonatomic, readonly) TLMArm arm;

/**
 The direction of the +x axis of the TLMMyo.
 */
@property (nonatomic, readonly) TLMArmXDirection xDirection;

- (instancetype)init __attribute__((unavailable("init not available")));

/**
 Performs an asynchronous read of the signal strength, passing the resulting value in the result block. The resultBlock
 is executed on the main thread.
 @param resultBlock The resulting signal strength is passed into this block.
 */
- (void)readSignalStrengthWithResult:(void(^)(NSNumber * signalStrength))resultBlock;

/**
 Engage the TLMMyo's built in vibration motor.
 @param length The amount of time the vibration motor will be active.
 */
- (void)vibrateWithLength:(TLMVibrationLength)length;

/**
 Inform the Myo to react to a user action.
 */
- (void)indicateUserAction;

/**
 Force the TLMMyo to unlock with the specified type. If the TLMMyo is already unlocked, calling this method will extend
 it.
 @see TLMUnlockType
 */
- (void)unlockWithType:(TLMUnlockType)type;

/**
 Force the TLMMyo to lock again. Has no effect if the TLMMyo is already locked.
 */
- (void)lock;

@end
