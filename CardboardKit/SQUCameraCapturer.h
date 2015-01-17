//
//  SQUCameraCapturer.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SQUCameraCapturer : NSObject {
	AVCaptureSession *_session;
	
	AVCaptureVideoDataOutput *_output;
	dispatch_queue_t _videoQueue;
}

- (void) requestPermission;

- (void) beginCapture;
- (void) endCapture;

@property (nonatomic, readonly) CALayer *cameraLayer;

@end
