//
//  EPGTableViewCell.m
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 25/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import "AIMEPGTableViewCell.h"

@implementation AIMEPGTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configureCellWithItem:(AIMEPGItem *)item{
    
    self.epgStartTimeLabel.text = [item timeAccordingToFormat:@"E d MMM 'at' hh:mm a"];
    self.epgDurationLabel.text = [item durationAccordingToFormat:@"H 'hrs' m 'mins'"];
    self.epgTitleLabel.text = item.name;
    if (item.presenter.length > 0) {
        self.epgPresenterLabel.text = item.presenter;
        self.epgPresenterLabel.hidden = NO;
    }else{
        self.epgPresenterLabel.hidden = YES;
    }
}

@end
