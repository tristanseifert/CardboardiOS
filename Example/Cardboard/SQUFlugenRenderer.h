//
//  SQUFlugenRenderer.h
//  Cardboard
//
//  Created by Tristan Seifert and Jake Glass on 1/17/15.
//  Copyright (c) 2015 Squee! Application Development. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardboardKit/CardboardKit.h"

@interface SQUFlugenRenderer : NSObject <SQURenderDelegate> {
    SCNScene *_scene;
}

@property (nonatomic, readwrite) UIViewController *rootVC;

@end
