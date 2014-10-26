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
    return [self constraintsForPinningView:view toEdgesOfParent:AllEdges];
}
+(NSArray *)constraintsForPinningView:(UIView *)view toEdgesOfParent:(Edges)edges
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    void (^addConstraintsForAxis)(UILayoutConstraintAxis) = ^(UILayoutConstraintAxis axis){
        char axisChar = axis == UILayoutConstraintAxisHorizontal ? 'H' : 'V';
        NSMutableString *mutableFormat = [NSMutableString stringWithFormat:@"%c:", axisChar];
        switch (axis) {
            case UILayoutConstraintAxisVertical:
                if(edges & TopEdge)
                {
                    [mutableFormat appendString:@"|"];
                }
                [mutableFormat appendString:@"[view]"];
                if(edges & BottomEdge)
                {
                    [mutableFormat appendString:@"|"];
                }
                break;
            case UILayoutConstraintAxisHorizontal:
                if(edges & LeadingEdge)
                {
                    [mutableFormat appendString:@"|"];
                }
                [mutableFormat appendString:@"[view]"];
                if(edges & TrailingEdge)
                {
                    [mutableFormat appendString:@"|"];
                }
                break;
                
            default:
                break;
        }
        
        [constraints addObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat:mutableFormat
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(view)]];
    };
    
    addConstraintsForAxis(UILayoutConstraintAxisVertical);
    addConstraintsForAxis(UILayoutConstraintAxisHorizontal);
    
    return constraints;
}

+(NSArray *)constraintsForMatchingHeightAndWidthOfView:(UIView *)view
{
    return @[[NSLayoutConstraint constraintWithItem:view
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:view
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:1.0
                                                         constant:0]];
}

+(NSArray *)constraintsForCenteringView:(UIView *)view alongAxisOfParent:(UILayoutConstraintAxis)axis
{
    NSLayoutAttribute attribute = axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeCenterX : NSLayoutAttributeCenterY;
    return @[[NSLayoutConstraint constraintWithItem:view
                                          attribute:attribute
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:view.superview
                                          attribute:attribute
                                         multiplier:1.0
                                           constant:0]];
}
@end
