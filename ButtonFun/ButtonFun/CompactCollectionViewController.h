//
//  CompactCollectionViewController.h
//  ButtonFun
//
//  Created by Greg Schommer on 10/26/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "CommonViewController.h"

/**
 * @class CompactCollectionViewController
 * @description A viewcontroller that owns and lays out a compact collectionView. See CompactFlowLayout for more information. By default, this instance is both the datasource and delegate of the collectionView. Therefore subclasses must override -collectionView:cellForItemAtIndexPath: and return a non-nil cell.
 */
@interface CompactCollectionViewController : CommonViewController <UICollectionViewDataSource, UICollectionViewDelegate>

/// the collectionview being used to lay out cells
@property (nonatomic, strong, readonly) UICollectionView *collectionView;


/// the size of each item in the grid. Setting this value triggers a relayout.
@property (nonatomic) CGSize itemSize;

/**
 Creates a grid that fills the screen (as much as possible) with items of size 'size'. If another initializer is used, a default itemSize of (40,40) is used.
 @param size The size that each item should be.
 @return A CompactViewController instance
 */
-(instancetype) initWithItemSize: (CGSize) size;

@end
