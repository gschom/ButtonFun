//
//  CommonViewController.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/26/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "CommonViewController.h"

@implementation CommonViewController

//by default, iPhone supports UIInterfaceOrientationMaskAllButUpsideDown. Override this to support all orientations as described in the spec.
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
