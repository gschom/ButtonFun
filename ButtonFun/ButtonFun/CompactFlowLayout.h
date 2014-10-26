//
//  CompactFlowLayout.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * @class CompactFlowLayout
 * @description A UICollectionViewFlowLayout subclass that uniformly distributes extra space on the edges of it's collectionview. This results in a compact layout with equal padding on opposite sides of the collectionview. For example, if there are 8 pixels between the bottom row of the collectionview and it's bounds, this layout will absorb that space by placing 4 pixels above the first row and 4 pixels below the last row. While by default this layout uses 0 padding between adjacent rows or columns, the implementer can adjust these values using  minimumInteritemSpacing and minimumLineSpacing for custom layouts.
 */
@interface CompactFlowLayout : UICollectionViewFlowLayout

@end
