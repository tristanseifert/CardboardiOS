//
//  main.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQUAppDelegate.h"

int main(int argc, char * argv[]) {
	@autoreleasepool {
		// Set up logger
		[DDLog addLogger:[DDASLLogger sharedInstance]];
		
		DDTTYLogger *ttyLogger = [[DDTTYLogger alloc] init];
		ttyLogger.colorsEnabled = YES;
		[DDLog addLogger:ttyLogger];
		
		DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
		fileLogger.rollingFrequency = 60 * 60 * 24 * 7; // weekly
		fileLogger.logFileManager.maximumNumberOfLogFiles = 8; // every two months
		[DDLog addLogger:fileLogger];
		
		
		// create app delegate
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([SQUAppDelegate class]));
	}
}
