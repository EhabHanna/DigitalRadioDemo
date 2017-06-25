//
//  AIMOnAirListViewController.h
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 25/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMOnAirDocument.h"

@interface AIMOnAirListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *onAirTableView;
@property (nonatomic, strong) AIMOnAirDocument *onAirDocument;
@end
