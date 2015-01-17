//
//  SQUCardboardKit.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface SQUCardboardKit : NSObject {
}


+ (instancetype) sharedInstance;

- (void) configureSensors;

@end
