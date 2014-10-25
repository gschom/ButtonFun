//
//  NSLayoutConstraint+Helpers.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Helpers)
/**
 Creates constraints for pinning all edges of the provided view to his parent.
 @param view The view who should be pinned to his parent.
 @return An array of constraints.
 */
+(NSArray *) constraintsForPinningViewToAllEdgesOfParent: (UIView *) view;
@end
