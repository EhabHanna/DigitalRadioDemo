//
//  EPGTableViewCell.h
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 25/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AIMOnAirDocument.h"

@interface AIMEPGTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *epgImageView;
@property (weak, nonatomic) IBOutlet UILabel *epgTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *epgPresenterLabel;
@property (weak, nonatomic) IBOutlet UILabel *epgDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *epgStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *epgDescriptionLabel;

- (void) configureCellWithItem:(AIMEPGItem *) item;
@end
