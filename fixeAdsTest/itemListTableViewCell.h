//
//  itemListTableViewCell.h
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import <UIKit/UIKit.h>
@class itemListTableViewCell;

@protocol itemListTableViewCellProtocol <NSObject>

-(void)didTapShareButtonForCell:(itemListTableViewCell *)cell;

@end

@interface itemListTableViewCell : UITableViewCell
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (strong, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *customPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *customLocationLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, weak) id <itemListTableViewCellProtocol> delegate;

@end
