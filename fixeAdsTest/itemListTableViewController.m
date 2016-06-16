//
//  itemListTableViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "itemListTableViewController.h"
#import "itemListTableViewCell.h"
#import "Ad.h"
#import "showAdViewController.h"

@interface itemListTableViewController ()<NSFetchedResultsControllerDelegate,itemListTableViewCellProtocol>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation itemListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //Initializations
    UIImage *logo = [UIImage imageNamed:@"OLX"];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:logo];
    
    [logoView addSubview:imageView];
    
    [self.navigationItem setTitleView:logoView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"itemListTableViewCell" bundle:nil] forCellReuseIdentifier:@"itemCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadTableView) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:refreshControl];
    
    [refreshControl beginRefreshing];
    
    [self loadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    itemListTableViewCell *cell = (itemListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    [cell setDelegate:self];
    
    Ad *ad = [[_fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    FAKIonIcons *placeholder = [FAKIonIcons imageIconWithSize:40];
    
    [cell.customImageView setImage:[placeholder imageWithSize:CGSizeMake(40, 40)]];
    [cell.customImageView setContentMode:UIViewContentModeCenter];
    
    [cell.customTitleLabel setText:ad.title];
    [cell.customPriceLabel setText:ad.price];
    [cell.customLocationLabel setText:ad.city];
    
    if ([[ad.photos array] count] > 0) {
        Photo *itemPhoto = [[ad.photos array] objectAtIndex:0];
        
        if (!itemPhoto.data) {
            //We download the image data
            [cell setImageURL:[NSURL URLWithString:itemPhoto.url]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:cell.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
            
            NSManagedObjectContext *subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            
            [subContext setParentContext:[sharedAppDelegate managedObjectContext]];
            
            [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"Error downloading image %@ - %@",cell.imageURL,error.localizedDescription);
                }
                else if([response.URL isEqual:cell.imageURL]){
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [cell.customImageView setContentMode:UIViewContentModeScaleAspectFill];
                        
                        [UIView animateWithDuration:0.5 animations:^{
                            [[cell.customImageView superview] setAlpha:0.0];
                            [cell.customImageView setImage:[UIImage imageWithData:data]];
                            [[cell.customImageView superview] setAlpha:1.0];
                        }];
                        
                    }];
                    
                    //Persist the image data.
                    Photo *photoInContext = [Photo findPhotoWithURL:urlRequest.URL.absoluteString inContext:subContext];
                    
                    [photoInContext setData:data];
                    
                    if(![subContext save:&error]){
                        NSLog(@"Error saving subcontext in image download: %@",error.localizedDescription);
                    }
                    else{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [sharedAppDelegate saveContext];
                        }];
                    }

                }
                
            }] resume];
        }
        else{
            [cell.customImageView setContentMode:UIViewContentModeScaleAspectFill];
            [cell.customImageView setImage:[UIImage imageWithData:itemPhoto.data]];
        }
        
    }
    
    return cell;
}

#pragma mark TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 120.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Ad *selectedAd = [[_fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showAd" sender:selectedAd];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *city = [[[_fetchedResultsController sections] objectAtIndex:section] name];
    
    if ([city isEqualToString:@""]) {
        city = @"Undetermined city";
    }
    
    return city;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}
*/

#pragma mark itemListTableViewCell Delegation
-(void)didTapShareButtonForCell:(itemListTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Ad *selectedAd = [[_fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    
    NSArray *activityItems = @[cell.customTitleLabel.text,cell.customImageView.image,[NSURL URLWithString:selectedAd.url]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [activityController setExcludedActivityTypes:@[UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypePostToWeibo,UIActivityTypeAssignToContact,UIActivityTypeOpenInIBooks]];
    
    if ( [activityController respondsToSelector:@selector(popoverPresentationController)] ) {
        
        [activityController.popoverPresentationController setSourceRect:CGRectMake(0, 15, 1, 1)];
        [activityController.popoverPresentationController setSourceView:cell.shareButton];
    }
    
    [self presentViewController:activityController
                                           animated:YES
                                         completion:nil];
    
}

#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showAd"]) {
        showAdViewController *showAdController = (showAdViewController *)segue.destinationViewController;
        
        [showAdController setAds:[_fetchedResultsController fetchedObjects]];
        [showAdController setSelectedAd:sender];
    }
    
}

#pragma mark Functions
-(void)loadTableView{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:itemsDatasourceURLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching data from server: %@",error.localizedDescription);
        }
        else{
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if (error) {
                NSLog(@"Error decoding response from server: %@",error.localizedDescription);
            }
            else{
                NSLog(@"%@",response);
                
                //We are creating the ads outside the main thread so we need to create a subcontext (Core Data is not thread safe)
                
                NSArray *allAds = [response objectForKey:@"ads"];
                
                NSManagedObjectContext *subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                
                [subContext setParentContext:[sharedAppDelegate managedObjectContext]];
                
                for (NSDictionary *ad in allAds){
                    
                    //This will create or update the ad in case it already exists.
                    [Ad createAdWithDetails:ad inContext:subContext];
                }
                
                
                //Save the context
                NSError *error;
                
                [subContext save:&error];
                
                if (error) {
                    NSLog(@"Error saving new ad: %@",error.localizedDescription);
                }
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //Save the main context (main thread)
            NSError *error;
            
            [[sharedAppDelegate managedObjectContext] save:&error];
            
            if (error) {
                NSLog(@"Error saving main context: %@",error.localizedDescription);
            }
            
            //Fetch data from Core Data and show results
            [[self fetchedResultsController] performFetch:&error];
            
            if (error) {
                NSLog(@"Error fetching data: %@",error.localizedDescription);
            }
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
        
    }] resume];
}

#pragma mark FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity     = [NSEntityDescription entityForName:@"Ad" inManagedObjectContext:[sharedAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array. Order from most recent ID to oldest
    NSSortDescriptor *idDescriptor   = [NSSortDescriptor sortDescriptorWithKey:@"ad_id" ascending:NO];
    //NSSortDescriptor *titleDescriptor   = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors                = [NSArray arrayWithObjects:idDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[sharedAppDelegate managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}
@end
