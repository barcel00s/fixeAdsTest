//
//  imagePageContentViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "imagePageContentViewController.h"

@interface imagePageContentViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityControl;

@end

@implementation imagePageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_imageView setContentMode:_contentMode];
    
    if (_selectedPhoto.data) {
        //Photo already has data
        [_imageView setContentMode:_contentMode];
        [_imageView setImage:[UIImage imageWithData:_selectedPhoto.data]];
    }
    else{
        //We need to download the image data.
        [_activityControl startAnimating];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_selectedPhoto.url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
        
        NSManagedObjectContext *subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [subContext setParentContext:[sharedAppDelegate managedObjectContext]];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"Error downloading image %@: %@",_selectedPhoto.url,error.localizedDescription);
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    FAKIonIcons *placeholder = [FAKIonIcons imageIconWithSize:40];
                    
                    [_imageView setImage:[placeholder imageWithSize:CGSizeMake(40, 40)]];
                    [_imageView setContentMode:UIViewContentModeCenter];
                    
                    [_activityControl stopAnimating];
                }];
                
            }
            else{
                Photo *photoInContext = [Photo findPhotoWithURL:urlRequest.URL.absoluteString inContext:subContext];
                
                [photoInContext setData:data];
                
                if(![subContext save:&error]){
                    NSLog(@"Error saving subcontext in image download: %@",error.localizedDescription);
                }
             
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [_imageView setContentMode:_contentMode];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        [_imageView setAlpha:0.0];
                        [_imageView setImage:[UIImage imageWithData:data]];
                        [_imageView setAlpha:1.0];
                    }];
                    
                    [sharedAppDelegate saveContext];
                    [_activityControl stopAnimating];
                }];
                
            }
            
            
        }] resume];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
