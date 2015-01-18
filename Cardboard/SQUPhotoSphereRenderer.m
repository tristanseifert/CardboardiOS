//
//  SQUPhotoSphereRenderer.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUPhotoSphereRenderer.h"

@implementation SQUPhotoSphereRenderer

/**
 * When the controller is initialised, this method allows the renderer to add
 * its nodes.
 */
- (void) addNodesToScene:(SCNScene *) scene {
	// create spherical geometry
	_sphere = [SCNSphere sphereWithRadius:15.f];
	_sphere.firstMaterial.diffuse.contents = [UIColor redColor];
	_sphere.firstMaterial.cullMode = SCNCullFront;
	
	SCNNode *node = [SCNNode nodeWithGeometry:_sphere];
	node.position = SCNVector3Make(0, 0, -10);
	//[scene.rootNode addChildNode:node];
	
	// fork
	scene.background.contents = @[@"forkTower1", @"forkTower2", @"forkTower3", @"forkTower4", @"forkTower5", @"forkTower6"];
	
	// create cube
	/*CGFloat boxSide = 10.0;
	SCNBox *box = [SCNBox boxWithWidth:boxSide
								height:boxSide
								length:boxSide
						 chamferRadius:0];
	
	SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
	boxNode.position = SCNVector3Make(0, 0, -30);
	
	// load the watermelon texture
	SCNMaterial *watermelonTexture = box.firstMaterial;
	watermelonTexture.diffuse.contents = [UIImage imageNamed:@"watermelon"];
	watermelonTexture.specular.contents = [UIColor colorWithWhite:0.05 alpha:1.0];
	watermelonTexture.shininess = 0.025;
	box.materials = @[watermelonTexture];
	
	[scene.rootNode addChildNode:boxNode];*/
}

/**
 * Every frame, before the scene is rendered, this method is called. Any sort of
 * animations or modifications can do things here.
 */
- (void) willRenderScene:(SCNScene *) scene {
	
}

/**
 * Called right before the scene is torn down. Any cleanup can be done here.
 */
- (void) willTearDownScene:(SCNScene *) scene {
	
}

/**
 * Returns the URL of the COLLADA file for the source, if the scene should be
 * loaded from a file.
 */
/*- (NSURL *) colladaFile {
	return [[NSBundle mainBundle] URLForResource:@"sphere" withExtension:@"dae"];
}*/

@end
