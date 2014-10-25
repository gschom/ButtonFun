//
//  NSLayoutConstraint+Helpers.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "NSLayoutConstraint+Helpers.h"

@implementation NSLayoutConstraint (Helpers)
+(NSArray *)constraintsForPinningViewToAllEdgesOfParent:(UIView *)view
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObjectsFromArray:[self constraintsWithVisualFormat:@"V:|[view]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(view)]];
    [constraints addObjectsFromArray:[self constraintsWithVisualFormat:@"|[view]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(view)]];
    return constraints;
}
@end
