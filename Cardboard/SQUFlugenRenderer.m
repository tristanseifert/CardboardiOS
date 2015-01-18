//
//  SQUFlugenRenderer.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUFlugenRenderer.h"

#import <MyoKit/MyoKit.h>
#import <KVNProgress/KVNProgress.h>

@interface SQUFlugenRenderer ()

- (void) setUpMyoConnection;

@property (strong, nonatomic) TLMPose *currentPose;

@property NSString *typeOfPlane; //can be @"F-14" or @""

@end

@implementation SQUFlugenRenderer

/**
 * Initialiser
 */
- (id) init {
	if(self = [super init]) {
		
	}
	
	return self;
}

#pragma mark - Rendering
/**
 * When the controller is initialised, this method allows the renderer to add
 * its nodes.
 */
- (void) addNodesToScene:(SCNScene *) scene {
    NSError *err = nil;
    
	// create skybox
	scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
    //if([self.typeOfPlane isEqualToString:@"F-14"]){    
    SCNSceneSource *sceneLoader = [SCNSceneSource sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"f-14-super-tomcat" withExtension:@"dae"] options:nil];
    SCNScene *planeScn = [sceneLoader sceneWithOptions:@{} error:&err];
    NSAssert(err == nil, @"error loading pls: %@", err);
    
//        plane.rootNode.position = SCNVector3Make(-10, -10, 0);
    //}
    for(SCNNode *node in planeScn.rootNode.childNodes){
        NSLog(@"plane is %@", node);
        [scene.rootNode addChildNode:node];
    }
    
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
- (void) doMyoInit {
	// Set up Myo lock policy
	[TLMHub sharedHub].lockingPolicy = TLMLockingPolicyNone;
	
	// Are any Myos known to the device?
	if([TLMHub sharedHub].myoDevices.count == 0) {
		UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
		[_rootVC presentViewController:controller animated:YES completion:nil];
		
		DDLogVerbose(@"Opening Myo searching controller…");
	} else {
		[[TLMHub sharedHub] attachToAdjacent];
		DDLogVerbose(@"Attaching to adjacent Myos");
		
		[KVNProgress showWithStatus:@"Connecting to Myo…"];
	}
	
	// Set up the notifications
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didAttachDevice:)
												 name:TLMHubDidAttachDeviceNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didDetachDevice:)
												 name:TLMHubDidDetachDeviceNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didConnectDevice:)
												 name:TLMHubDidConnectDeviceNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didDisconnectDevice:)
												 name:TLMHubDidDisconnectDeviceNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didSyncArm:)
												 name:TLMMyoDidReceiveArmSyncEventNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didUnsyncArm:)
												 name:TLMMyoDidReceiveArmUnsyncEventNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didUnlockDevice:)
												 name:TLMMyoDidReceiveUnlockEventNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didLockDevice:)
												 name:TLMMyoDidReceiveLockEventNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceiveOrientationEvent:)
												 name:TLMMyoDidReceiveOrientationEventNotification
											   object:nil];
	/*[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceiveAccelerometerEvent:)
												 name:TLMMyoDidReceiveAccelerometerEventNotification
											   object:nil];*/
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceivePoseChange:)
												 name:TLMMyoDidReceivePoseChangedNotification
											   object:nil];
}

#pragma mark - Mayo Notifications
/**
 * Device was attached
 */
- (void) didAttachDevice:(NSNotification *) notification {
	DDLogWarn(@"Device Attached");
}

/**
 * Device has been detached.
 */
- (void) didDetachDevice:(NSNotification *) notification {
	DDLogWarn(@"Device Detached!");
}

/**
 * Myo has been connected, and needs the sync gesture to be performed
 */
- (void) didConnectDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Connected: Perform Sync Gesture");
	
	[_rootVC dismissViewControllerAnimated:YES completion:NULL];
	[KVNProgress showSuccessWithStatus:@"Perform Sync Gesture"];
}

/**
 * Myo has disconnected
 */
- (void) didDisconnectDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Disconnected");
	
	UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
	[_rootVC presentViewController:controller animated:YES completion:nil];
}

/**
 * Device was unlocked by gesture
 */
- (void) didUnlockDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Unlocked");
}

/**
 * Device was locked
 */
- (void) didLockDevice:(NSNotification *) notification {
	DDLogVerbose(@"Myo Locked");
}

/**
 * Called when the arm is synchronised.
 */
- (void) didSyncArm:(NSNotification *) notification {
	TLMArmSyncEvent *armEvent = notification.userInfo[kTLMKeyArmSyncEvent];
	
	// Update the armLabel with arm information.
	DDLogVerbose(@"%@ Arm, %@", ((armEvent.arm == TLMArmRight) ? @"Right" : @"Left"), ((armEvent.xDirection == TLMArmXDirectionTowardWrist) ? @"Toward Wrist" : @"Toward Elbow"));
}

/**
 * Called when the arm needs to be resynchronised.
 */
- (void) didUnsyncArm:(NSNotification *) notification {
	DDLogWarn(@"Perform Sync Gesture !!!");
	
	[KVNProgress showErrorWithStatus:@"Perform Sync Gesture"];
}

/**
 * New orientation: roll, pitch, yaw
 */
- (void) didReceiveOrientationEvent:(NSNotification *) notification {
	TLMOrientationEvent *orientationEvent = notification.userInfo[kTLMKeyOrientationEvent];
	TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
	
	DDLogVerbose(@"roll = %.4f, yaw = %.4f, pitch = %.4f", angles.roll.degrees, angles.yaw.degrees, angles.pitch.degrees);
	
	// use pitch to fly up/down (negative = up, positive = down)
	
	// roll to left/right:
}

/**
 * Quantity of acceleration
 */
/*- (void) didReceiveAccelerometerEvent:(NSNotification *) notification {
	// Retrieve the accelerometer event from the NSNotification's userInfo with the kTLMKeyAccelerometerEvent.
	TLMAccelerometerEvent *accelerometerEvent = notification.userInfo[kTLMKeyAccelerometerEvent];
	
	// Get the acceleration vector from the accelerometer event.
	TLMVector3 accelerationVector = accelerometerEvent.vector;
	
	// Calculate the magnitude of the acceleration vector.
	float magnitude = TLMVector3Length(accelerationVector);
}*/

/**
 * Different pose
 */
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
		[pose.myo unlockWithType:TLMUnlockTypeHold];
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
