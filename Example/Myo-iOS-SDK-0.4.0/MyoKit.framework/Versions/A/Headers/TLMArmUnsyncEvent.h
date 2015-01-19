//
//  TLMArmUnsyncEvent.h
//  MyoKit
//
//  Copyright (C) 2014 Thalmic Labs Inc.
//  Distributed under the Myo SDK license agreement. See LICENSE.txt.
//

#import <Foundation/Foundation.h>

@class TLMMyo;

@interface TLMArmUnsyncEvent : NSObject <NSCopying>

/**
 The TLMMyo that is moved or removed from the arm.
 */
@property (nonatomic, weak, readonly) TLMMyo *myo;

/**
 The timestamp associated with the arm unsync event.
 */
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
