//
//  SQUFlugenRenderer.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUEntityLoader.h"
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
	// create skybox
	//scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
/*
	// asdjasklfjakls;fdas
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"f-14-super-tomcat" withExtension:@"dae"];
	SCNNode *n = [[SQUEntityLoader sharedInstance] nodeFromFile:url];
	
	DDLogVerbose(@"%@", n);
	
	[scene.rootNode addChildNode:n];*/
    // create spherical geometry
    SCNSphere *_sphere = [SCNSphere sphereWithRadius:5.0];
    _sphere.firstMaterial.diffuse.contents = [UIColor redColor];
    _sphere.firstMaterial.cullMode = SCNCullFront;
    
    SCNNode *node = [SCNNode nodeWithGeometry:_sphere];
    node.position = SCNVector3Make(0, 0, -10);
    [scene.rootNode addChildNode:node];
    
    //init some key code for registering buttonPress
    [[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"cameraAngle" options:0 context:NULL];
    [[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"buttonPress" options:0 context:NULL];
    
    //NSLog(@"cameraAngle %f",[SQUCardboardKit sharedInstance].cameraAngle.x);
    //initialise ourself as a physics body
    
    [scene.rootNode setPhysicsBody:[SCNPhysicsBody dynamicBody]];
    
    scene.rootNode.physicsBody.mass = 100.0; //100kg
    scene.rootNode.physicsBody.type = SCNPhysicsBodyTypeDynamic;
    scene.rootNode.physicsBody.physicsShape = [SCNPhysicsShape shapeWithGeometry:[SCNSphere sphereWithRadius:1.0] options:nil];
    scene.rootNode.physicsBody.collisionBitMask = SCNPhysicsCollisionCategoryDefault;
    scene.rootNode.physicsBody.categoryBitMask = SCNPhysicsCollisionCategoryDefault;

    //GRAVITY! dagnabbit
    //[scene.rootNode.physicsBody applyForce:SCNVector3Make(0, 9.8, 0) impulse:NO];
    
    //SKYBOXXX
    scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
}

/**
 * Every frame, before the scene is rendered, this method is called. Any sort of
 * animations or modifications can do things here.
 */
- (void) willRenderScene:(SCNScene *) scene {
    _scene = scene;
}

/**
 * Called right before the scene is torn down. Any cleanup can be done here.
 */
- (void) willTearDownScene:(SCNScene *) scene {
	
}

#pragma mark - Flying Physics
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"buttonPress"]){
        [self accelerateAtAngle:[SQUCardboardKit sharedInstance].cameraAngle];
    }
}
-(void)accelerateAtAngle:(SCNVector3)angle{
    NSLog(@"vectors for speedy: %f %f %f",angle.x, angle.y, angle.z);
    
    [_scene.rootNode.physicsBody applyForce:SCNVector3Make(1000*angle.x, 1000*angle.y, 1000*angle.z) impulse:NO];
    //[_scene.rootNode.physicsBody setVelocity:SCNVector3Make(10*angle.x, 10*angle.y, 10*angle.z)];
}
#pragma mark - Myo
/**
 * Initialises Myo
 */
- (void) doMyoInit {
	return;
	
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
