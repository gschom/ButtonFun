//
//  CompactCollectionViewController.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/26/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "CompactCollectionViewController.h"
#import "CompactFlowLayout.h"
#import "NSLayoutConstraint+Helpers.h"

#define kDefaultItemSize CGSizeMake(40,40)
@interface CompactCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property NSInteger numberItemsRequired; //calulated when appropriate
@end

@implementation CompactCollectionViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.itemSize = kDefaultItemSize;
    }
    
    return self;
}
-(instancetype)initWithItemSize:(CGSize)size
{
    self = [self initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if(self)
    {
        self.itemSize = size;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CompactFlowLayout *flowLayout = [[CompactFlowLayout alloc] init];
    flowLayout.itemSize = self.itemSize;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    //autolayout constraints. We want the collectionview to be pinned to his superview on all edges.
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:[NSLayoutConstraint constraintsForPinningViewToAllEdgesOfParent:self.collectionView]];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //we don't need or want scrolling since the grid will fit in the screen's bounds
    self.collectionView.scrollEnabled = NO;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self relayoutItemsToFitSizeIfNeeded:self.view.bounds.size];
}

-(void)dealloc
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

//when the itemSize has changed, we need to relayout the collectionView.
-(void)setItemSize:(CGSize)itemSize
{
    if(!CGSizeEqualToSize(itemSize, self.itemSize))
    {
        _itemSize = itemSize;
        if(self.collectionView.collectionViewLayout)
            [self relayoutItemsToFitSizeIfNeeded:self.view.bounds.size];
    }
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberItemsRequired;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //subclasses must provide. Since this implementation does nothing, subclasses are not required to call super.
    return nil;
}

#pragma mark Helper methods
/**
 Calculates the number of items that are required to fill up the provided size and lays them out if needed. If there is any space left over that is too small to fit an item, that space will be absorbed by the layout.
 */
-(void) relayoutItemsToFitSizeIfNeeded: (CGSize) size
{
    
    CompactFlowLayout *flowLayout = (CompactFlowLayout *)self.collectionView.collectionViewLayout;
    
    //first check to see if we need to adjust the number of items.
    NSUInteger oldItemCount = self.numberItemsRequired;
    
    //the number of items we need will be equal to how many cells of 'itemSize' + 'spacing' can fit into our view's bounds.
    //since items in the first and last rows and columns do not have adjacent items on every side, we need to adjust our calculation to take advantage of this space (see below where we are adding 1 minimumInteritemSpacing and 1 minimumLineSpacing)
    NSInteger numColumns = floorf((size.width + flowLayout.minimumInteritemSpacing) / (self.itemSize.width + flowLayout.minimumInteritemSpacing));
    NSInteger numRows = floorf((size.height + flowLayout.minimumLineSpacing) / (self.itemSize.height + flowLayout.minimumLineSpacing));
    self.numberItemsRequired = numColumns * numRows;
    
    if(oldItemCount != self.numberItemsRequired)
    {
        //we need to relayout
        [self.collectionView reloadData];
    }
}
@end
