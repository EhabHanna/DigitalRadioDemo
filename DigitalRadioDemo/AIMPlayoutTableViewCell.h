//
//  PlayoutTableViewCell.h
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 25/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMOnAirItemTableViewCell.h"

@interface AIMPlayoutTableViewCell : UITableViewCell<AIMOnAirItemTableViewCell>
@property (weak, nonatomic) IBOutlet UIImageView *playoutImageView;
@property (weak, nonatomic) IBOutlet UILabel *playoutTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutArtistLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutTypeSongLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutTypeUnknownLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutStatusPlayingLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutStatusHistoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *playoutStatusUnknownLabel;
- (void) configureCellWithItem:(AIMPlayoutItem *) item;

@end
