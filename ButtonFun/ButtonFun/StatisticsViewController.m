//
//  StatisticsViewController.m
//  ButtonFun
//
//  Created by Greg Schommer on 10/25/14.
//  Copyright (c) 2014 Greg Schommer. All rights reserved.
//

#import "StatisticsViewController.h"
#import <CoreData/CoreData.h>
#import <CoreImage/CoreImage.h>
#import "Store.h"
#import "NSLayoutConstraint+Helpers.h"
#import "ButtonStatisticCell.h"

static NSString *const StatisticsCellReuseId = @"StatisticsCell";
@interface StatisticsViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) UINavigationBar *navBar;
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Statistics", @"");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupNavBar];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.rowHeight = 44.0;
    [self.tableView registerClass:[ButtonStatisticCell class] forCellReuseIdentifier:StatisticsCellReuseId];
    self.tableView.allowsSelection = NO;
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsForPinningView:self.tableView toEdgesOfParent:(LeadingEdge | TrailingEdge | BottomEdge)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navBar][tableView]"
                                                                     options:0
                                                                     metrics:nil
                                                                        views:@{@"navBar" : self.navBar, @"tableView" : self.tableView}]];
    
    self.tableView.dataSource = self;
    [self setupFRC];
}

-(void)dealloc
{
    self.tableView.dataSource = nil;
    self.frc.delegate = nil;
}

#pragma mark Helper methods
-(void) setupNavBar
{
    self.navBar = [[UINavigationBar alloc] init];
    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.navBar];
    [self.view addConstraints:[NSLayoutConstraint constraintsForPinningView:self.navBar toEdgesOfParent:(TopEdge | LeadingEdge | TrailingEdge)]];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.leftBarButtonItem = doneItem;
    UIBarButtonItem *reset = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"") style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed)];
    self.navigationItem.rightBarButtonItem = reset;
    self.navBar.items = @[self.navigationItem];
}

-(void) setupFRC
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_STATISTIC];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MainContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
    NSError *fetchError = nil;
    [self.frc performFetch:&fetchError];
    if(fetchError)
        NSLog(@"%s: Error performing fetch: %@", __PRETTY_FUNCTION__, fetchError);
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView configureCell:(ButtonStatisticCell *) cell atIndexPath: (NSIndexPath *) indexPath
{
    StatisticMO *statistic = [self.frc objectAtIndexPath:indexPath];
    
    //set the color of the colorView
    NSString *colorString = statistic.color;
    UIColor *color = [UIColor colorWithCIColor:[CIColor colorWithString:colorString]];
    cell.colorView.backgroundColor = color;
    
    //set the text of the countLabel
    cell.countLabel.text = @(statistic.count.integerValue).stringValue;
}

#pragma mark UITableViewDataSource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.frc.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[self.frc.sections objectAtIndex:section] numberOfObjects];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonStatisticCell * cell = [tableView dequeueReusableCellWithIdentifier:StatisticsCellReuseId];
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark Target/Actions
-(void) doneButtonPressed
{
    //bring the user back to the presentingViewController
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) resetButtonPressed
{
    //if the resetButtonIsPressed then we need to delete every StatisticMO
    [BackgroundContext performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:ENTITY_STATISTIC];
        NSError *fetchError = nil;
        NSArray *statistics = [BackgroundContext executeFetchRequest:request error:&fetchError];
        if(!fetchError)
        {
            for (StatisticMO *statistic in statistics) {
                [BackgroundContext deleteObject:statistic];
            }
            NSError *saveError = nil;
            [BackgroundContext save:&saveError];
            if(saveError)
                NSLog(@"%s: Error saving context: %@", __PRETTY_FUNCTION__, saveError);
        }
        else
            NSLog(@"%s: Error fetching %@s: %@",__PRETTY_FUNCTION__, request.entityName, fetchError);
    }];
}


#pragma mark NSFetchedResultsController delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    if(controller == self.frc)
    {
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
            {
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
                
            case NSFetchedResultsChangeDelete:
            {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
                
            case NSFetchedResultsChangeUpdate:
            {
                ButtonStatisticCell * cell = (ButtonStatisticCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [self tableView:self.tableView configureCell:cell atIndexPath:indexPath];
            }
                break;
                
            case NSFetchedResultsChangeMove:
            {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
@end