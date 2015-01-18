//
//  SQUFlugenRenderer.h
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CardboardKit.h"

@interface SQUFlugenRenderer : NSObject <SQURenderDelegate> {
    SCNScene *_scene;
}

@property (nonatomic, readwrite) UIViewController *rootVC;

- (void) doMyoInit;

@end
