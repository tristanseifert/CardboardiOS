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
	_sphere = [SCNSphere sphereWithRadius:200.f];
	_sphere.geodesic = YES;
	
	_sphere.firstMaterial.doubleSided = YES;
	_sphere.firstMaterial.diffuse.contents = [UIImage imageNamed:@"forkSphere"];
	_sphere.firstMaterial.diffuse.contentsTransform = SCNMatrix4Identity;
	_sphere.firstMaterial.cullMode = SCNCullFront;
	
	SCNNode *node = [SCNNode nodeWithGeometry:_sphere];
	node.position = SCNVector3Make(0, 0, 0);
	[scene.rootNode addChildNode:node];
}

/**
 * Sets the image to render.
 */
- (void) setImage:(UIImage *) image {
	_sphere.firstMaterial.diffuse.contents = image;
}

@end
