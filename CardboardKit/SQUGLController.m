//
//  SQUGLController.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUCameraCapturer.h"
#import "SQUCardboardKit.h"

#import "SQUGLController.h"

/// TODO: These should be static enum define things
#define kNodeNameCameraLeft @"kNodeNameCameraLeft"
#define kNodeNameCameraRight @"kNodeNameCameraRight"
#define kNodeNameSpotLight @"kNodeNameSpotLight"
#define kNodeNameSunLight @"kNodeNameSunLight"
#define kNodeNameAmbientLight @"kNodeNameAmbientLight"

@interface SQUGLController ()

- (void) initSceneKit;
- (void) initNodes;

- (void) updateCameraPositon:(SCNVector3) angles;

@end

@implementation SQUGLController

/**
 * spheren sphere cube initialiser
 */
- (id) initWithRenderer:(id<SQURenderDelegate>) renderer {
	if(self = [super initWithNibName:nil bundle:nil]) {
		_renderisor = renderer;
		
		_offset = 0.2;
		
		_initialised = NO;
		_sceneInitialised = NO;
		
		[[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"cameraAngle" options:0 context:NULL];
	}
	
	return self;
}

/**
 * Removes observers
 */
- (void) dealloc {
	// tear down renderer
	[_renderisor willTearDownScene:_scene];
	
	// remove KVO
	@try {
		[[SQUCardboardKit sharedInstance] removeObserver:self forKeyPath:@"cameraAngle"];
	}
	@catch (__unused NSException *exception) {
		
	}
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
		// initialise the rest of the UI
		// background of view is black (for shadow/fog)
		self.view.backgroundColor = [UIColor blackColor];
		
		// init scene kit
		[self initSceneKit];
		
		// view's BG is a grey for the divider
		self.view.backgroundColor = [UIColor darkGrayColor];
		
		// done with initialisation
		_initialised = YES;
	}
	
	// save old brightness
	_oldBrightness = [UIScreen mainScreen].brightness;
	
	[UIScreen mainScreen].brightness = 0.3;
}
- (void) viewDidDisappear:(BOOL) animated {
	[super viewWillAppear:animated];
	
	// set brightness
	[UIScreen mainScreen].brightness = _oldBrightness;
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
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
	_renderViewLeft.preferredFramesPerSecond = 60;
	_renderViewLeft.antialiasingMode = SCNAntialiasingModeMultisampling2X;
	
	//_renderViewLeft.backgroundColor = [UIColor yellowColor];
	
	_renderViewLeft.delegate = self;
	_renderViewLeft.showsStatistics = YES;
	
	//_renderViewLeft.allowsCameraControl = YES;
	
	// set up right view
	CGRect r = self.view.frame;
	r.size.width /= 2.f;
	r.size.width += 1;
	r.origin.x = r.size.width + 1;
	
	_renderViewRight = [[SCNView alloc] initWithFrame:r];
	_renderViewRight.preferredFramesPerSecond = _renderViewLeft.preferredFramesPerSecond;
	_renderViewRight.antialiasingMode = _renderViewLeft.antialiasingMode;
	
	_renderViewRight.backgroundColor = _renderViewLeft.backgroundColor;
	
	//_renderViewRight.delegate = _renderViewLeft.delegate;
	_renderViewRight.showsStatistics = YES;
	
	// set up teh scene
	_scene = [SCNScene scene];
	
/*	_scene.fogStartDistance = 15.f;
	_scene.fogEndDistance = 50.f;*/
	
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
	_cam_l.camera.focalSize = 15.f;
	_cam_l.camera.aperture = (1/6.f);
	_cam_l.position = SCNVector3Make(-_offset, 0, 0);
	
	[_scene.rootNode addChildNode:_cam_l];
	
	// create right camera
	_cam_r = [SCNNode node];
	_cam_r.name = kNodeNameCameraRight;
	_cam_r.camera = [SCNCamera camera];
	_cam_r.camera.focalSize = 15.f;
	_cam_r.camera.aperture = (1/6.f);
	_cam_r.position = SCNVector3Make(_offset, 0, 0);
	
	[_scene.rootNode addChildNode:_cam_r];
	
	// A spotlight
	SCNLight *spotLight = [SCNLight light];
	spotLight.type = SCNLightTypeSpot;
	spotLight.color = [UIColor colorWithWhite:0.25 alpha:0.25];
	
	SCNNode *spotLightNode = [SCNNode node];
	spotLightNode.light = spotLight;
	spotLightNode.position = SCNVector3Make(0, 0, 0);
	spotLightNode.name = kNodeNameSpotLight;
	
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
	
	// call the renderer
	[_renderisor addNodesToScene:_scene];
	_sceneInitialised = YES;
}

#pragma mark - Scene Kit Delegate
/**
 * Something is about to be modified
 */
- (void) renderer:(id <SCNSceneRenderer>) aRenderer willRenderScene:(SCNScene *) scene atTime:(NSTimeInterval) time {
	if(aRenderer == _renderViewLeft && _sceneInitialised) {
		[_renderisor willRenderScene:_scene];
	}
}

/**
 * Scene was rendered
 */
- (void)renderer:(id <SCNSceneRenderer>) aRenderer didRenderScene:(SCNScene *) scene atTime:(NSTimeInterval) time {
	// update camera
	_cam_l.position = SCNVector3Make(-_offset, 0, 0);
	_cam_r.position = SCNVector3Make(_offset, 0, 0);
}

/**
 * KVO
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"cameraAngle"]) {
		[self updateCameraPositon:[SQUCardboardKit sharedInstance].cameraAngle];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

/**
 * Rotates the camera to be squelchy again.
 */
- (void) updateCameraPositon:(SCNVector3) angles {
	// camera things
	/*_cam_l.position = SCNVector3Make(-_offset, 0, 30);
	_cam_r.position = SCNVector3Make(_offset, 0, 30);*/
    _cam_l.position = SCNVector3Make(-_offset, 0, 0);
    _cam_r.position = SCNVector3Make(_offset, 0, 0);
	
	// set rotations
/*	_cam_l.transform = SCNMatrix4Translate(SCNMatrix4Identity, -_offset, 0, 30);
	_cam_l.transform = SCNMatrix4Rotate(_cam_l.transform, angles.x, 1, 0, 0);
	_cam_l.transform = SCNMatrix4Rotate(_cam_l.transform, angles.y, 0, 1, 0);
	_cam_l.transform = SCNMatrix4Rotate(_cam_l.transform, angles.z, 0, 0, 1);
	
	_cam_r.transform = SCNMatrix4Translate(SCNMatrix4Identity, _offset, 0, 30);
	_cam_r.transform = SCNMatrix4Rotate(_cam_r.transform, angles.x, 1, 0, 0);
	_cam_r.transform = SCNMatrix4Rotate(_cam_r.transform, angles.y, 0, 1, 0);
	_cam_r.transform = SCNMatrix4Rotate(_cam_r.transform, angles.z, 0, 0, 1);*/
	
	_cam_l.eulerAngles = angles;
	_cam_r.eulerAngles = angles;
}

#pragma mark - Properties
/**
 * Sets the eye offset.
 */
- (void) setOffset:(CGFloat) offset {
	_offset = fabs(offset);
}

@end
