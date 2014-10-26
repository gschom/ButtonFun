//
//  NSLayoutConstraint+Helpers.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, Edges)
{
    TopEdge      = 1 << 0,
    BottomEdge   = 1 << 1,
    LeadingEdge  = 1 << 2,
    TrailingEdge = 1 << 3,
    AllEdges     = TopEdge | BottomEdge | LeadingEdge | TrailingEdge
};

/**
 * @category NSLayoutConstraint (Helpers)
 * @description A simple NSLayoutConstraint category that provides convience methods for common layout tasks
 */
@interface NSLayoutConstraint (Helpers)

/**
 Creates constraints for pinning all edges of the provided view to his parent.
 @param view The view who should be pinned to his parent.
 @return An array of constraints.
 */
+(NSArray *) constraintsForPinningViewToAllEdgesOfParent: (UIView *) view;

/**
 Creates constraints for pinning the specified edges of the provided view to his parent.
 @param view The view who should be pinned to his parent.
 @param edges The superView edges that the view should be pinned to. Multiple edges can be OR'd together.
 @return An array of constraints.
 */
+(NSArray *) constraintsForPinningView: (UIView *) view toEdgesOfParent: (Edges) edges;

/**
 Creates constraints that constrain the height and width of the provided view to be equal.
 @param view The view who should have an equal height and width.
 @return An array of constraints.
 */
+(NSArray *) constraintsForMatchingHeightAndWidthOfView: (UIView *) view;

/**
 Creates constraints that center the provided view along the his superView on the provided axis.
 @param view The view who should be centered with his parent along the axis.
 @return An array of constraints.
 */
+(NSArray *) constraintsForCenteringView: (UIView *) view alongAxisOfParent: (UILayoutConstraintAxis) axis;

@end
