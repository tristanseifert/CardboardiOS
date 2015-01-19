//
//  SQUWatermelonLandRenderer.m
//
//  Cardboard for iOS — Demo Project #1
//  Slightly odd scene that demonstrates capabilities of graphics generation
//  capabilities through SceneKit and CardboardKit.
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import "SQUWatermelonLandRenderer.h"

#define kNodeNameCube @"kNodeNameCube"
#define kNodeNameSphere @"kNodeNameSphere"

@implementation SQUWatermelonLandRenderer

/**
 * initialises the nodes to be added to the scene
 */
- (void) addNodesToScene:(SCNScene *) scene {
	// create the camera
	/*_camera = [[SQUCameraCapturer alloc] init];
	[_camera requestPermission];
	[_camera beginCapture];*/
	
	// create a single cube
	CGFloat boxSide = 10.0;
	SCNBox *box = [SCNBox boxWithWidth:boxSide
								height:boxSide
								length:boxSide
						 chamferRadius:0.5];
	box.name = kNodeNameCube;
	
	SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
	boxNode.position = SCNVector3Make(0, 0, -30);
	
	// load the watermelon texture
	SCNMaterial *watermelonTexture = box.firstMaterial;
	watermelonTexture.diffuse.contents = [UIImage imageNamed:@"watermelon"];
	watermelonTexture.specular.contents = [UIColor colorWithWhite:0.05 alpha:1.0];
	watermelonTexture.shininess = 0.025;
	box.materials = @[watermelonTexture];
	
	[scene.rootNode addChildNode:boxNode];
	
	// add some animation to the cube
	CABasicAnimation *boxRotation =	[CABasicAnimation animationWithKeyPath:@"rotation"];
	boxRotation.fromValue =	[NSValue valueWithSCNVector4:SCNVector4Make(1, 0, 1, 0)];
	boxRotation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(1, 0, 1, 2*M_PI)];
	boxRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	boxRotation.repeatCount = INFINITY;
	boxRotation.duration = 2.0;
	
	[boxNode addAnimation:boxRotation forKey:@"RotateCubular"];
	
	
	// watermelon rotation
	CABasicAnimation *sphereRotation =	[CABasicAnimation animationWithKeyPath:@"rotation"];
	sphereRotation.fromValue =	[NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 1, 0)];
	sphereRotation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 1, 2*M_PI)];
	sphereRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	sphereRotation.repeatCount = INFINITY;
	sphereRotation.duration = M_PI;
	
	// watermelon surface
	SCNMaterial *watermelonSurface = [SCNMaterial material];
	watermelonSurface.diffuse.contents = [UIImage imageNamed:@"WatermelonSurface"];
	watermelonSurface.specular.contents = [UIColor colorWithWhite:0.05 alpha:1.0];
	watermelonSurface.shininess = 0.025;
	
	// create a sphere
	for(float i = 0; i < (2 * M_PI); i+= 0.35) {
		float xMultiplicand = cosf(i);
		float yMultiplicand = sinf(i);
		
		// create sphere
		SCNSphere *sphere = [SCNSphere sphereWithRadius:5];
	
		SCNNode *sphereNode = [SCNNode nodeWithGeometry:sphere];
		sphereNode.name = kNodeNameSphere;
		sphereNode.position = SCNVector3Make(50 * xMultiplicand, 10, 50 * yMultiplicand);
		sphere.materials = @[watermelonSurface];
	
		[scene.rootNode addChildNode:sphereNode];
		
		// add watermelon rotation to it
		[sphereNode addAnimation:sphereRotation forKey:@"RotateSphere"];
	}
	
	// create skybox
	scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
}

/**
 * Copies an image from the camera. Note: this is technically impossible (?!) thanks
 * to iOS's image processing capabilities at present.
 */
- (void) willRenderScene:(SCNScene *) scene {
	/*SCNNode *sphere = [scene.rootNode childNodeWithName:kNodeNameSphere recursively:YES];
	
	if(sphere) {
		SCNMaterial *watermelonTexture = sphere.geometry.firstMaterial;
		watermelonTexture.diffuse.contents = _camera.cameraLayer;
		sphere.geometry.materials = @[watermelonTexture];
	}*/
}

/**
 * Called when the scene is torn down.
 */
- (void) willTearDownScene:(SCNScene *) scene {
	
}

@end
