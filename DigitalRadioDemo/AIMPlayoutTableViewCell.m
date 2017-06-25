//
//  PlayoutTableViewCell.m
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 25/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import "AIMPlayoutTableViewCell.h"

@implementation AIMPlayoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithItem:(AIMPlayoutItem *) item{
    
    self.playoutTitleLabel.text = item.title;
    self.playoutArtistLabel.text = item.artist;
    self.playoutStartTimeLabel.text = [item timeAccordingToFormat:@"E d MMM 'at' hh:mm a"];
    self.playoutDurationLabel.text = [item durationAccordingToFormat:@"mm:ss"];
    
    switch (item.status) {
        case AIMPlayoutItemStatus_PLAYING:
        {
            self.playoutStatusPlayingLabel.hidden = NO;
            self.playoutStatusHistoryLabel.hidden = YES;
            self.playoutStatusUnknownLabel.hidden = YES;
            break;
        }
        case AIMPlayoutItemStatus_HISTORY:
        {
            self.playoutStatusPlayingLabel.hidden = YES;
            self.playoutStatusHistoryLabel.hidden = NO;
            self.playoutStatusUnknownLabel.hidden = YES;
            break;
        }
        case AIMPlayoutItemStatus_UNKNOWN:
        {
            self.playoutStatusPlayingLabel.hidden = YES;
            self.playoutStatusHistoryLabel.hidden = YES;
            self.playoutStatusUnknownLabel.hidden = NO;
            break;
        }
        default:
            break;
    }
    
    switch (item.type) {
        case AIMPlayoutItemType_SONG:
        {
            self.playoutTypeSongLabel.hidden = NO;
            self.playoutTypeUnknownLabel.hidden = YES;
            break;
        }
        case AIMPlayoutItemType_UNKNOWN:
        {
            self.playoutTypeSongLabel.hidden = YES;
            self.playoutTypeUnknownLabel.hidden = NO;
            break;
        }
        default:
            break;
    }
}

@end
