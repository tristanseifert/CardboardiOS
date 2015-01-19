//
//  SQUEntityLoader.m
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import "SQUEntityLoader.h"

#import <SceneKit/SceneKit.h>

static SQUEntityLoader *sharedInstance = nil;

@implementation SQUEntityLoader

+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[SQUEntityLoader alloc] init];
	});
	
	return sharedInstance;
}

/**
 * Loads an entity from the thingie
 */
- (SCNNode *) nodeFromFile:(NSURL *) url {
	SCNSceneSource *source = [SCNSceneSource sceneSourceWithURL:url
														options:nil];
	NSAssert(source, @"Couldn't load source pls");
	
	NSArray *nodes = [source identifiersOfEntriesWithClass:[SCNNode class]];
	NSCAssert(nodes.count > 0, @"Could not load notes %@", url);
	
	// collect the nodes
	SCNNode *root = [SCNNode node];
	
	for(NSString *ident in nodes) {
		SCNNode *node = [source entryWithIdentifier:ident withClass:[SCNNode class]];
		[root addChildNode:node];
	}
	
	// status pls
	DDLogVerbose(@"nodes: %@", nodes);
	
	return root;
}

@end
