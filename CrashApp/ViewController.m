//
//  ViewController.m
//  CrashApp
//
//  Created by Austin on 8/27/15.
//  Copyright (c) 2015 Austin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocationManager *locationManager2;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (nonatomic, strong) UIAlertView *myAlert;
@property (nonatomic, weak) NSTimer *myTimer;

@property (nonatomic, weak) NSMutableURLRequest *request;
@property (nonatomic, strong) NSMutableArray *phoneNumberList;

@end

@implementation ViewController
//gloabal variabes//
CLLocation *currentLocation;
NSDate *beginning;
NSString *URL;
NSString *crashLocation;

double waitSpeed;

bool isCrash = false;
bool isFinished = false;
bool canEnter = true;
bool canEnter2 = true;
bool isAlright = false;
//--------------//

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //sets up and creates/initializes the database that stores the phone numbers//
    NSString *docDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = dirPaths[0];
    
    self.databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:@"myPhonenumbers.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if([filemgr fileExistsAtPath:self.databasePath] == NO){
        const char *dbPath = [self.databasePath UTF8String];
        
        if(sqlite3_open(dbPath, &_DB) == SQLITE_OK){
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS phoneNumbers (ID INTEGER PRIMARY KEY AUTOINCREMENT, NUMBER TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK){
                [self showUIAlertWithMessage:@"Failed to create the table" andTitle:@"Error"];
            }
            sqlite3_close(_DB);
        }
        else{
            [self showUIAlertWithMessage:@"Failed to open/create the table" andTitle:@"Error"];
        }
    }
    //------------------------------------------------------------------------//
    

    self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    self.locationManager.delegate = self; // we set the delegate of locationManager to self.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the desired accuracy of location coordinates
    
    self.motionManager = [[CMMotionManager alloc] init]; //initializing motionManager
    self.motionManager.deviceMotionUpdateInterval = .2; //setting the update interval
    
    //allocating and initializing global variables//
    URL = [[NSString alloc] init];
    self.phoneNumberList = [[NSMutableArray alloc] init];
    //-------------------------------------------//
    
    
    //requests to use location settings if not already done//
    if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization ];
    }
    //----------------------------------------------------//
    
    //load the database values into the local array of phonenumbers//
    [self loadDatabase];
    //------------------------------------------------------------//
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//locks screen in portrait orientation mode//
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
//----------------------------------------//

#pragma mark -CoreLocation Delegates

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    currentLocation = loc;
    
    //error checking//
    NSLog(@"current speed: %f", loc.speed);
    //-------------//
    
    //writes the updated speed value to the SpeedTextField//
    self.speedField.text = [NSString stringWithFormat:@"%.1f m/s", loc.speed];
    //---------------------------------------------------//
    
    if(isFinished == true){
        [self crashDetected];
        //isFinished = false;
    }
    
    if(currentLocation.speed < 0.0 && canEnter == true){
        
        canEnter = false;
        
        self.myAlert = [[UIAlertView alloc]initWithTitle:@"Speed Value is Negative!" message:@"Wait for speed to return positive." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelAlert) userInfo:nil repeats:NO];
        
        [self.myAlert show];
        
    }
    else if(currentLocation.speed >= 0.0 && canEnter2 == true){ //speed is 10(20mph) for normal app only 0.0 for testing
        //error checking//
        NSLog(@"entered motion checking");
        //-------------//
        
        canEnter2 = false;
        
        self.myAlert = [[UIAlertView alloc]initWithTitle:@"Crash Detection Started!" message:@"Started detecting for crash incidents." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelAlert) userInfo:nil repeats:NO];
        [self.myAlert show];
        
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motionData, NSError *error){
            
            if (motionData.userAcceleration.x < -1.0 || motionData.userAcceleration.y > 1.0 || motionData.userAcceleration.z > 1.0) {
                
                [self crashDetected];
            }
        }];
    }
}

#pragma mark -NSURLConnectionData delegates
//put NSURLConnectionData delegates here

#pragma mark -UIAlertView delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        isAlright = true;
        
        //error check//
        NSLog(@"isALright is equal to true");
        //----------//
    }
    else if(buttonIndex == 1){
        canEnter2 = true;
        canEnter = true;
        
        //error check//
        NSLog(@"CanEnter flags set to true");
    }
    // else write code for the rest of the buttons (firstOtherButtonIndex, secondOtherButtonIndex, etc)
}


#pragma mark -local methods
- (void)cancelAlert {
    [self.myAlert dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)crashDetected{
    
    if(isFinished == false) {
        //error checking//
        NSLog(@"Finished == false");
        //-------------//
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //error checking//
            NSLog(@"SPEED AFTER 51 SECONDS OF WAIT: %f", currentLocation.speed);
            //-------------//
            waitSpeed = currentLocation.speed;
            isFinished = true;
        });
    }
    if(isFinished == true){
        //error checking//
        NSLog(@"Finished == true");
        //-------------//
        if(currentLocation.speed < 2.0){ //or if waitSpeed is < 2.0
            isCrash = true;
            //formats strings with current latitude and longitude//
            NSString *lat = @"%20latitude%20";
            NSString *fullLat = [NSString stringWithFormat:@"%@%+.6f", lat, currentLocation.coordinate.latitude];
            
            NSString *lon = @"%20longitude%20";
            NSString *fullLon = [NSString stringWithFormat:@"%@%+.6f", lon, currentLocation.coordinate.longitude];
            
            crashLocation = [NSString stringWithFormat:@"%@%@", fullLat, fullLon];
            //---------------------------------------------------//
        }
        else{
            isCrash = false;
        }
        [self crashAlert];
    }
    isFinished = false;
    
}

-(void)crashAlert{
    
    isAlright = false;
    
    //error checking//
    NSLog(@"crashAlert entered");
    //-------------//
    
    if(isCrash == true){
        //error checking//
        NSLog(@"was a crash");
        //-------------//
        
        self.myAlert = [[UIAlertView alloc]initWithTitle:@"Crash Detected" message:@"Were you in a crash? Will time out in 15 seconds." delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO", nil];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(cancelAlert) userInfo:nil repeats:NO];
        [self.myAlert show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(isAlright == false) {
                //sends alert text message that you have been in a car accident//
                for(int i = 0; i < self.phoneNumberList.count; i++){
                    NSString *phoneNumberString = [self.phoneNumberList objectAtIndex:i];
                    URL = [self createURLString:phoneNumberString];
                    [self getDataFrom:URL];
                    [self.locationManager stopUpdatingLocation];
                }
                //-----------------------------------------------------------//
            }
        });
    }
    else{
        self.myAlert = [[UIAlertView alloc]initWithTitle:@"No Crash Detected" message:@"You were not in a Crash." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelAlert) userInfo:nil repeats:NO];
        [self.myAlert show];
        
        //error checking//
        NSLog(@"No Crash Detected");
        //-------------//

        canEnter = true;
        canEnter2 = true;
    }
    //error checking//
    NSLog(@"End of crashDetection");
    //-------------//
}

//sends an HTTP GET request to the created url string
- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

//creates url string
- (NSString*) createURLString:(NSString*)phoneNumber{
    //creates a URL string with the phone number passed in//
    NSString *firstHalf = @"https://api.mogreet.com/moms/transaction.send?client_id=7102&token=7820c392ec39f98742d6fe56b44f7d5d&campaign_id=110770&to=";
    //does not work with sending location
    NSString *secondHalf = @"&message=Austin%20has%20been%20in%20a%20car%20accident.%20Last%20known%20location%20is";
    
    NSString *finalHalf = [NSString stringWithFormat:@"%@%@", secondHalf, crashLocation];
    
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", firstHalf, phoneNumber, finalHalf];
    return URLString;
    //---------------------------------------------------//
}

- (void)showUIAlertWithMessage:(NSString *)message andTitle:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)loadDatabase{
    //grabs all of the phone numbers that are stored in the database and writes them to the textView//
    sqlite3_stmt *statement;
    int i = 1;
    const char *dbpath = [self.databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        
        //erases all text in text View and rewrites default titleText//
        self.phoneNumbersView.text = @"";
        NSString *defaultText = @"Emergency Contact List:";
        [self.phoneNumbersView setText:[NSString stringWithFormat:@"%@ %@", self.phoneNumbersView.text, defaultText]];
        //----------------------------------------------------------//
        
        NSString *phonenumber = [NSString stringWithFormat:@"SELECT * FROM phoneNumbers"];
        const char *query_statment = [phonenumber UTF8String];
        
        if(sqlite3_prepare_v2(_DB, query_statment, -1, &statement, NULL) == SQLITE_OK){
            while(sqlite3_step(statement) == SQLITE_ROW) {
                NSString *number = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                
                //error checking//
                NSLog(@"Number in DB: %@", number);
                //-------------//
                
                //adds phonenumber from the database into the local array of phonenumbers//
                [self.phoneNumberList addObject:number];
                //----------------------------------------------------------------------//
                
                //writes numbers in database to textView//
                NSString *text = [[NSString alloc] initWithFormat:@"\nPhone Number %d: %@",i ,number];
                [self.phoneNumbersView setText:[NSString stringWithFormat:@"%@ %@", self.phoneNumbersView.text, text]];
                i++;
                //-------------------------------------//
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
        NSLog(@"End of loadDatabase");
    }
    else{
        [self showUIAlertWithMessage:@"problem with opening the database when loading the app" andTitle:@"Error"];
    }
    //--------------------------------------------------------------------------------------------//
}


#pragma mark -Buttons
-(IBAction)tapFound:(id)sender{
    
    if([self.speedField isFirstResponder]){
        [self.view endEditing:YES];
    }
    else if ([self.phoneNumberField isFirstResponder]){
        [self.view endEditing:YES];
    }
    else if([self.removeNumbersField isFirstResponder]){
        [self.view endEditing:YES];
    }
    else{
        [self.view endEditing:YES];

    }
}

- (IBAction)addNumber:(id)sender {
    NSUInteger length = [self.phoneNumberField.text length];
    
    if([self.phoneNumberField.text isEqualToString:@""]){
        //if a phone number has not been entered in the field yet it outputs an error message//
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Number Field is empty" message:@"Please enter a phone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //----------------------------------------------------------------------------------//
    }
    else if(length < 10){
        //if phone number is not of valid length then it ouputs an error message//
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Phone Number" message:@"Please enter a 10 digit phone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.phoneNumberField.text = @"";
        //--------------------------------------------------------------------//
    }
    else{
        //inserts tha value of phoneNumber text field to the database//
        sqlite3_stmt *statement;
        const char* dbpath = [self.databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO phoneNumbers (number) VALUES (\"%@\")", self.phoneNumberField.text];
            
            const char *insert_statement = [insertSQL UTF8String];
            sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
            
            if(sqlite3_step(statement) == SQLITE_DONE){
                [self showUIAlertWithMessage:@"User added PhoneNumber to the database" andTitle:@"Message"];
            }
            else{
                [self showUIAlertWithMessage:@"Failed to add PhoneNumber to the database" andTitle:@"Error"];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
        //---------------------------------------------------------//
        
        //adds number to the phoneNumberList array and writes the phone number to the textView//
        NSString *newPhoneNumber = [[NSString alloc] initWithFormat:@"%@", self.phoneNumberField.text];
        NSString *text = [[NSString alloc] initWithFormat:@"\nPhone Number %lu: %@", (self.phoneNumberList.count + 1) ,newPhoneNumber];
        [self.phoneNumberList addObject:newPhoneNumber];
        self.phoneNumberField.text = @"";
        
        [self.phoneNumbersView setText:[NSString stringWithFormat:@"%@ %@", self.phoneNumbersView.text, text]];
        //-----------------------------------------------------------------------------------//
    }
    
}

- (IBAction)viewNumbers:(id)sender {
    self.back.hidden = NO;
    self.phoneNumbersView.hidden = NO;
    self.removeNumbers.hidden = NO;
    self.removeNumbersField.hidden = NO;
    self.speedField.hidden = YES;
    self.speedLabel.hidden = YES;
    self.phoneNumberLabel.hidden = YES;
    self.addNumber.hidden = YES;
    self.viewNumbers.hidden = YES;
    self.start.hidden = YES;
    self.phoneNumberField.hidden = YES;
    self.crashApp.hidden = YES;
    self.back2.hidden = YES;
}

- (IBAction)removeNumbers:(id)sender {
    NSUInteger index = ([self.removeNumbersField.text integerValue] - 1);
    NSString *message = [[NSString alloc] initWithFormat:@"Please enter a number < or = %lu (also cannot be 0)", self.phoneNumberList.count];
    
    if(self.phoneNumberList.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing to remove" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        if([self.removeNumbersField.text isEqualToString:@""]){
            //if there was no number specified to delete it will throw an error message//
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing entered!" message:@"Please enter a number to be removed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            //-----------------------------------------------------------------------//
        }
        else if (index > (self.phoneNumberList.count - 1)){
            //if index value is out of the range of the array it will throw an error message//
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Value entered is Invalid!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            //-----------------------------------------------------------------------------//
        }
        else{
            //removing the phonenumber from the database//
            NSString *IDValue = [self.phoneNumberList objectAtIndex:index];
            const char *dbpath = [self.databasePath UTF8String];
            char *errorMessage;
            
            if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
                NSLog(@"%@", IDValue);
                NSString *removeSQL = [NSString stringWithFormat:@"DELETE FROM phoneNumbers WHERE NUMBER == \"%@\"", IDValue];
                const char *query_statment = [removeSQL UTF8String];
                
                if(sqlite3_exec(_DB, query_statment, NULL, NULL, &errorMessage) == SQLITE_OK){
                    [self showUIAlertWithMessage:@"Deleted phoneNumber from database" andTitle:@"Message"];
                }
                else{
                    [self showUIAlertWithMessage:@"Failed to delete phoneNumber from database" andTitle:@"Error"];
                }
                sqlite3_close(_DB);
            }
            else{
                [self showUIAlertWithMessage:@"Failed to delete from database" andTitle:@"Error"];
            }
            //-----------------------------------------//
            
            //removes the selected number from the phoneNumberList Array//
            [self.phoneNumberList removeObjectAtIndex:index];
            //---------------------------------------------------------//
            
            //erases all text in text View and rewrites default title//
            self.phoneNumbersView.text = @"";
            NSString *defaultText = @"Emergency Contact List:";
            [self.phoneNumbersView setText:[NSString stringWithFormat:@"%@ %@", self.phoneNumbersView.text, defaultText]];
            //------------------------------------------------------//
            
            //rewrites the updated list of phone numbers to the textView//
            for(int i = 0; i < self.phoneNumberList.count; i ++){
                NSString *newPhoneNumber = [[NSString alloc] initWithFormat:@"%@", [self.phoneNumberList objectAtIndex:i]];
                NSString *text = [[NSString alloc] initWithFormat:@"\nPhone Number %d: %@",(i + 1) ,newPhoneNumber];
                [self.phoneNumbersView setText:[NSString stringWithFormat:@"%@ %@", self.phoneNumbersView.text, text]];
            }
            self.removeNumbersField.text = @"";
            //---------------------------------------------------------//
            
        }
    }
}

- (IBAction)start:(id)sender {
    if(self.phoneNumberList.count > 0){
        //only starts updating locations if an emergency contact has been entered//
        [self.locationManager startUpdatingLocation];
        //----------------------------------------------------------------------//
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Number List Empty" message:@"You have to enter in at least one phone to send notifications to before starting" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)back:(id)sender {
    
    self.back.hidden = YES;
    self.phoneNumbersView.hidden = YES;
    self.removeNumbers.hidden = YES;
    self.removeNumbersField.hidden = YES;
    self.speedField.hidden = NO;
    self.speedLabel.hidden = NO;
    self.phoneNumberLabel.hidden = NO;
    self.addNumber.hidden = NO;
    self.viewNumbers.hidden = NO;
    self.start.hidden = NO;
    self.phoneNumberField.hidden = NO;
    self.crashApp.hidden = NO;
    self.back2.hidden = NO;
}

- (IBAction)back2:(id)sender{
    [self.locationManager stopUpdatingLocation];
    [self.motionManager stopAccelerometerUpdates];
    //error checking//
    NSLog(@"Stopped updating locationa and accelerometer data");
    //-------------//
}

@end
