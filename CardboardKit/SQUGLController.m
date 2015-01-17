//
//  SQUGLController.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUCameraCapturer.h"

#import "SQUGLController.h"

/// TODO: These should be static enum define things
#define kNodeNameCameraLeft @"kCameraNameLeft"
#define kNodeNameCameraRight @"kNodeNameCameraRight"
#define kNodeNameCube @"kNodeNameCube"
#define kNodeNameSpotLight @"kNodeNameSpotLight"
#define kNodeNameSunLight @"kNodeNameSunLight"

@interface SQUGLController ()

- (void) initSceneKit;
- (void) initNodes;

@end

@implementation SQUGLController

/**
 * Initialiser
 */
- (id) init {
	if(self = [super initWithNibName:nil bundle:nil]) {
		_camera = [[SQUCameraCapturer alloc] init];
		
		_offset = 0.5;
	}
	
	return self;
}

/**
 * Status bar laid out for dark contents
 */
- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - Scene Kit
/**
 * Initialise SceneKit, though
 */
- (void) initSceneKit {
	// set up left view
	CGRect l = self.view.frame;
	l.size.width /= 2.f;
	
	_renderViewLeft = [[SCNView alloc] initWithFrame:l];
	_renderViewLeft.preferredFramesPerSecond = 60;
	_renderViewLeft.antialiasingMode = SCNAntialiasingModeNone;
	_renderViewLeft.backgroundColor = self.view.backgroundColor;
	_renderViewLeft.delegate = self;
	//_renderViewLeft.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
	//_renderViewLeft.allowsCameraControl = YES;
	
	// set up right view
	CGRect r = self.view.frame;
	r.size.width /= 2.f;
	r.origin.x = r.size.width;
	
	_renderViewRight = [[SCNView alloc] initWithFrame:r];
	_renderViewRight.preferredFramesPerSecond = 60;
	_renderViewRight.antialiasingMode = SCNAntialiasingModeNone;
	_renderViewRight.backgroundColor = self.view.backgroundColor;
	_renderViewRight.delegate = self;
	
	//_renderViewRight.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
	//_renderViewRight.allowsCameraControl = YES;
	
	// set up teh scene
	_scene = [SCNScene scene];
	
	_scene.fogStartDistance = 35.f;
	_scene.fogEndDistance = 50.f;
	
	[self initNodes];
	
	// set the scene
	_renderViewLeft.scene = _scene;
	_renderViewLeft.pointOfView = _cam_l;
	
	_renderViewRight.scene = _scene;
	_renderViewRight.pointOfView = _cam_r;
	
	// add them views
	[self.view addSubview:_renderViewLeft];
	[self.view addSubview:_renderViewRight];
}

/**
 * Initialises the main nodes and cameras.
 */
- (void) initNodes {
	// create left camera
	_cam_l = [SCNNode node];
	_cam_l.name = kNodeNameCameraLeft;
	_cam_l.camera = [SCNCamera camera];
	_cam_l.position = SCNVector3Make(-_offset, 0, 65);
	
	[_scene.rootNode addChildNode:_cam_l];
	
	// create right camera
	_cam_r = [SCNNode node];
	_cam_r.name = kNodeNameCameraRight;
	_cam_r.camera = [SCNCamera camera];
	_cam_r.position = SCNVector3Make(_offset, 0, 65);
	
	[_scene.rootNode addChildNode:_cam_r];
	
	// create a single cube
	CGFloat boxSide = 10.0;
	SCNBox *box = [SCNBox boxWithWidth:boxSide
								height:boxSide
								length:boxSide
						 chamferRadius:0];
	box.name = kNodeNameCube;
	
	SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
	boxNode.position = SCNVector3Make(0, 0, 0);
//	boxNode.transform = SCNMatrix4Rotate(boxNode.transform, 0, 0, 1, 0);
	
	[_scene.rootNode addChildNode:boxNode];
	
	CABasicAnimation *boxRotation =
	[CABasicAnimation animationWithKeyPath:@"transform"];
	boxRotation.fromValue =
	[NSValue valueWithSCNMatrix4:SCNMatrix4Rotate(boxNode.transform, 0, 1, 1, 0)];
	boxRotation.toValue =
	[NSValue valueWithSCNMatrix4:SCNMatrix4Rotate(boxNode.transform, M_PI, 1, 1, 0)];
	boxRotation.timingFunction =
	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	boxRotation.repeatCount = INFINITY;
	boxRotation.duration = 2.0;
	
	[boxNode addAnimation:boxRotation
				   forKey:@"RotateTheBox"];
	
	// A spotlight
	SCNLight *spotLight = [SCNLight light];
	spotLight.type = SCNLightTypeSpot;
	spotLight.color = [UIColor redColor];
	
	SCNNode *spotLightNode = [SCNNode node];
	spotLightNode.light = spotLight;
	spotLightNode.position = SCNVector3Make(0, 0, 0);
	spotLightNode.name = kNodeNameSpotLight;
	
	// Changing the color of the spotlight
	CAKeyframeAnimation *spotColor =
	[CAKeyframeAnimation animationWithKeyPath:@"color"];
	spotColor.values = @[(id)[UIColor redColor],
						 (id)[UIColor blueColor],
						 (id)[UIColor greenColor],
						 (id)[UIColor redColor]];
	spotColor.timingFunction =
	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	spotColor.repeatCount = INFINITY;
	spotColor.duration = 3.0;
	
	[spotLight addAnimation:spotColor
					 forKey:@"ChangeTheColorOfTheSpot"];
	
	[_cam_l addChildNode:spotLightNode];
	[_cam_r addChildNode:[spotLightNode copy]];
	
	// create a global sunlicht
	SCNLight *sunLight = [SCNLight light];
	sunLight.type = SCNLightTypeDirectional;
	sunLight.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.55 alpha:1.0];
	
	SCNNode *sunLightNode = [SCNNode node];
	sunLightNode.light = spotLight;
	sunLightNode.position = SCNVector3Make(30, 30, 30);
	sunLightNode.transform = SCNMatrix4Rotate(sunLightNode.transform, M_PI_2/4, 1, 1, 0);
	sunLightNode.name = kNodeNameSunLight;
	
	[_scene.rootNode addChildNode:sunLightNode];
}

#pragma mark - Scene Kit Delegate
- (void) renderer:(id <SCNSceneRenderer>) aRenderer willRenderScene:(SCNScene *) scene atTime:(NSTimeInterval) time {
	
}

- (void)renderer:(id <SCNSceneRenderer>) aRenderer didRenderScene:(SCNScene *) scene atTime:(NSTimeInterval) time {
	// update camera
	_cam_l.position = SCNVector3Make(-_offset, 0, 30);
	_cam_r.position = SCNVector3Make(_offset, 0, 30);	
}

#pragma mark - Properties
/**
 * Sets the eye offset.
 */
- (void) setOffset:(CGFloat) offset {
	_offset = fabs(offset);
}

#pragma mark - View Delegate
/**
 * View loaded plsss
 */
- (void) viewDidLoad {
    [super viewDidLoad];
	
	// background of view is black (for shadow/fog)
	self.view.backgroundColor = [UIColor blackColor];
	
	// init scene kit
	[self initSceneKit];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
