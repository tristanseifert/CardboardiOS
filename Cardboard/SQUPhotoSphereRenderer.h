//
//  SQUPhotoSphereRenderer.h
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardboardKit.h"

@interface SQUPhotoSphereRenderer : NSObject <SQURenderDelegate> {
	SCNSphere *_sphere;
	
	NSArray *_photos;
	NSUInteger _currentSphere;
}

- (void) setImage:(UIImage *) image;

@end
