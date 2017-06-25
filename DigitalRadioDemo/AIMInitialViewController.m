//
//  ViewController.m
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import "AIMInitialViewController.h"

#import "AIMOnAirXMLParser.h"
#import "Reachability.h"
#import "AIMOnAirListViewController.h"

typedef enum {
    
    ViewStatus_FetchingOnAirSource,
    ViewStatus_ParsingOnAirSource,
    ViewStatus_FinishedParsing,
    ViewStatus_FailedParsing
    
} ViewStatus;

#define onAirPath @"OnAir"

@interface AIMInitialViewController ()<AIMOnAirDocumentParserDelegate>
@property (nonatomic, strong) id<AIMOnAirDocumentParser> onAirDocumentParser;
@property (nonatomic, assign) ViewStatus viewStatus;
@property (nonatomic, strong) NSString *onAirDocumentType;
@property (nonatomic, strong) AIMOnAirDocument *parsedDocument;
@end

@implementation AIMInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.onAirDocumentType = @"xml";
    [self getOnAirDataSource];
    
}

- (void) parseOnAirData{
    
    self.onAirDocumentParser.delegate = self;
    [self.onAirDocumentParser parse];
    
    self.viewStatus = ViewStatus_ParsingOnAirSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark OnAirData fetching
- (void) getOnAirDataSource{
    
    NSString *localCopyPath = [[self getPathForCachedOnAirData] stringByAppendingPathComponent:@"onair"];
    [localCopyPath stringByAppendingPathExtension:self.onAirDocumentType];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localCopyPath]) {
        //use local copy
        self.onAirDocumentParser = [[AIMOnAirXMLParser alloc] initWithFile:localCopyPath];
        [self parseOnAirData];
    }else{
        //fetch from internet
        [self fetchOnAirDataFromInternet];
    }
    
}

- (NSString *) getPathForCachedOnAirData{
    
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    
    myPath = [myPath stringByAppendingPathComponent:onAirPath];
    
    BOOL isDir=YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath isDirectory:&isDir]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return myPath;
}

- (void) deleteCachedOnAirData{
    
    NSString *localCopyPath = [[self getPathForCachedOnAirData] stringByAppendingPathComponent:@"onair"];
    [localCopyPath stringByAppendingPathExtension:self.onAirDocumentType];
    
    NSError *error = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:localCopyPath error:&error];
    
    if (error) {
        //handle error if any
    }
}

- (void) saveOnAirDataToDisk:(NSData *) file{
    
    NSString *localCopyPath = [[self getPathForCachedOnAirData] stringByAppendingPathComponent:@"onair"];
    [localCopyPath stringByAppendingPathExtension:self.onAirDocumentType];
    
    [file writeToFile:localCopyPath atomically:YES];
}

- (void) fetchOnAirDataFromInternet{
    
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.viewStatus = ViewStatus_FetchingOnAirSource;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *xmlDataFile = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://aim.appdata.abc.net.au.edgesuite.net/data/abc/triplej/onair.xml"]];
            
            if (xmlDataFile) {
                [self saveOnAirDataToDisk:xmlDataFile];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (xmlDataFile) {
                    
                    NSString *xmlString = [[NSString alloc] initWithData:xmlDataFile encoding:NSUTF8StringEncoding];
                    self.onAirDocumentParser = [[AIMOnAirXMLParser alloc] initWithRawString:xmlString];
                    [self parseOnAirData];
                }else{
                    [self showDataFetchErrorAlert];
                }
                
            });
        });
        
    }else{
        [self showNoInternetConnectionAlert];
    }
}

#pragma mark - 
#pragma mark updateViewContents

- (void) setViewStatus:(ViewStatus)aViewStatus{
    
    _viewStatus = aViewStatus;
    [self updateViewContentsAccordingToStatus];
}

- (void) updateViewContentsAccordingToStatus{
    
    switch (self.viewStatus) {
        case ViewStatus_FetchingOnAirSource:
            self.loadingLabel.text = @"Fetching Data...";
            [self.activityIndicator startAnimating];
            self.loadingLabel.hidden = NO;
            self.parsingSuccessLabel.hidden = YES;
            break;
            
        case ViewStatus_ParsingOnAirSource:
        {
            self.loadingLabel.text = @"Parsing Data...";
            [self.activityIndicator startAnimating];
            self.loadingLabel.hidden = NO;
            self.parsingSuccessLabel.hidden = YES;
            break;
        }
        case ViewStatus_FinishedParsing:
            self.loadingLabel.text = @"Data Parsed";
            [self.activityIndicator stopAnimating];
            self.loadingLabel.hidden = NO;
            self.parsingSuccessLabel.hidden = NO;
            break;
            
        case ViewStatus_FailedParsing:
            self.loadingLabel.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.parsingSuccessLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

#pragma mark - 
#pragma mark Alert methods

- (void) showParsingFailureAlert{
    
    NSString *title = @"Data Parsing Failed";
    NSString *message = @"App could not parse on air data and cannot continue. What would you like to do?";
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self deleteCachedOnAirData];
                                                              [self getOnAirDataSource];
                                                          }];
    
    UIAlertAction* exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              exit(0);
                                                          }];
    
    NSArray<UIAlertAction *> *actions = @[defaultAction, exitAction];
    [self showFailureAlertWithTitle:title message:message actions:actions];
    
}

- (void) showNoInternetConnectionAlert{
    
    NSString *title = @"No Internet Connection";
    NSString *message = @"Your device is not connected to the internet. Please check your connection and try again";
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self getOnAirDataSource];
                                                          }];
    
    UIAlertAction* exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           exit(0);
                                                       }];
    
    NSArray<UIAlertAction *> *actions = @[defaultAction, exitAction];
    [self showFailureAlertWithTitle:title message:message actions:actions];
}

- (void) showDataFetchErrorAlert{
    
    NSString *title = @"Data Retreival Error";
    NSString *message = @"App could not retreive data from server, server may be experiencing issues. What would you like to do?";
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self getOnAirDataSource];
                                                          }];
    
    UIAlertAction* exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           exit(0);
                                                       }];
    
    NSArray<UIAlertAction *> *actions = @[defaultAction, exitAction];
    [self showFailureAlertWithTitle:title message:message actions:actions];
}

- (void) showFailureAlertWithTitle:(NSString *) title message:(NSString *) message actions:(NSArray<UIAlertAction *> *) actions{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
 
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark AimOnAirDocumentParser methods

- (void) parser:(id<AIMOnAirDocumentParser>)parser didFailWithError:(NSError *)error{
    
    self.viewStatus = ViewStatus_FailedParsing;
    [self showParsingFailureAlert];
}

- (void) parser:(id<AIMOnAirDocumentParser>)parser didFinishParsingWithObject:(AIMOnAirDocument *)onAirDocument{
    
    self.viewStatus = ViewStatus_FinishedParsing;
    self.parsedDocument = onAirDocument;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // transition to next view and pass ther parsed Document here
        [self performSegueWithIdentifier:@"onAirTableView" sender:self];
    });
    
}

#pragma mark - 
#pragma mark Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"onAirTableView"]) {
     
        
        AIMOnAirListViewController *listVC = segue.destinationViewController;
        listVC.onAirDocument = self.parsedDocument;
        self.parsedDocument = nil;
    }
}


@end
