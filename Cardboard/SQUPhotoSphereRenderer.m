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
	_sphere = [SCNSphere sphereWithRadius:10.f];
	_sphere.firstMaterial.diffuse.contents = [UIColor redColor];
	
	SCNNode *node = [SCNNode nodeWithGeometry:_sphere];
	node.position = SCNVector3Make(0, 0, 0);
	[scene.rootNode addChildNode:node];
	
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

@end
