//
//  SQUCameraCapturer.m
//  Cardboard
//
//	Captures imagery real-time from the rear camera, and provides a CALayer on
//	to which this is rendered. This layer can then be used in SceneKit to be
//	rendered.
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUCameraCapturer.h"

@implementation SQUCameraCapturer

/**
 * Requests permission to get video from the camera.
 */
- (void) requestPermission {
	NSError *error = nil;
	
	// set up the session
	_session = [AVCaptureSession new];
	[_session setSessionPreset:AVCaptureSessionPreset640x480];
	
	// get the device
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	NSAssert(!error, @"Could not get input: %@", error);
	
	// add the device to the session
	if ([_session canAddInput:deviceInput]) {
		[_session addInput:deviceInput];
	}
	
	// create a video output
	_output = [AVCaptureVideoDataOutput new];
	
	NSDictionary *rgbOutputSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCMPixelFormat_32BGRA)};
	[_output setVideoSettings:rgbOutputSettings];
	[_output setAlwaysDiscardsLateVideoFrames:YES];
	
	// create a serial queue that guarantees the frames are delivered in order
	_videoQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
	//[_output setSampleBufferDelegate:self queue:_videoQueue];
	
	// add it
	if ([_session canAddOutput:_output]) {
		[_session addOutput:_output];
	}
	
	[[_output connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
	
	// now, create the layer
	_cameraLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
	_cameraLayer.backgroundColor = [[UIColor blackColor] CGColor];
	_cameraLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
}

/**
 * Begins capturing live video from the rear camera.
 */
- (void) beginCapture {
	[_session startRunning];
}

/**
 * Ends camera capture. Replaces the output video with a test image.
 */
- (void) endCapture {
	[_session stopRunning];
}

@end
