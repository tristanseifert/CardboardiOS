//
//  SQURenderDelegate.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCNScene;

@protocol SQURenderDelegate <NSObject>

@required
- (void) addNodesToScene:(SCNScene *) scene;

- (void) willRenderScene:(SCNScene *) scene;

@end
