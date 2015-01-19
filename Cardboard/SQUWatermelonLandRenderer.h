//
//  SQUWatermelonLandRenderer.h
//
//  Cardboard for iOS — Demo Project #1
//  Slightly odd scene that demonstrates capabilities of graphics generation
//  capabilities through SceneKit and CardboardKit.
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardboardKit.h"

@interface SQUWatermelonLandRenderer : NSObject <SQURenderDelegate> {
	SQUCameraCapturer *_camera;
}

@end
