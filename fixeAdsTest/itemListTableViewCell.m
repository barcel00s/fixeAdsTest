//
//  itemListTableViewCell.m
//  fixeAdsTest
//
//  Created by Rui Cardoso on 14/06/16.
//  Copyright © 2016 Rui Cardoso. All rights reserved.
//

#import "itemListTableViewCell.h"

@implementation itemListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //Dynamic Text Changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    [self refreshFonts];
    
    FAKIonIcons *shareIcon = [FAKIonIcons androidShareAltIconWithSize:_shareButton.frame.size.width];
    [_shareButton setImage:[shareIcon imageWithSize:CGSizeMake(_shareButton.frame.size.width, _shareButton.frame.size.height)] forState:UIControlStateNormal];
    
    [_customImageView.layer setCornerRadius:10.0];
    [_customImageView.layer setBorderColor:[UIColor blackColor].CGColor];
    [_customImageView.layer setBorderWidth:1.0];
    
    [[_customImageView superview].layer setShadowColor:[UIColor blackColor].CGColor];
    [[_customImageView superview].layer setShadowRadius:5.0];
    [[_customImageView superview].layer setShadowOpacity:0.7];
    [[_customImageView superview].layer setShadowOffset:CGSizeMake(0, 5)];
    [[_customImageView superview].layer setShadowPath:[UIBezierPath bezierPathWithRect:_customImageView.bounds].CGPath];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Button Actions
- (IBAction)shareButton:(UIButton *)sender {
    [self.delegate didTapShareButtonForCell:self];
}


#pragma mark Functions

-(void)refreshFonts{
    //Title Label
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    NSNumber *fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    
    NSDictionary *fontTraitsDictionary = @{UIFontWeightTrait:[NSNumber numberWithFloat:UIFontWeightMedium]};
    
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont,UIFontDescriptorTraitsAttribute:fontTraitsDictionary}];
    
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_customTitleLabel setFont:font];
    
    
    //Location Label
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_customLocationLabel setFont:font];
    
    //Price Label - Footnote Template
    fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
    
    fontSize = fontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    fontTraitsDictionary = @{UIFontWeightTrait:[NSNumber numberWithFloat:UIFontWeightBold]};
    
    fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:sharedAppDelegate.appFont,UIFontDescriptorTraitsAttribute:fontTraitsDictionary}];
    
    font = [UIFont fontWithDescriptor:fontDescriptor size:[fontSize floatValue]];
    
    [_customPriceLabel setFont:font];
}

@end
