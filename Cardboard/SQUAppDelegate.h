//
//  SQUAppDelegate.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
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
    
    UIScrollView *scrollView;
}

@property (nonatomic) UIWindow *window;
@property (nonatomic) SQUGLController *mainController;
@property BOOL newLaunch;
@property float scrollLocation;

-(void)touchedImageWithTag:(int)tag;

@end
