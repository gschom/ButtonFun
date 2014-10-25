//
//  MainViewController.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

/// the size of each item in the grid. Setting this value triggers a relayout.
@property (nonatomic) CGSize itemSize;

/**
 Creates a grid that fills the screen (as much as possible) with items of size 'size'. By default, each item is one of the following colors: red,orange,yellow,green,blue,purple,black,brownColor. To provide custom colors, see -initWithItemSize:allowedColors:.
 @param size The size that each item should be.
 @return A MainViewController instance
 */
-(instancetype) initWithItemSize: (CGSize) size;
/**
 Creates a grid that fills the screen (as much as possible) with items of size 'size'.
 @param size The size that each item should be.
 @param allowedColors An array of UIColor objects that are selected at random for each of the item's background. If nil or an empty array is provided, the default colors listed in -initWithItemSize: are used.
 @return A MainViewController instance
 */
-(instancetype) initWithItemSize: (CGSize) size allowedColors: (NSArray *) allowedColors;
@end
