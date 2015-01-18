//
//  SQUAppDelegate.m
//  Cardboard
//
//  Created by Tristan Seifert on 1/17/15.
//  Copyright (c) 2015 Tristan Seifert. All rights reserved.
//

#import "SQUGLController.h"
#import "SQUFlugenRenderer.h"
#import "SQUWatermelonLandRenderer.h"
#import "SQUPhotoSphereRenderer.h"

#import "SQUAppDelegate.h"

#import "CardboardKit.h"
#import <MyoKit/MyoKit.h>
#import <KVNProgress/KVNProgress.h>

@implementation SQUAppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    // initialise cardboard kit, pls
    [[SQUCardboardKit sharedInstance] configureSensors];
    [[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"buttonPress" options:0 context:NULL];
        [[SQUCardboardKit sharedInstance] addObserver:self forKeyPath:@"cameraAngle" options:0 context:NULL];
    
    // create main controller
    _mainController = [[SQUGLController alloc] initWithRenderer:_sphere];
    _flugen.rootVC = _mainController;
    
    // create window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
    _window.rootViewController = _mainController;
    [_window makeKeyAndVisible];


        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,64.0)];
        
        UIImage *img = [UIImage imageNamed:@"snowGlobe"];
        
        
        for (int i=0;i<6;i++){
            
            CGPoint point = CGPointMake(0,0);
            NSString *text = [NSString stringWithFormat:@"Option %i",i];
            UIFont *font = [UIFont boldSystemFontOfSize:12];
            UIGraphicsBeginImageContext(img.size);
            [img drawInRect:CGRectMake(0,0,img.size.width,img.size.height)];
            CGRect rect = CGRectMake(point.x, point.y, img.size.width, img.size.height);
            [[UIColor whiteColor] set];
            [text drawInRect:CGRectIntegral(rect) withFont:font];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIImageView *opt1 = [[UIImageView alloc]initWithImage:newImage];
            opt1.tag = i+10; //!!!!IMPORTANT!!!!!1
            
            [scrollView addSubview:opt1];
        }
    [self.window.rootViewController.view addSubview:scrollView];
	
	return YES;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"buttonPress"]){
        [self startSphere:_scrollLocation];
    }
    if([keyPath isEqualToString:@"cameraAngle"]){
        
    }
}
-(void)startSphere:(float)scrollLoc{
    // Set up KVNProgress
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    configuration.fullScreen = YES;
    [KVNProgress setConfiguration:configuration];
    
    // Initialse Myo library
    /*NSString *meep = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
     [[TLMHub sharedHub] setApplicationIdentifier:meep];*/
    
    // create demo controllers
    _watermelon = [[SQUWatermelonLandRenderer alloc] init];
    _flugen = [[SQUFlugenRenderer alloc] init];
    _sphere = [[SQUPhotoSphereRenderer alloc] init];
    
    // create main controller
    _mainController = [[SQUGLController alloc] initWithRenderer:_sphere];
    _flugen.rootVC = _mainController;
    
    // create window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:1];
    _window.rootViewController = _mainController;
    [_window makeKeyAndVisible];
    
    // Connect to Myo
    //[_flugen doMyoInit];
    
    
}

@end
