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
#import "Store.h"
#import "UIColor+StringRepresentation.h"
#import "StatisticsViewController.h"


static NSString * const cellReuseID = @"Cell"; //even though we aren't reusing cells here, the UICollectionView requires a non-nil reuseID

#define kDefaultColors @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor grayColor],[UIColor brownColor]]


@interface MainViewController ()
@property (nonatomic,strong) NSArray *allowedColors;
@end

@implementation MainViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self commonSetup];
    }
    
    return self;
}
-(instancetype)initWithItemSize:(CGSize)size
{
    return [self initWithItemSize:size allowedColors:nil];
}
-(instancetype)initWithItemSize:(CGSize)size allowedColors:(NSArray *)allowedColors
{
    self = [super initWithItemSize:size];
    if(self)
    {
        self.allowedColors = allowedColors;
        [self commonSetup];
    }
    
    return self;
}
-(void) commonSetup
{
    if(!self.allowedColors || self.allowedColors.count == 0)  //use default colors
        self.allowedColors = kDefaultColors;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseID];
    
    //setup a longpress gesture that will be used to launch the StatisticsViewController modally.
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasLongPressed:)];
    [self.collectionView addGestureRecognizer:longPress];
}

#pragma mark UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //create a generic cell and set it's background color to a new, random color
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    [self setRandomColorOnCell:cell animated:NO];
    
    return cell;
}
#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSString *colorString = [cell.backgroundColor stringRepresentation];
    
    //when a cell is selected, set it's background color to a new, random color
    [self setRandomColorOnCell:cell animated:YES];
    
    //
    [BackgroundContext performBlock:^{
        
        NSManagedObject *object = [Store retrieveObjectWithEntityName:ENTITY_STATISTIC withPredicate:[NSPredicate predicateWithFormat:@"color == %@", colorString] usingContext:BackgroundContext];
        
        if(object && [object isKindOfClass:[StatisticMO class]])
        {
            StatisticMO *statistic = (StatisticMO *)object;
            if(!statistic.color)
                statistic.color = colorString;
            statistic.count = @(statistic.count.intValue + 1);
        }
        else
            NSLog(@"%s: An unknown object was fetched. Expected %@ instance. Found: %@", __PRETTY_FUNCTION__, NSStringFromClass([StatisticMO class]), object);
        
        NSError *saveError = nil;
        [BackgroundContext save:&saveError];
        if(saveError)
            NSLog(@"%s: Error saving managedObjectContext: %@", __PRETTY_FUNCTION__, saveError);
    }];
}

#pragma mark UILongPressGetstureRecognzier
-(void) viewWasLongPressed: (UILongPressGestureRecognizer *) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        //present the StatistiveViewController modally
        StatisticsViewController *statisticsVC = [[StatisticsViewController alloc] init];
        UIModalTransitionStyle style = UIModalTransitionStyleFlipHorizontal;
        
        //use a different presentaiton style and transition for ipad
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            style = UIModalTransitionStyleCoverVertical;
            statisticsVC.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        statisticsVC.modalTransitionStyle = style;
        [self presentViewController:statisticsVC animated:YES completion:nil];
    }
}

#pragma mark Helper methods

/**
 Sets the background color of the provided cell to a new, random color. New in this sense means 'not the same as the previous background color'. The random color is chosen from the allowedColors array that was provided during the initialization methods.
 @param cell The UICollectionViewCell that wil have it's background set to a random color
 */
-(void) setRandomColorOnCell: (UICollectionViewCell *) cell animated: (BOOL) animated
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
    {
        void (^setColorBlock)() = ^() {
            cell.backgroundColor = color;
        };
        if(animated)
            [UIView animateWithDuration:.15 animations:setColorBlock];
        else
            setColorBlock();
    }
    else
        NSLog(@"%s: Error! Color provided was not of UIColor class: %@", __PRETTY_FUNCTION__, color);
}
@end
