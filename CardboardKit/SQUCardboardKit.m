//
//  SQUCardboardKit.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUCardboardKit.h"

static SQUCardboardKit *sharedInstance = nil;

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

@end
