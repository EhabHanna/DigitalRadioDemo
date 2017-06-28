//
//  AIMOnAirItemTableViewCell.h
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 28/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIMOnAirDocument.h"

@protocol AIMOnAirItemTableViewCell <NSObject>

- (void) configureCellWithItem:(AIMOnAirDocumentItem *) item;
- (void) updateImage:(UIImage *) image;
@end
