//
//  TLMHub.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TLMMyo.h"

/**
 @defgroup hubNotifications NSNotificationCenter Hub Constants
 These are events sent when the manager detects any change in a TLMMyo's state.
 These can be subscribed to through NSNotificationCenter. They are posted in the default center on the main dispatch
 queue.

 @{
 */

/**
 Posted whenever the TLMHub attaches to a TLMMyo.
 */
extern NSString *const TLMHubDidAttachDeviceNotification;

/**
 Posted whenever the TLMHub detaches from a TLMMyo.
 */
extern NSString *const TLMHubDidDetachDeviceNotification;

/**
 Posted whenever the TLMHub connects to a TLMMyo.
 */
extern NSString *const TLMHubDidConnectDeviceNotification;

/**
 Posted whenever the TLMHub disconnects from a TLMMyo.
 */
extern NSString *const TLMHubDidDisconnectDeviceNotification;

/** @} */

//--------
// TLMHub
//--------

/**
 The TLMHub singleton manages TLMMyos.
 */
@interface TLMHub : NSObject

/**
 Represents the locking policy for Myos connected to the TLMHub.
 */
typedef NS_ENUM (NSInteger, TLMLockingPolicy) {
    TLMLockingPolicyStandard, /**< Pose events are not sent while a TLMMyo is locked. */
    TLMLockingPolicyNone      /**< Pose events are always sent. */
};

/**
 Controls how many TLMMyos are allowed to connect to your app at once. Default value is 1. Undefined behaviour for
 myoConnectionAllowance > 2.
 */
@property (nonatomic, readwrite) NSUInteger myoConnectionAllowance;

/**
 The applicationIdentifier must follow a reverse domain name format (ex. com.domainname.appname). Application
 identifiers can be formed from the set of alphanumeric ASCII characters (a-z, A-Z, 0-9). The hyphen (-) and
 underscore (_) characters are permitted if they are not adjacent to a period (.) character  (i.e. not at the
 start or end of each segment), but are not permitted in the top-level domain. Application identifiers must have
 three or more segments. For example, if a company's domain is example.com and the application is named
 hello-world, one could use "com.example.hello-world" as a valid application identifier. applicationIdentifier
 can be an empty string.
 */
@property (nonatomic, readwrite) NSString *applicationIdentifier;

/**
 Determines whether notifications get posted when the app is in the background. Default value is NO.
 */
@property (nonatomic, readwrite) BOOL shouldNotifyInBackground;

/**
 Set whether Myo usage data should be sent to Thalmic Labs. Default value is YES.
 */
@property (nonatomic, readwrite) BOOL shouldSendUsageData;

/**
 The locking policy enforced by this TLMHub. Defaults to TLMLockingPolicyStandard.
 @see TLMLockingPolicy
 */
@property (nonatomic, readwrite) TLMLockingPolicy lockingPolicy;

/**
 Singleton accessor.
 @return The shared instance of the TLMHub class.
 */
+ (instancetype)sharedHub;

/**
 A snapshot of the list of TLMMyos currently connected to TLMHub.
 @return NSArray containing the connected TLMMyos.
 */
- (NSArray *)myoDevices;

/**
 Invoking this method instructs the TLMHub to wait for a TLMMyo to touch the iOS device. Once a TLMMyo is attached, this
 method needs to be called again in order to pair with another TLMMyo. If the myoConnectionAllowance has been reached
 when this method is called, nothing happens. If another attaching method has been invoked, nothing happens.
 @see myoConnectionAllowance
 */
- (void)attachToAdjacent;

/**
 Searches for the TLMMyo represented by the identifier, and attaches to it. If the myoConnectionAllowance has been
 reached when this method is called, nothing happens. If another attaching method has been invoked, nothing happens.
 */
- (void)attachByIdentifier:(NSUUID *)identifier;

/**
 Disconnects from the Myo, and stops trying to connect to it.
 */
- (void)detachFromMyo:(TLMMyo *)myo;

@end

/// @example TLHMViewController.m
