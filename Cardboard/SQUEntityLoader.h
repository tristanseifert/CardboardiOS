//
//  SQUEntityLoader.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCNNode;
@interface SQUEntityLoader : NSObject

+ (instancetype) sharedInstance;

- (SCNNode *) nodeFromFile:(NSURL *) url;

@end
