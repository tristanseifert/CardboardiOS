//
//  SQUCardboardKit.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUPositionalSensorInterface.h"
#import "SQUCardboardKit.h"

// Configurables
#define kButtonTolerance 166

/// Holds the shared instance of the cardboard interface.
static SQUCardboardKit *sharedInstance = nil;

#pragma mark - Private
#pragma mark Properties
@interface SQUCardboardKit ()

@property float magnetometerLastVal;
@property BOOL buttonPress;

@property (nonatomic) dispatch_queue_t processingQueue;

@property CMDeviceMotion *motionDataLast;

@end

#pragma mark Functions
@interface SQUCardboardKit ()

- (void) processMagnetometer;
- (void) processAccelerometer;

@end

#pragma mark - Initialisation
@implementation SQUCardboardKit

/**
 * Create/returns shared instance
 */
+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SQUCardboardKit alloc] init];
	});
	
	return sharedInstance;
}

- (id) init {
	if(self = [super init]) {
		// Configure some default values
		_buttonPress = NO;
		_cameraAngle = SCNVector3Make(-M_PI_2, 0, 0);
		
		// Set up the queue
		_processingQueue = dispatch_queue_create("CardboardKitProcessing", NULL);
	
		// Initialise the sensor controller
		_posSensors = [[SQUPositionalSensorInterface alloc] init];
		
		// Initialise KVO
		[_posSensors addObserver:self forKeyPath:@"magnetometerData"
					  options:0 context:NULL];
		[_posSensors addObserver:self forKeyPath:@"motionData"
					  options:0 context:NULL];
	}
	
	return self;
}

/**
 * Cleans up any KVO and notification bindings.
 */
- (void) dealloc {
	[_posSensors removeObserver:self forKeyPath:@"magnetometerData"];
	[_posSensors removeObserver:self forKeyPath:@"motion"];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark KVO
/**
 * KVO Handler: in here, we send off requests to process the various sensors' data in
 * our background processing queue.
 */
- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object
						 change:(NSDictionary *) change context:(void *) context{
    if([keyPath isEqualToString:@"magnetometerData"]){
		dispatch_async(_processingQueue, ^{
			[self processMagnetometer];
		});
    } else if([keyPath isEqualToString:@"motionData"]){
		dispatch_async(_processingQueue, ^{
			[self processAccelerometer];
		});
    }
}

#pragma mark - Data Processing
/**
 * Processes data from the magnetometer.
 */
- (void) processMagnetometer {
	// Get magnometer data
	CMMagnetometerData *magnoData = _posSensors.magnetometerData;
	
	// Determine if the button is being held down
	if((_magnetometerLastVal - magnoData.magneticField.z) >= kButtonTolerance
	   && _magnetometerLastVal != 0) {
		[self willChangeValueForKey:@"buttonPress"];
		_buttonPress = YES;
		[self didChangeValueForKey:@"buttonPress"];
		
		_buttonDownNotification = YES;
	}
	
	if((magnoData.magneticField.z - _magnetometerLastVal) >= kButtonTolerance
	   && magnoData.magneticField.z != 0) {
		[self willChangeValueForKey:@"buttonPress"];
		if(_buttonPress == YES){
			_buttonPress = NO;
		}
		
		[self didChangeValueForKey:@"buttonPress"];
		
		// hysterisis
		if(_buttonDownNotification) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kSQUCardboardKitButtonPressedNotification object:nil];
			_buttonDownNotification = NO;
		}
	}
	
	// Store the last value of the magnometer: used to detect the ∆ for button
	_magnetometerLastVal = magnoData.magneticField.z;
}

/**
 * Processes the accelerometer's six axes of data.
 */
- (void) processAccelerometer {
	// Motion data from accelerometer
	CMDeviceMotion *motionData = _posSensors.motionData;
	
	// Get the three basic axes
	float yaw = (motionData.attitude.yaw - _motionDataLast.attitude.yaw);
	float roll = -(motionData.attitude.roll - _motionDataLast.attitude.roll );
	float pitch = (motionData.attitude.pitch - _motionDataLast.attitude.pitch );
	
	// Store the motion data, as CMDeviceMotion are deltas
	_motionDataLast = motionData;
	
	// observed by the renderer
	[self willChangeValueForKey:@"cameraAngle"];
	_cameraAngle.x += roll;
	_cameraAngle.y += yaw;
	_cameraAngle.z += -pitch;
	[self didChangeValueForKey:@"cameraAngle"];
}


#pragma mark Miscellaneous
/**
 * Requests authorization to access motion data.
 */
- (void) requestAuthorization {
	[_posSensors requestLocationPermissions];
}

@end