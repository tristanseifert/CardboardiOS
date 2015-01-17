//
//  SQUCardboardKit.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUCardboardKit.h"

#define kMotionUpdateInterval 0.05

static SQUCardboardKit *sharedInstance = nil;

@interface SQUCardboardKit ()

@property CMDeviceMotion *motionData;
@property CMDeviceMotion *motionDataLastVal;

@property CMMagnetometerData *magnetometerData;
@property float magnetometerLastVal;

@property (strong) CMMotionManager *motionManager;

@end

@implementation SQUCardboardKit

/**
 * Create shared instance
 */
+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SQUCardboardKit alloc] init];
	});
	
	return sharedInstance;
}

 /**
 * Requests location permissions
 */
- (void) requestPermissions {
	//check on location data permissions
	_locationManager = [[CLLocationManager alloc] init];
	CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
	
	if(authStatus == (kCLAuthorizationStatusRestricted | kCLAuthorizationStatusDenied)){ //need to ask permission
		[_locationManager requestWhenInUseAuthorization]; //ask permission
	}
	
	// is heading available ??!?!?!????!
	if(_locationManager.headingAvailable){ //cool, let's set it up
		_locationManager.delegate = self;
		_locationManager.headingFilter = kCLHeadingFilterNone; //continuous survey of the magnetometer calling delegate
		[_locationManager startUpdatingHeading];
	} else{ //this is very unlikely to be called ever
		NSLog(@"go die");
	}
}

/**
 * Receives heading changes
 */
-(void) locationManager:(CLLocationManager *) manager didUpdateHeading:(CLHeading *) newHeading{
	//NSLog(@"Heading: %@",newHeading);
	
	if(abs(180.0-abs(newHeading.y)) <= 40.0){
		NSLog(@"\n\n\nBUTTON PRESS!!!!\n\n\n");
	}
}

/**
 * Configures sensors and orientation matrix for perspective calculations
 */

-(void)configureSensors{
    _motionManager = [[CMMotionManager alloc]init];
    _motionManager.deviceMotionUpdateInterval = kMotionUpdateInterval;
	
    if(_motionManager.deviceMotionAvailable){ //sensor data available, they can use this feature (and app)
        [self addObserver:self forKeyPath:@"motionData" options:0 context:nil];
        [self addObserver:self forKeyPath:@"magnetometerData" options:0 context:nil];
        
        //update full range of motion data
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^void (CMDeviceMotion *data, NSError *error){
            if (error == nil){
                [self willChangeValueForKey:@"motionData"];
                _motionData=data;
                [self didChangeValueForKey:@"motionData"];
            }
            else{
                NSLog(@"Error reading accel data");
            }
        }];
    
       /* //update magnetometer data
        _motionManager.magnetometerUpdateInterval = kMotionUpdateInterval; // 1/10 sec update interval
        
        [_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *data, NSError *error) {
            if (error == nil){
                [self willChangeValueForKey:@"magnetometerData"];
                _magnetometerData = data;
                [self didChangeValueForKey:@"magnetometerData"];
            }
            else{
                NSLog(@"Error reading magneto data");
            }
        }];*/
    }
	
	// this seems like a good time to do this !??!?!?//!/1//111
	_cameraAngle = SCNVector3Zero;
}

-(void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context{
    if([keyPath isEqualToString:@"magnetometerData"]){ //warning: occasionally button will trigger twice for one direction--be sure to cope with this otherwise shit will fly.
        
    }
    if([keyPath isEqualToString:@"motionData"]){ //update the position
		float yaw = (_motionData.attitude.yaw - _motionDataLastVal.attitude.yaw);
		float roll = (_motionData.attitude.roll - _motionDataLastVal.attitude.roll );
		float pitch = (_motionData.attitude.pitch - _motionDataLastVal.attitude.pitch );
		
        float accelX = (_motionData.userAcceleration.x - _motionDataLastVal.userAcceleration.x );
        float accelY = (_motionData.userAcceleration.y - _motionDataLastVal.userAcceleration.y );
        float accelZ = (_motionData.userAcceleration.z - _motionDataLastVal.userAcceleration.z );
        
        float orientX = (_motionData.magneticField.field.x - _motionDataLastVal.magneticField.field.x);
        float orientY = (_motionData.magneticField.field.y - _motionDataLastVal.magneticField.field.y);
        float orientZ = (_motionData.magneticField.field.z - _motionDataLastVal.magneticField.field.z);

        if(_motionData.magneticField.field.z-_motionDataLastVal.magneticField.field.z>=200 && _motionDataLastVal.magneticField.field.z!=0){
            NSLog(@"Button Up");
        }
        if(_motionDataLastVal.magneticField.field.z-_motionData.magneticField.field.z>=200 && _motionDataLastVal.magneticField.field.z!=0){
            NSLog(@"Button Down");
        }

       printf("Attitude yaw: %.1f, roll %.1f, pitch %.1f \n accelX: %.1f Y: %.1f Z: %.1f \n orientX: %.01f Y: %.01f Z: %.01f\n",yaw,roll,pitch,accelX,accelY,accelZ,orientX,orientY,orientZ);
        
        _motionDataLastVal = _motionData;
		
		// quadrangulum !!!
		[self willChangeValueForKey:@"cameraAngle"];
		_cameraAngle.x += pitch;
		_cameraAngle.y += yaw;
		_cameraAngle.z += roll;
		
//		_cameraAngle = SCNVector3Make(pitch, yaw, roll);
		[self didChangeValueForKey:@"cameraAngle"];
    }
}

@end
