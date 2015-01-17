//
//  SQUFlugenRenderer.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUFlugenRenderer.h"

#import <MyoKit/MyoKit.h>

@interface SQUFlugenRenderer ()

- (void) setUpMyoConnection;

@property (strong, nonatomic) TLMPose *currentPose;

@end

@implementation SQUFlugenRenderer

/**
 * Initialiser
 */
- (id) init {
	if(self = [super init]) {
		[self setUpMyoConnection];
	}
	
	return self;
}

#pragma mark - Rendering
/**
 * When the controller is initialised, this method allows the renderer to add
 * its nodes.
 */
- (void) addNodesToScene:(SCNScene *) scene {
	
	// create skybox
	scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
}

/**
 * Every frame, before the scene is rendered, this method is called. Any sort of
 * animations or modifications can do things here.
 */
- (void) willRenderScene:(SCNScene *) scene {
	
}

/**
 * Called right before the scene is torn down. Any cleanup can be done here.
 */
- (void) willTearDownScene:(SCNScene *) scene {
	
}

#pragma mark - Myo
- (void) setUpMyoConnection {
	// Data notifications are received through NSNotificationCenter.
	// Posted whenever a TLMMyo connects
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didConnectDevice:)
												 name:TLMHubDidConnectDeviceNotification
											   object:nil];
	// Posted whenever a TLMMyo disconnects.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didDisconnectDevice:)
												 name:TLMHubDidDisconnectDeviceNotification
											   object:nil];
	// Posted whenever the user does a successful Sync Gesture.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didSyncArm:)
												 name:TLMMyoDidReceiveArmSyncEventNotification
											   object:nil];
	// Posted whenever Myo loses sync with an arm (when Myo is taken off, or moved enough on the user's arm).
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didUnsyncArm:)
												 name:TLMMyoDidReceiveArmUnsyncEventNotification
											   object:nil];
	// Posted whenever Myo is unlocked and the application uses TLMLockingPolicyStandard.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didUnlockDevice:)
												 name:TLMMyoDidReceiveUnlockEventNotification
											   object:nil];
	// Posted whenever Myo is locked and the application uses TLMLockingPolicyStandard.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didLockDevice:)
												 name:TLMMyoDidReceiveLockEventNotification
											   object:nil];
	// Posted when a new orientation event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceiveOrientationEvent:)
												 name:TLMMyoDidReceiveOrientationEventNotification
											   object:nil];
	// Posted when a new accelerometer event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceiveAccelerometerEvent:)
												 name:TLMMyoDidReceiveAccelerometerEventNotification
											   object:nil];
	// Posted when a new pose is available from a TLMMyo.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceivePoseChange:)
												 name:TLMMyoDidReceivePoseChangedNotification
											   object:nil];
}

#pragma mark - Mayo Notifications
- (void) didConnectDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Connected: Perform Sync Gesture");
}

- (void) didDisconnectDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Disconnected");
}

- (void) didUnlockDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Unlocked");
}

- (void) didLockDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Locked");
}

- (void) didSyncArm:(NSNotification *) notification {
	// Retrieve the arm event from the notification's userInfo with the kTLMKeyArmSyncEvent key.
	TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
	
	// Update the armLabel with arm information.
	DDLogVerbose(@"%@ Arm, %@", (TLMArmRight ? @"Right" : @"Left"), (TLMArmXDirectionTowardWrist ? @"Toward Wrist" : @"Toward Elbow"));
}

- (void) didUnsyncArm:(NSNotification *) notification {
	DDLogWarn(@"Perform Sync Gesture !!!");
}

- (void) didReceiveOrientationEvent:(NSNotification *) notification {
	// Retrieve the orientation from the NSNotification's userInfo with the kTLMKeyOrientationEvent key.
	TLMOrientationEvent *orientationEvent = notification.userInfo[kTLMKeyOrientationEvent];
	
	// Create Euler angles from the quaternion of the orientation.
	TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
	
	//DDLogInfo(@"Orientation Angles: %@", angles);
}

- (void) didReceiveAccelerometerEvent:(NSNotification *) notification {
	// Retrieve the accelerometer event from the NSNotification's userInfo with the kTLMKeyAccelerometerEvent.
	TLMAccelerometerEvent *accelerometerEvent = notification.userInfo[kTLMKeyAccelerometerEvent];
	
	// Get the acceleration vector from the accelerometer event.
	TLMVector3 accelerationVector = accelerometerEvent.vector;
	
	// Calculate the magnitude of the acceleration vector.
	float magnitude = TLMVector3Length(accelerationVector);
	//DDLogInfo(@"Acceleration Magnitude: %f", magnitude);
}

- (void) didReceivePoseChange:(NSNotification *) notification {
	// Retrieve the pose from the NSNotification's userInfo with the kTLMKeyPose key.
	TLMPose *pose = notification.userInfo[kTLMKeyPose];
	_currentPose = pose;
	
	// Handle the cases of the TLMPoseType enumeration, and change the color of helloLabel based on the pose we receive.
	switch (pose.type) {
		case TLMPoseTypeUnknown:
		case TLMPoseTypeRest:
			//DDLogInfo(@"Rest");
			break;
		case TLMPoseTypeDoubleTap:
			DDLogInfo(@"Double Tap");
			break;
		case TLMPoseTypeFist:
			DDLogInfo(@"Fist");
			break;
		case TLMPoseTypeWaveIn:
			DDLogInfo(@"Wave In");
			break;
		case TLMPoseTypeWaveOut:
			DDLogInfo(@"Wave Out");
			break;
		case TLMPoseTypeFingersSpread:
			DDLogInfo(@"Fingers Spreaded");
			break;
	}
	
	// Unlock the Myo whenever we receive a pose
	if (pose.type == TLMPoseTypeUnknown || pose.type == TLMPoseTypeRest) {
		// Causes the Myo to lock after a short period.
		[pose.myo unlockWithType:TLMUnlockTypeTimed];
	} else {
		// Keeps the Myo unlocked until specified.
		// This is required to keep Myo unlocked while holding a pose, but if a pose is not being held, use
		// TLMUnlockTypeTimed to restart the timer.
		[pose.myo unlockWithType:TLMUnlockTypeHold];
		// Indicates that a user action has been performed.
		[pose.myo indicateUserAction];
	}
}

@end
