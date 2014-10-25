//
//  MainViewController.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "MainViewController.h"
#import "NSLayoutConstraint+Helpers.h"
#import "CompactFlowLayout.h"

#define kDefaultColors @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor blackColor],[UIColor brownColor]]

static NSString * const cellReuseID = @"Cell"; //even though we aren't reusing cells here, the UICollectionView requires a non-nil reuseID

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *allowedColors;
@property NSInteger numberItemsRequired; //calulated when appropriate
@end

@implementation MainViewController

-(instancetype)initWithItemSize:(CGSize)size
{
    return [self initWithItemSize:size allowedColors:nil];
}
-(instancetype)initWithItemSize:(CGSize)size allowedColors:(NSArray *)allowedColors
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if(self)
    {
        self.itemSize = size;
        
        if(!allowedColors || allowedColors.count == 0) //use default colors
            allowedColors = kDefaultColors;
        self.allowedColors = allowedColors;
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
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //we don't need or want scrolling since the grid will fit in the screen's bounds
    self.collectionView.scrollEnabled = NO;
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSUInteger oldItemCount = self.numberItemsRequired;
    [self calculateNumberOfItemsNeededToFillScreen];
    //if the number of items required to fill the screen has changed, start from scratch
    if(oldItemCount != self.numberItemsRequired)
        [self.collectionView reloadData];
}
//by default, iPhone supports UIInterfaceOrientationMaskAllButUpsideDown. Override this to support all orientations as described in the spec.
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//when the itemSize has changed, we need to relayout the collectionView.
-(void)setItemSize:(CGSize)itemSize
{
    if(!CGSizeEqualToSize(itemSize, self.itemSize))
    {
        _itemSize = itemSize;
        if(self.collectionView.collectionViewLayout)
        {
            [self calculateNumberOfItemsNeededToFillScreen];
            ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = self.itemSize;
            [self.collectionView reloadData];
        }
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
    //create a generic cell and set it's background color to a new, random color
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    [self setRandomColorOnCell:cell];
    
    return cell;
}
#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //when a cell is selected, set it's background color to a new, random color
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self setRandomColorOnCell:cell];
}

#pragma mark Helper methods

/**
 Sets the background color of the provided cell to a new, random color. New in this sense means 'not the same as the previous background color'. The random color is chosen from the allowedColors array that was provided during the initialization methods.
 @param cell The UICollectionViewCell that wil have it's background set to a random color
 */
-(void) setRandomColorOnCell: (UICollectionViewCell *) cell
{
    UIColor * (^getRandomColor)() = ^UIColor *() {
        NSUInteger index = arc4random() % self.allowedColors.count;
        return self.allowedColors[index];
    };
    
    UIColor *color = getRandomColor();
    if(color)
    {
        //make sure we generate a 'new' color. 'new' means not the same as the previous color.
        while (color == cell.backgroundColor) {
            color = getRandomColor();
        }
    }
    if(color && [color isKindOfClass:[UIColor class]])
        cell.backgroundColor = color;
    else
        NSLog(@"%s: Error! Color provided was not of UIColor class: %@", __PRETTY_FUNCTION__, color);
}
/**
 Calculates the number of items that are required to fill up the screen. If there is any space left over that is too small to fit an item, that space will be absorbed by the layout.
 */
-(void) calculateNumberOfItemsNeededToFillScreen
{
    //the number of items we need will be equal to how many cells of 'itemSize' can fit into our view's bounds.
    NSInteger numColumns = floorf(self.view.bounds.size.width / self.itemSize.height);
    NSInteger numRows = floorf(self.view.bounds.size.height / self.itemSize.height);
    self.numberItemsRequired = numColumns * numRows;
}


@end
