//
//  SQUCameraCapturer.h
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SQUCameraCapturer : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
	AVCaptureSession *_session;
	
	AVCaptureVideoDataOutput *_output;
	AVCaptureDeviceInput *_input;
}

- (void) requestPermission;

- (void) beginCapture;
- (void) endCapture;

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *cameraLayer;

@end
