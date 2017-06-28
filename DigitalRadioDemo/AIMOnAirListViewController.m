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
#import "AIMIconDownloader.h"

#define EpgCellIdentifier @"epgCell"
#define PlayoutCellIdentifier @"playoutCell"
#define HeaderCellIdentifier @"header"

@interface AIMOnAirListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSMutableDictionary *downloadedImages;
@end

@implementation AIMOnAirListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionaryWithCapacity:self.onAirDocument.epgItems.count + self.onAirDocument.playoutItems.count];
    
    self.downloadedImages = [NSMutableDictionary dictionaryWithCapacity:self.onAirDocument.epgItems.count + self.onAirDocument.playoutItems.count];
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
    
    return [self isRowEPGAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]]?self.onAirDocument.epgItems.count:self.onAirDocument.playoutItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [self isRowEPGAtIndexPath:indexPath] ? EpgCellIdentifier : PlayoutCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self configureItemCell:(id<AIMOnAirItemTableViewCell>)cell forIndexPath:indexPath];
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    AimHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    
    NSString *headerTitle = [self isRowEPGAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] ?  @"EPG" :  @"Playouts";
    
    cell.headerTitleLabel.text = headerTitle;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self isRowEPGAtIndexPath:indexPath] ? 100 : tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35.0;
}

- (void) configureItemCell:(id<AIMOnAirItemTableViewCell>) cell forIndexPath:(NSIndexPath *) indexPath{
    
    AIMOnAirDocumentItem *item = nil;
    NSString *imageURL = nil;
    
    if ([self isRowEPGAtIndexPath:indexPath]) {
        item = [self.onAirDocument.epgItems objectAtIndex:indexPath.row];
        imageURL = [item.customFields objectForKey:@"image50"];
    }else{
        item = [self.onAirDocument.playoutItems objectAtIndex:indexPath.row];
        imageURL = ((AIMPlayoutItem *) item).imageURL;
    }
    
    [cell configureCellWithItem:item];
    UIImage *cellImage = [self.downloadedImages objectForKey:indexPath];
    
    if (cellImage) {
        [cell updateImage:[self.downloadedImages objectForKey:indexPath]];
    }else{
        if (self.onAirTableView.dragging == NO && self.onAirTableView.decelerating == NO)
        {
            [self startIconDownloadWithURLString:imageURL forIndexPath:indexPath];
        }
    }
}

- (BOOL) isRowEPGAtIndexPath:(NSIndexPath *) indexPath{
    
    return (indexPath.section == 0 && self.onAirDocument.epgItems.count > 0);
}

#pragma mark - 
#pragma mark UITableViewDelegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self isRowEPGAtIndexPath:indexPath]) {
            
        //TODO: go to epg details view controller
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ([self isRowEPGAtIndexPath:indexPath]) ? indexPath : nil;
}

#pragma mark -
#pragma mark - Table cell image support


- (void)startIconDownloadWithURLString:(NSString *) urlString forIndexPath:(NSIndexPath *)indexPath
{
    if (!urlString) {
        return;
    }
    AIMIconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[AIMIconDownloader alloc] init];
        iconDownloader.imageURLString = urlString;
        
        //create weak reference of icon downloader because we will need to call it within the block
        __weak AIMIconDownloader *weakIconDownloader = iconDownloader;
        
        [iconDownloader setCompletionHandler:^{
            
            id<AIMOnAirItemTableViewCell> cell = (id<AIMOnAirItemTableViewCell>)[self.onAirTableView cellForRowAtIndexPath:indexPath];

            // Save the newly loaded image
            if (weakIconDownloader.downloadedImage){
                (self.downloadedImages)[indexPath] = weakIconDownloader.downloadedImage;
            }
            
            //Display the newly loaded image
            [cell updateImage:weakIconDownloader.downloadedImage];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    
    NSArray *visiblePaths = [self.onAirTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        UIImage *downloadedImage = [self.downloadedImages objectForKey:indexPath];
        
        if (!downloadedImage)
            // Avoid the app icon download if the app already has an icon
        {
            [self startIconDownloadWithURLString:[self imageURLStringForItemAtIndexPath:indexPath] forIndexPath:indexPath];
        }
    }
    
}

- (NSString *) imageURLStringForItemAtIndexPath:(NSIndexPath *) indexPath{
    
    NSString *urlString = nil;
    
    if ([self isRowEPGAtIndexPath:indexPath]) {
        
        AIMEPGItem *epgItem = [self.onAirDocument.epgItems objectAtIndex:indexPath.row];
        urlString = [epgItem.customFields objectForKey:@"image50"];
        
    }else{
        AIMPlayoutItem *playoutItem = [self.onAirDocument.playoutItems objectAtIndex:indexPath.row];
        urlString = playoutItem.imageURL;
    }
    
    return urlString;
}
@end
