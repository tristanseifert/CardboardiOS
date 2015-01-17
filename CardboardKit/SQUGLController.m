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
#define kNodeNameAmbientLight @"kNodeNameAmbientLight"

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
		_offset = 0.5;
		_initialised = NO;
	}
	
	return self;
}

/**
 * Status bar laid out for dark contents
 */
- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

/**
 * View loaded plsss
 */
- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];
	
	if(!_initialised) {
		// initialise camera
		_camera = [[SQUCameraCapturer alloc] init];
		[_camera requestPermission];
		[_camera beginCapture];
		
		// initialise the rest of the UI
		// background of view is black (for shadow/fog)
		self.view.backgroundColor = [UIColor blackColor];
		
		// init scene kit
		[self initSceneKit];
		
		// view's BG is a grey for the divider
		self.view.backgroundColor = [UIColor darkGrayColor];
		
		//
		/*	_camera.cameraLayer.frame = CGRectMake(240, 15, 256, 256);
		 [self.view.layer addSublayer:_camera.cameraLayer];*/
		
		// done with initialisation
		_initialised = YES;
	}
	
	// save old brightness
	_oldBrightness = [UIScreen mainScreen].brightness;
	
	[UIScreen mainScreen].brightness = 0.3;
}
- (void) viewDidDisappear:(BOOL) animated {
	[super viewWillAppear:animated];
	[_camera endCapture];
	
	// set brightness
	[UIScreen mainScreen].brightness = _oldBrightness;
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Scene Kit
/**
 * Initialise SceneKit, though
 */
- (void) initSceneKit {
	// set up left view
	CGRect l = self.view.frame;
	l.size.width /= 2.f;
	l.size.width -= 1;
	
	_renderViewLeft = [[SCNView alloc] initWithFrame:l];
	_renderViewLeft.antialiasingMode = SCNAntialiasingModeNone;
	_renderViewLeft.backgroundColor = self.view.backgroundColor;
	_renderViewLeft.delegate = self;
	//_renderViewLeft.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
	//_renderViewLeft.allowsCameraControl = YES;
	
	// set up right view
	CGRect r = self.view.frame;
	r.size.width /= 2.f;
	r.size.width += 1;
	r.origin.x = r.size.width + 1;
	
	_renderViewRight = [[SCNView alloc] initWithFrame:r];
	_renderViewRight.antialiasingMode = _renderViewLeft.antialiasingMode;
	_renderViewRight.backgroundColor = _renderViewLeft.backgroundColor;
	_renderViewRight.delegate = _renderViewLeft.delegate;
	
	//_renderViewRight.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
	//_renderViewRight.allowsCameraControl = _renderViewLeft.allowsCameraControl;
	
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
	
	NSAssert(_camera.cameraLayer, @"Camera layer must be initialised, pls.");
	NSLog(@"camera materials before: %@", box.materials);

	SCNMaterial *cameraTexture = box.firstMaterial;
	cameraTexture.diffuse.contents = _camera.cameraLayer;
	
	cameraTexture.diffuse.contents = [UIImage imageNamed:@"watermelon"];
	cameraTexture.specular.contents = [UIColor colorWithWhite:0.1 alpha:1.0];
	box.materials = @[cameraTexture];
	
	SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
	boxNode.position = SCNVector3Make(0, 0, 0);
//	boxNode.transform = SCNMatrix4Rotate(boxNode.transform, 0, 0, 1, 0);
	
	NSLog(@"camera materials after: %@", box.materials);
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
				   forKey:@"RotateCubular"];
	
	// A spotlight
	SCNLight *spotLight = [SCNLight light];
	spotLight.type = SCNLightTypeSpot;
	spotLight.color = [UIColor whiteColor];
	
	SCNNode *spotLightNode = [SCNNode node];
	spotLightNode.light = spotLight;
	spotLightNode.position = SCNVector3Make(0, 0, 0);
	spotLightNode.name = kNodeNameSpotLight;
	
/*	// Changing the color of the spotlight
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
					 forKey:@"ChangeTheColorOfTheSpot"];*/
	
	[_cam_l addChildNode:spotLightNode];
	[_cam_r addChildNode:[spotLightNode copy]];
	
	// create a global sunlicht
	SCNLight *sunLight = [SCNLight light];
	sunLight.type = SCNLightTypeOmni;
	sunLight.color = [UIColor colorWithRed:1.0 green:1.0 blue:0.5 alpha:1.0];
	sunLight.attenuationStartDistance = 0.f;
	
	SCNNode *sunLightNode = [SCNNode node];
	sunLightNode.light = sunLight;
	sunLightNode.position = SCNVector3Make(0, 30, 0);
	sunLightNode.name = kNodeNameSunLight;
	[_scene.rootNode addChildNode:sunLightNode];
	
	// ambient light
	SCNLight *ambientLight = [SCNLight light];
	ambientLight.type = SCNLightTypeAmbient;
	ambientLight.color = [UIColor colorWithWhite:0.1 alpha:1.0];
	
	SCNNode *ambientLightNode = [SCNNode node];
	ambientLightNode.light = ambientLight;
	ambientLightNode.name = kNodeNameAmbientLight;
	[_scene.rootNode addChildNode:ambientLightNode];
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

@end
