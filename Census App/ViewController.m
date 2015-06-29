//
//  ViewController.m
//  Census App
//
//  Created by Vikram Sivaraja on 6/22/15.
//  Copyright (c) 2015 Vikram Sivaraja. All rights reserved.
//

#import "ViewController.h"
#import "censusCaller.h"

@interface ViewController()
@property (strong, nonatomic) IBOutlet UIButton *popButton;
@property (strong, nonatomic) IBOutlet UIPickerView *stateSpinner;
@property (strong, nonatomic) NSString *stateText;
@property (strong, nonatomic) censusCaller *caller;
@property (strong, nonatomic) IBOutlet UITextField *cityText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stateList = @[@"AK",@"AZ",@"AR",@"CA",@"CO",@"CT",@"DE",@"FL",@"GA",@"HI",@"ID",@"IL",@"IN",@"IA",@"KS",@"KY",@"LA",@"ME",@"MD",@"MA",@"MI",@"MN",@"MS",@"MO",@"MT",@"NE",@"NV",@"NH",@"NJ",@"NM",@"NY",@"NC",@"ND",@"OH",@"OK",@"OR",@"PA",@"RI",@"SC",@"SD",@"TN",@"TX",@"UT",@"VT",@"VA",@"WA",@"WV",@"WI",@"WY"];
    self.stateSpinner.dataSource = self;
    self.stateSpinner.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionDidFinish)
                                                 name:@"NSURLConnectionDidFinish"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionHadError)
                                                 name:@"NSURLConnectionHadError"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noResponse)
                                                 name:@"NSURLReturnedNoResponse"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noState)
                                                 name:@"NSURLNoState"
                                               object:nil];
}

-(void) noState
{
    self.dataLabel.text = @"Could not find the correct city";
}

-(void) connectionHadError
{
    self.dataLabel.text = @"Could not retrieve the info";
}

-(void) connectionDidFinish
{
    self.dataLabel.text = self.caller.response;
}

-(void) noResponse
{
    self.dataLabel.text = @"Please check your inputs";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.stateList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.stateList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.stateText = [self pickerView:self.stateSpinner titleForRow:row forComponent:1];
}

- (IBAction)buttonTap:(id)sender
{
    self.caller = nil;
    self.caller = [[censusCaller alloc] initWithParams:self.cityText.text state:self.stateText searchType:@"hi"];
    [self.caller APICall];
}

@end
