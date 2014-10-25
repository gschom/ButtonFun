//
//  MainViewController.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "MainViewController.h"
#import "NSLayoutConstraint+Helpers.h"


#define kDefaultColors @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor blackColor],[UIColor brownColor]]

static NSString * cellReuseID = @"Cell";
@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *allowedColors;
@property NSInteger numberItemsRequired;
@end

@implementation MainViewController

-(instancetype)initWithItemSize:(CGSize)size
{
    //use default colors
    return [self initWithItemSize:size allowedColors:kDefaultColors];
}
-(instancetype)initWithItemSize:(CGSize)size allowedColors:(NSArray *)allowedColors
{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if(self)
    {
        self.itemSize = size;
        self.allowedColors = allowedColors;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.itemSize;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:[NSLayoutConstraint constraintsForPinningViewToAllEdgesOfParent:self.collectionView]];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    self.collectionView.scrollEnabled = NO;
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSUInteger oldItemCount = self.numberItemsRequired;
    [self calculateNumberOfItemsNeededToFillScreen];
    if(oldItemCount != self.numberItemsRequired)
        [self.collectionView reloadData];
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    [self setRandomColorOnCell:cell];
    
    return cell;
}
#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self setRandomColorOnCell:cell];
}


#pragma mark Helper methods
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
-(void) calculateNumberOfItemsNeededToFillScreen
{
    //the number of items we need will be equal to how many cells of 'itemSize' can fit into our view's bounds.
    NSInteger numColumns = floorf(self.view.bounds.size.width / self.itemSize.height);
    NSInteger numRows = floorf(self.view.bounds.size.height / self.itemSize.height);
    self.numberItemsRequired = numColumns * numRows;
}


@end
