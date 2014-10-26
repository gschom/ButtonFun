//
//  ButtonStatisticCell.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @class ButtonStatisticCell
 * @description A simple UITableViewCell subclass that is used for showing statistics for each color of button.
 */
@interface ButtonStatisticCell : UITableViewCell

/// the subview used for showing the color of the button
@property (nonatomic, strong, readonly) UIView *colorView;

/// the label used for showing the frequency of pressed buttons with each color
@property (nonatomic, strong, readonly) UILabel *countLabel;
@end
