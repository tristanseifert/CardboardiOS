//
//  SQUAppDelegate.h
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class SQUGLController;
@class SQUWatermelonLandRenderer, SQUFlugenRenderer, SQUPhotoSphereRenderer;

@interface SQUAppDelegate : NSObject <UIApplicationDelegate> {
	SQUWatermelonLandRenderer *_watermelon;
	SQUFlugenRenderer *_flugen;
	SQUPhotoSphereRenderer *_sphere;
}

@property (nonatomic) UIWindow *window;
@property (nonatomic) SQUGLController *mainController;


@end
