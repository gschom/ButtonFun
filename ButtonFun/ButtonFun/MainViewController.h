//
//  MainViewController.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompactCollectionViewController.h"

@interface MainViewController : CompactCollectionViewController

//default colors are red, orange, yellow, green, blue, purple, gray, and brown

/**
 Creates a grid that fills the screen (as much as possible) with items of size 'size'. See CompactCollectionViewController
 @param size The size that each item should be.
 @param allowedColors An array of UIColor objects that are selected at random for each of the item's background. If nil or an empty array is provided, the default colors listed in MainViewController.h are used
 @return A MainViewController instance
 */
-(instancetype) initWithItemSize: (CGSize) size allowedColors: (NSArray *) allowedColors;
@end
