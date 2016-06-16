//
//  mapViewController.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 15/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "mapViewController.h"
#import "Photo.h"


@interface mapViewController ()<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL hasPlacedAnnotations;
@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_mapView setDelegate:self];
    
    UIImage *logo = [UIImage imageNamed:@"OLX"];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:logo];
    
    [logoView addSubview:imageView];
    
    [self.navigationItem setTitleView:logoView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    
    //Place all the annotations after initial rendering
    
    NSLog(@"lat: %@ - lon: %@",_selectedAd.map_latitude,_selectedAd.map_longitude);
    
    if (!_hasPlacedAnnotations && _selectedAd.map_latitude && _selectedAd.map_longitude) {
        MKPointAnnotation *newAnnotation = [self makeSimpleAnnotation];
        [_mapView addAnnotation:newAnnotation];
        
        //Center map on location - Deprecated. We show the full route instead.
        /*        [_mapView setCenterCoordinate:newAnnotation.coordinate animated:YES];
         
         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newAnnotation.coordinate, kDistanceRadiusForRegion, kDistanceRadiusForRegion);
         
         [_mapView setRegion:region animated:NO]; */
        [_mapView selectAnnotation:newAnnotation animated:YES];
        
        
        _hasPlacedAnnotations = YES;
        
    }
    
}

-(MKPointAnnotation *)makeSimpleAnnotation{
    
    MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
    [newAnnotation setTitle:_selectedAd.title];
    [newAnnotation setSubtitle:_selectedAd.price];
    
    CLLocationCoordinate2D eventCoordinates = CLLocationCoordinate2DMake(_selectedAd.map_latitude.floatValue, _selectedAd.map_longitude.floatValue);
    [newAnnotation setCoordinate:eventCoordinates];
    
    return newAnnotation;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //Don't replace the user location blue dot
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([MKPinAnnotationView class])];
    
    if (!pinAnnotationView) {
        
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([MKPinAnnotationView class])];
        [pinAnnotationView setCanShowCallout:YES];
        [pinAnnotationView setAnimatesDrop:YES];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if ([_selectedAd.photos count] > 0) {
            Photo *aPhoto = [[_selectedAd.photos allObjects] objectAtIndex:0];
            
            if (aPhoto.data) {
                [imageView setImage:[UIImage imageWithData:aPhoto.data]];
            }
            else{
                FAKIonIcons *placeholder = [FAKIonIcons imageIconWithSize:40];
                [imageView setImage:[placeholder imageWithSize:CGSizeMake(40, 40)]];
            }
            
            [pinAnnotationView setLeftCalloutAccessoryView:imageView];
            
        }
        else{
            FAKIonIcons *placeholder = [FAKIonIcons imageIconWithSize:40];
            [imageView setImage:[placeholder imageWithSize:CGSizeMake(40, 40)]];
        }
    }
    
    
    
    return pinAnnotationView;
}

@end
