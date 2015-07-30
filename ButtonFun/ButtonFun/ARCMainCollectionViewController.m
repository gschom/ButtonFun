//
//  ARCMainCollectionViewController.m
//  ButtonFun
//
//  Created by Antonio Carella on 7/30/15.
//  Copyright (c) 2015 SuperflousJazzHands. All rights reserved.
//

#import "ARCMainCollectionViewController.h"

#define ARC4RANDOM_MAX 0x10000000

static NSString * const reuseIdentifier = @"squareCell";

@interface ARCMainCollectionViewController()

@property NSInteger padding;
@property NSInteger squareWidth;
@property NSInteger squareHeight;

@end

@implementation ARCMainCollectionViewController

-(void)viewDidLoad{
    
    self.padding = 10;
    self.squareWidth = 40;
    self.squareHeight = 40;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

#pragma mark - UICollectionView Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self numberOfItems];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1 ;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    [cell setBackgroundColor:[self randomColor]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UIColor *currentColor = cell.backgroundColor;
    UIColor *newColor = [self randomColor];
    
    // make sure the new color is not the one the cell already has
    while (newColor == currentColor) {
        newColor = [self randomColor];
    }
    
    [cell setBackgroundColor: newColor];
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.squareWidth, self.squareHeight);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.padding, self.padding, self.padding, self.padding);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration: (NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
}

#pragma mark utility methods

-(NSInteger)numberOfItems{
    
    CGFloat width = self.view.bounds.size.width;
    
    NSInteger columns = width / (self.squareWidth + self.padding);
    
    CGFloat height = self.view.bounds.size.height;
    
    NSInteger rows = height / (self.squareHeight + self.padding);
    
    return columns * rows;
}

-(UIColor *)randomColor{
    
    srand48(arc4random());
    
    CGFloat randomRed = drand48();
    CGFloat randomGreen = drand48();
    CGFloat randomBlue = drand48();
    
    return [UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.0];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
