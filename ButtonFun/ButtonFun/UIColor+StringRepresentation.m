//
//  UIColor+StringRepresentation.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "UIColor+StringRepresentation.h"
#import <CoreImage/CoreImage.h>

@implementation UIColor (StringRepresentation)

//use CoreImage to convert between a UIColor and NSString
+(UIColor *)colorWithStringRepresentation:(NSString *)string
{
    return [UIColor colorWithCIColor:[CIColor colorWithString:string]];
}
-(NSString *)stringRepresentation
{
    return [[CIColor colorWithCGColor:[self CGColor]] stringRepresentation];
}
@end
