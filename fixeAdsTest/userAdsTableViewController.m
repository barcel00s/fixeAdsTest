//
//  userAdsTableViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 16/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "userAdsTableViewController.h"
#import "itemListTableViewCell.h"
#import "Ad.h"

@interface userAdsTableViewController ()<NSFetchedResultsControllerDelegate,itemListTableViewCellProtocol>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, strong) NSArray *datasource;

@end

@implementation userAdsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:_selectedUser.name];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    FAKIonIcons *closeIcon = [FAKIonIcons androidCloseIconWithSize:30];
    [_closeButton setImage:[closeIcon imageWithSize:CGSizeMake(30, 30)]];
    [_closeButton setTitle:nil];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    itemListTableViewCell *cell = (itemListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    Ad *ad = [[_selectedUser.ads array] objectAtIndex:indexPath.row];
    
    [cell setDelegate:self];
    
    FAKIonIcons *placeholder = [FAKIonIcons imageIconWithSize:40];
    
    [cell.customImageView setImage:[placeholder imageWithSize:CGSizeMake(40, 40)]];
    [cell.customImageView setContentMode:UIViewContentModeCenter];
    
    [cell.customTitleLabel setText:ad.title];
    [cell.customPriceLabel setText:ad.price];
    [cell.customLocationLabel setText:ad.city];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
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
    
    return 140.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Ad *selectedAd = [_datasource objectAtIndex:indexPath.row];
    
    [self.delegate didSelectAd:selectedAd fromAds:[_selectedUser.ads array]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)loadTableView{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_selectedUser.ads_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching user ads from server: %@",error.localizedDescription);
            
        }
        else{
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if (error) {
                NSLog(@"Error decoding response from server: %@",error.localizedDescription);
            }
            else{
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
            
            _datasource = [_selectedUser.ads array];
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
        
    }] resume];
}



#pragma mark itemListTableViewCell Delegation
-(void)didTapShareButtonForCell:(itemListTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Ad *selectedAd = [[_selectedUser.ads array] objectAtIndex:indexPath.row];
    
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

- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
