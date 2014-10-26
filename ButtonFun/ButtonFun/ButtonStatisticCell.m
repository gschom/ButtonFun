//
//  ButtonStatisticCell.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "ButtonStatisticCell.h"
#import "NSLayoutConstraint+Helpers.h"
@interface ButtonStatisticCell ()
@property (nonatomic, strong, readwrite) UIView *colorView;
@property (nonatomic, strong, readwrite) UILabel *countLabel;
@end
@implementation ButtonStatisticCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        //create subviews and add constraints
        self.colorView = [[UIView alloc] init];
        self.colorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.colorView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.colorView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0
                                                                      constant:-4]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsForCenteringView:self.colorView alongAxisOfParent:UILayoutConstraintAxisVertical]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[colorView]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"colorView" : self.colorView}]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsForMatchingHeightAndWidthOfView:self.colorView]];
        
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.countLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[colorView]-32-[countLabel]|"
                                                                                options:NSLayoutFormatAlignAllCenterY
                                                                                metrics:nil
                                                                                   views:@{@"colorView": self.colorView, @"countLabel" : self.countLabel}]];
    }
    
    return self;
}
@end