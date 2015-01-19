//
//  SQUFlugenRenderer.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUEntityLoader.h"
#import "SQUFlugenRenderer.h"

#import <MyoKit/MyoKit.h>
#import <KVNProgress/KVNProgress.h>

@interface SQUFlugenRenderer ()

@property (strong, nonatomic) TLMPose *currentPose;

@property NSString *typeOfPlane; //can be @"F-14" or @""

@end

@implementation SQUFlugenRenderer

/**
 * Initialiser
 */
- (id) init {
	if(self = [super init]) {
		
	}
	
	return self;
}

#pragma mark - Rendering
/**
 * When the controller is initialised, this method allows the renderer to add
 * its nodes.
 */
- (void) addNodesToScene:(SCNScene *) scene {    
	// create skybox
	//scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
/*
	// asdjasklfjakls;fdas
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"f-14-super-tomcat" withExtension:@"dae"];
	SCNNode *n = [[SQUEntityLoader sharedInstance] nodeFromFile:url];
	
	DDLogVerbose(@"%@", n);
	
	[scene.rootNode addChildNode:n];*/
    // create spherical geometry
    SCNSphere *_sphere = [SCNSphere sphereWithRadius:5.0];
    _sphere.firstMaterial.diffuse.contents = [UIColor redColor];
    _sphere.firstMaterial.cullMode = SCNCullFront;
    
    SCNNode *node = [SCNNode nodeWithGeometry:_sphere];
    node.position = SCNVector3Make(0, 0, -10);
    [scene.rootNode addChildNode:node];
    
    //init some key code for registering buttonPress
    [[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"cameraAngle" options:0 context:NULL];
    [[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"buttonPress" options:0 context:NULL];
    
    //NSLog(@"cameraAngle %f",[SQUCardboardKit sharedInstance].cameraAngle.x);
    //initialise ourself as a physics body
    
    [scene.rootNode setPhysicsBody:[SCNPhysicsBody dynamicBody]];
    
    scene.rootNode.physicsBody.mass = 100.0; //100kg
    scene.rootNode.physicsBody.type = SCNPhysicsBodyTypeDynamic;
    scene.rootNode.physicsBody.physicsShape = [SCNPhysicsShape shapeWithGeometry:[SCNSphere sphereWithRadius:1.0] options:nil];
    scene.rootNode.physicsBody.collisionBitMask = SCNPhysicsCollisionCategoryDefault;
    scene.rootNode.physicsBody.categoryBitMask = SCNPhysicsCollisionCategoryDefault;

    //GRAVITY! dagnabbit
    //[scene.rootNode.physicsBody applyForce:SCNVector3Make(0, 9.8, 0) impulse:NO];
    
    //SKYBOXXX
    scene.background.contents = @[@"skybox_back", @"skybox_front", @"skybox_top", @"skybox_bottom", @"skybox_right", @"skybox_left"];
}

/**
 * Every frame, before the scene is rendered, this method is called. Any sort of
 * animations or modifications can do things here.
 */
- (void) willRenderScene:(SCNScene *) scene {
    _scene = scene;
}

/**
 * Called right before the scene is torn down. Any cleanup can be done here.
 */
- (void) willTearDownScene:(SCNScene *) scene {
	
}

#pragma mark - Flying Physics
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"buttonPress"]){
        [self accelerateAtAngle:[SQUCardboardKit sharedInstance].cameraAngle];
    }
}
-(void)accelerateAtAngle:(SCNVector3)angle{
    NSLog(@"vectors for speedy: %f %f %f",angle.x, angle.y, angle.z);
    
    [_scene.rootNode.physicsBody applyForce:SCNVector3Make(1000*angle.x, 1000*angle.y, 1000*angle.z) impulse:NO];
    //[_scene.rootNode.physicsBody setVelocity:SCNVector3Make(10*angle.x, 10*angle.y, 10*angle.z)];
}

@end