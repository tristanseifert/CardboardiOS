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
	//_sphere.geodesic = YES;
	
	_sphere.firstMaterial.doubleSided = YES;
	_sphere.firstMaterial.diffuse.contents = [UIColor yellowColor];
//	_sphere.firstMaterial.diffuse.contentsTransform = SCNMatrix4MakeTranslation(0, 0, 0);
	_sphere.firstMaterial.cullMode = SCNCullFront;
	
	SCNNode *node = [SCNNode nodeWithGeometry:_sphere];
	node.position = SCNVector3Make(0, 0, 0);
	node.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
	
	[scene.rootNode addChildNode:node];
	
	// loaden pls
	NSString *file = [[NSBundle mainBundle] pathForResource:@"PhotoSpheres" ofType:@"plist"];
	_photos = [NSArray arrayWithContentsOfFile:file];
	
	// load the spheren
	_currentSphere = (NSUInteger) -1;
	[self nextPhotoSphere];
	
	// register for notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed:) name:kSQUCardboardKitButtonPressedNotification object:nil];
}

/**
 * Sets the image to render.
 */
- (void) setImage:(UIImage *) image {
	_sphere.firstMaterial.diffuse.contents = image;
}

/**
 * Goes to the next PhotoSphere.
 */
- (void) nextPhotoSphere {
	_currentSphere++;
	if(_currentSphere >= _photos.count) {
		_currentSphere = 0;
	}
	
	// load imagen
	UIImage *imagen = [UIImage imageNamed:_photos[_currentSphere]];
	[self setImage:imagen];
}

/**
 * Notification for BUTTon
 */
- (void) buttonPressed:(NSNotification *) n {
	[self nextPhotoSphere];
}

@end
