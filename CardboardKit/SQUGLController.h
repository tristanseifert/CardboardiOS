//
//  SQUGLController.h
//  CardboardKit
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface SQUGLController : UIViewController <SCNSceneRendererDelegate> {
	SCNScene *_scene;
	
	SCNView *_renderViewLeft;
	SCNView *_renderViewRight;
	
	SCNNode *_cam_l, *_cam_r;
	
	BOOL _initialised;
	BOOL _sceneInitialised;
}

@property (nonatomic, readonly) CGFloat oldBrightness;
@property (nonatomic, readwrite) CGFloat offset;

@property (nonatomic, readwrite, strong) id<SQURenderDelegate> renderisor;

- (id) initWithRenderer:(id<SQURenderDelegate>) renderer;

@end
