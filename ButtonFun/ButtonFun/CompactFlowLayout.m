//
//  CompactFlowLayout.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "CompactFlowLayout.h"

@implementation CompactFlowLayout

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        //by default we don't want any spacing between our items
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    
    return self;
}

-(CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}

/*
 This method is responsible for distributing any extra space. 2 iterations over the layout attributes are needed. In the first loop we determine the smallest extra space along both the y and x axis. We need the smallest extra space among each row/column so that we don't push any items outside of the bounds of the collectionview. This also allows the layout to absorb extra space if a dynamic item size is used. In the second loop, we adjust the origins of the attributes such that any extra space is uniformly distributed on the edges of the collectionView.
 */
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributeList = [[super layoutAttributesForElementsInRect:rect] copy];
    
    NSNumber *extraXSpaceNumber = nil;
    NSNumber *extraYSpaceNumber = nil;
    for(int i = 0; i < attributeList.count; i++)
    {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributeList[i];
        UICollectionViewLayoutAttributes *previousLayoutAttributes = i == 0 ? nil : attributeList[i - 1];
        NSInteger trailingXOfPrevious = CGRectGetMaxX(previousLayoutAttributes.frame);
        
        //kiss horizontal items exactly up to one another (so that the min and max size between then is 0). UICollectionView seems to already do this for vertical items without any changes.
        if(trailingXOfPrevious + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = trailingXOfPrevious;
            currentLayoutAttributes.frame = frame;
        }
        else
        {
            //this is an element at the beginning of a new row. That means the previous element (if it exists) is the end of a row.
            if(previousLayoutAttributes)
            {
                CGFloat extraXForPreviousRow = self.collectionViewContentSize.width - CGRectGetMaxX(previousLayoutAttributes.frame);
                extraXSpaceNumber = @(!extraXSpaceNumber ? extraXForPreviousRow :  MIN(extraXSpaceNumber.floatValue, extraXForPreviousRow));
            }
        }
        NSInteger bottomYOfPrevious = CGRectGetMaxY(previousLayoutAttributes.frame);
        if(!(bottomYOfPrevious + currentLayoutAttributes.frame.size.height < self.collectionViewContentSize.height))
        {
            //this is an element at the top of a new column. That means the previous element (if it exists) is the end of a column.
            if(previousLayoutAttributes)
            {
                CGFloat extraYForPreviousColumn = self.collectionViewContentSize.height - CGRectGetMaxY(previousLayoutAttributes.frame);
                extraYSpaceNumber = @(!extraYSpaceNumber ? extraYForPreviousColumn :  MIN(extraYSpaceNumber.floatValue, extraYForPreviousColumn));
            }
        }
    }
    
    //block that will update the origins of all UICollectionViewLayoutAttributes along the provided axis
    void (^updateFramesForAxis)(UILayoutConstraintAxis) = ^(UILayoutConstraintAxis axis) {
        
        for (UICollectionViewLayoutAttributes *attributes in attributeList)
        {
            CGRect frame = attributes.frame;
            if(axis == UILayoutConstraintAxisHorizontal)
                frame = CGRectMake(frame.origin.x + floorf(extraXSpaceNumber.floatValue/2), frame.origin.y, frame.size.width, frame.size.height);
            else
                frame = CGRectMake(frame.origin.x, frame.origin.y + floorf(extraYSpaceNumber.floatValue/2), frame.size.width, frame.size.height);
            
            attributes.frame = frame;
        }
    };
    
    
    //do we need to adjust the X or Y origins to evenly distribute any space?
    
    if(extraXSpaceNumber.integerValue > 0)
        updateFramesForAxis(UILayoutConstraintAxisHorizontal);
    
    if(extraYSpaceNumber.integerValue > 0)
        updateFramesForAxis(UILayoutConstraintAxisVertical);
    
    return attributeList;
}

@end
