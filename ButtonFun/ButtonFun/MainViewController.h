//
//  MainViewController.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
-(instancetype) initWithItemSize: (CGSize) size;
-(instancetype) initWithItemSize: (CGSize) size allowedColors: (NSArray *) allowedColors;
@property (nonatomic) CGSize itemSize;
@end
