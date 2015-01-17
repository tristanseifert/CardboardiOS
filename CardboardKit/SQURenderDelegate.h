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
/**
 * When the controller is initialised, this method allows the renderer to add
 * its nodes.
 */
- (void) addNodesToScene:(SCNScene *) scene;

/**
 * Every frame, before the scene is rendered, this method is called. Any sort of
 * animations or modifications can do things here.
 */
- (void) willRenderScene:(SCNScene *) scene;

/**
 * Called right before the scene is torn down. Any cleanup can be done here.
 */
- (void) willTearDownScene:(SCNScene *) scene;

@end
