//
//  ViewController.h
//  Census App
//
//  Created by Vikram Sivaraja on 6/22/15.
//  Copyright (c) 2015 Vikram Sivaraja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSArray* stateList;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;

@end

