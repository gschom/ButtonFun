//
//  UIColor+StringRepresentation.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * @category UIColor (StringRepresentation)
 * @description A simple category to turn a UIColor into a string representation and vice versa.
 */
@interface UIColor (StringRepresentation)
/**
 Creates a UIColor object as defined by the provided string. This is the inverse of -stringRepresentation.
 @param string The string representation of the UIColor object;
 @return The UIColor represented by the string.
 */
+(UIColor *) colorWithStringRepresentation: (NSString *) string;

/**
 Returns the string representation of the UIColor instance. This is the inverse of +colorWithStringRepresentation:.
 @return The NSString representation of the UIColor instance the method was invoked on.
 */
-(NSString *) stringRepresentation;
@end
