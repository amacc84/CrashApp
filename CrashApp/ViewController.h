//
//  ViewController.h
//  CrashApp
//
//  Created by Austin on 8/27/15.
//  Copyright (c) 2015 Austin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <sqlite3.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *speedField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *removeNumbersField;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *crashApp;


@property (weak, nonatomic) IBOutlet UITextView *phoneNumbersView;

@property (weak, nonatomic) IBOutlet UIButton *addNumber;
@property (weak, nonatomic) IBOutlet UIButton *viewNumbers;
@property (weak, nonatomic) IBOutlet UIButton *removeNumbers;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *back2;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *DB;




-(IBAction)tapFound:(id)sender;
- (IBAction)addNumber:(id)sender;
- (IBAction)viewNumbers:(id)sender;
- (IBAction)removeNumbers:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)back2:(id)sender;

@end

