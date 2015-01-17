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
	
	// get device
	AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	_input = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
	NSAssert(!error, @"Error getting device input");
	
	// configure capture output as BGRA8888
	_output = [[AVCaptureVideoDataOutput alloc] init];
	[_output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
	
	NSDictionary *settings = @{(NSString *) kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
	[_output setVideoSettings:settings];
	
	// set up the session
	_session = [[AVCaptureSession alloc] init];
	[_session setSessionPreset:AVCaptureSessionPreset640x480];
	
	// add capture outputs and inputs
	if ([_session canAddInput:_input]) {
		[_session addInput:_input];
	} else {
		NSLog(@"Cannot add input");
	}
	
	if ([_session canAddOutput:_output]) {
		[_session addOutput:_output];
	} else {
		NSLog(@"Cannot add output");
	}
	
	// fix orientation
/*	AVCaptureConnection *conn = [_output connectionWithMediaType:AVMediaTypeVideo];
	[conn setVideoOrientation:AVCaptureVideoOrientationPortrait];*/
	
	// now, create the layer
	_cameraLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
	_cameraLayer.backgroundColor = [[UIColor blackColor] CGColor];
	_cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	_cameraLayer.frame = CGRectMake(0, 0, 256, 256);
	
	// done
	NSLog(@"Video input setup complete");
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

#pragma mark - Delegate
/**
 *
 */
- (void) captureOutput:(AVCaptureOutput *) captureOutput didOutputSampleBuffer:(CMSampleBufferRef) sampleBuffer fromConnection:(AVCaptureConnection *) connection {
	
}

@end
