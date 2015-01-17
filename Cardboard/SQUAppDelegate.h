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

@interface SQUAppDelegate : NSObject <UIApplicationDelegate> {
	
}

@property (nonatomic) UIWindow *window;
@property (nonatomic) SQUGLController *mainController;


@end
