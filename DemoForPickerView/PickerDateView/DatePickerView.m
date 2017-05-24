//
//  DatePickerView.m
//  DemoForPickerView
//
//  Created by Silent on 2017/5/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@end
@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildingDateSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self buildingDateSubView];
    }
    return self;
}

- (void)buildingDateSubView {
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
}

// MARK - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

@end
