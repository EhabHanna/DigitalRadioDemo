//
//  AIMOnAirListViewController.m
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 25/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import "AIMOnAirListViewController.h"
#import "AIMEPGTableViewCell.h"
#import "AIMPlayoutTableViewCell.h"
#import "AimHeaderViewCell.h"

#define EpgCellIdentifier @"epgCell"
#define PlayoutCellIdentifier @"playoutCell"
#define HeaderCellIdentifier @"header"

@interface AIMOnAirListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AIMOnAirListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark UITableViewDatasource methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    int sections = 0;
    
    if (self.onAirDocument.epgItems.count > 0) {
        sections  = sections + 1;
    }
    
    if (self.onAirDocument.playoutItems.count > 0) {
        sections = sections + 1;
    }
    
    return sections;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.onAirDocument.epgItems.count > 0) {
            return self.onAirDocument.epgItems.count;
        }else{
            return self.onAirDocument.playoutItems.count;
        }
    }else{
        return self.onAirDocument.playoutItems.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        if (self.onAirDocument.epgItems.count > 0) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:EpgCellIdentifier];
            [self configureEPGCell:(AIMEPGTableViewCell *) cell forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:PlayoutCellIdentifier];
            [self configurePlayoutCell:(AIMPlayoutTableViewCell *) cell forIndexPath:indexPath];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:PlayoutCellIdentifier];
        [self configurePlayoutCell:(AIMPlayoutTableViewCell *) cell forIndexPath:indexPath];
    }
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    AimHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    
    if (section == 0) {
        
        if (self.onAirDocument.epgItems.count > 0) {
            
            cell.headerTitleLabel.text = @"EPGs";
            
        }else{
            cell.headerTitleLabel.text = @"Playouts";
            
        }
    }else{
        cell.headerTitleLabel.text = @"Playouts";
        
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (void) configureEPGCell:(AIMEPGTableViewCell *) cell forIndexPath:(NSIndexPath *) indexPath{
    
    AIMEPGItem *item = [self.onAirDocument.epgItems objectAtIndex:indexPath.row];
    
    [cell configureCellWithItem:item];
    
}

- (void) configurePlayoutCell:(AIMPlayoutTableViewCell *) cell forIndexPath:(NSIndexPath *) indexPath{
    
    AIMPlayoutItem *item = [self.onAirDocument.playoutItems objectAtIndex:indexPath.row];
    
    [cell configureCellWithItem:item];
}

#pragma mark - 
#pragma mark UITableViewDelegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.onAirDocument.epgItems.count > 0) {
            
            //go to epg details view controller
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.onAirDocument.epgItems.count > 0) {
            
            return indexPath;
        }
        
    }
    
    return nil;
}
@end
