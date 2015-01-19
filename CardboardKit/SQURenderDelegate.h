//
//  SQURenderDelegate.h
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
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

@optional
/**
 * Every frame, before the scene is rendered, this method is called. Any sort of
 * animations or modifications can do things here.
 */
- (void) willRenderScene:(SCNScene *) scene;

/**
 * Called right before the scene is torn down. Any cleanup can be done here.
 */
- (void) willTearDownScene:(SCNScene *) scene;

/**
 * Returns the URL of the COLLADA file for the source, if the scene should be
 * loaded from a file.
 */
- (NSURL *) colladaFile;

@end
