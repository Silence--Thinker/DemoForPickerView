//
//  DatePickerView.m
//  DemoForPickerView
//
//  Created by Silent on 2017/5/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "DatePickerView.h"

#define MOST_DAY_COUNT      30
#define DISTANCE_COUNT      -2

static NSUInteger const kHourPerDay = 24;
static NSUInteger const kMinutePerHour = 60;
static NSTimeInterval const kMinuteInterval = 30;

@interface DatePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) YearMonthInfoBlock dateInfoBlock;
@end
@implementation DatePickerView {
    NSDate *_startDate;
    NSDate *_endDate;
    NSMutableArray<DateInfoModel *> *_dayInfoListM;  // yyyyMMdd
    NSMutableDictionary<NSNumber *, NSNumber *> *_rowIndexM;
}

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
    _pickerView.frame = self.bounds;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = NO;
    [self addSubview:_pickerView];
    
    _rowIndexM = [NSMutableDictionary dictionary];
    _dayInfoListM = [NSMutableArray array];
    
    _currentDate = [NSDate date];
    [self buildingPickerViewDataSource];
    
    [_rowIndexM enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL * _Nonnull stop) {
        [_pickerView selectRow:obj.integerValue inComponent:key.integerValue animated:NO];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pickerView.frame = self.bounds;
}

// MARK - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 180;
    }else if (component == 1) {
        return 75;
    }
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return MOST_DAY_COUNT;
    }else if (component == 1) {
        return kHourPerDay;
    }
    return kMinutePerHour / kMinuteInterval;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)reuseLabel {
    
    UILabel *label = reuseLabel;
    if (reuseLabel == nil) {
        label = [[UILabel alloc] init];
    }
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = COLOR_WITH_HEX_STRING_999999;
    
    if (component == 0) {
        label.textAlignment = NSTextAlignmentRight;
        DateInfoModel *model = _dayInfoListM[row];
        label.text = model.dateString;
    }else if (component == 1) {
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%0.2zd点", row];
    }else if (component == 2) {
        label.textAlignment = NSTextAlignmentLeft;
        NSInteger minute = row * kMinuteInterval;
        label.text = [NSString stringWithFormat:@"%0.2zd分", minute];
    }
    NSNumber *index = [_rowIndexM objectForKey:@(component)];
    if (index.integerValue == row) {
        label.textColor = COLOR_WITH_HEX_STRING_28D19D;
        label.font = [UIFont boldSystemFontOfSize:16];
    }
    [pickerView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if(idx != 0) {
            subview.backgroundColor = COLOR_WITH_HEX_STRING_28D19D;
            CGRect frame = subview.frame;
            frame.size.height = SINGLE_LINE_WIDTH;
            subview.frame = frame;
        }
    }];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [_rowIndexM setObject:@(row) forKey:@(component)];
    [pickerView reloadAllComponents];
}

// MARK - data

- (void)buildingPickerViewDataSource {
    // date 信息
    _startDate = [self getNewDate:_currentDate distanceDay:DISTANCE_COUNT];
    _endDate = [self getNewDate:_startDate distanceDay:MOST_DAY_COUNT];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    NSDate *date = _startDate;
    for (NSInteger i = 0; i < MOST_DAY_COUNT; i++) {
        [self yearMonthInfo:date completion:^(DateInfoModel *dateModel) {
            if (i == abs(DISTANCE_COUNT)) {
                dateModel.today = YES;
            }
            [arrayM addObject:dateModel];
            
        }];
        date = [self getNewDate:date distanceDay:1];
    }
    _dayInfoListM = arrayM;
    DateInfoModel *currentModel = _dayInfoListM[abs(DISTANCE_COUNT)];
    
    NSInteger tempIndex = (currentModel.minute / kMinuteInterval);
    [_rowIndexM setObject:@(abs(DISTANCE_COUNT)) forKey:@(0)];
    [_rowIndexM setObject:@(currentModel.hour) forKey:@(1)];
    [_rowIndexM setObject:@(tempIndex) forKey:@(2)];
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    
    [self buildingPickerViewDataSource];
    [self.pickerView reloadAllComponents];
    
    [_rowIndexM enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL * _Nonnull stop) {
        [_pickerView selectRow:obj.integerValue inComponent:key.integerValue animated:NO];
    }];
}

- (NSDate *)getNewDate:(NSDate *)date distanceDay:(NSInteger)dayCout {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = dayCout;
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:date options:0];
    return newDate;
}

// 获取 date 中的年月日周时分
- (void)yearMonthInfo:(NSDate *)date completion:(YearMonthInfoBlock)completion {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =   NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitWeekday|
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute;
    
    comps = [calendar components:unitFlags fromDate:date];
    DateInfoModel *dateModel = [DateInfoModel new];
    dateModel.year = [comps year];
    dateModel.month = [comps month];
    dateModel.week = [comps weekday];
    dateModel.day = [comps day];
    dateModel.hour = [comps hour];
    dateModel.minute = [comps minute];
    
    !completion ?: completion(dateModel);
}

// 某月的第一天是星期几
- (NSInteger)fistDayWeekInYear:(NSInteger)year month:(NSInteger)month {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *dateStirng = [NSString stringWithFormat:@"%zd%0.2zd01",year ,month];
    NSDate *tempDate = [fmt dateFromString:dateStirng];
    
    fmt.dateFormat = @"EEEE";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *dateString = [fmt stringFromDate:tempDate];
    
    NSArray *weekArray = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekIndex = 0;
    for (NSString *week in weekArray) {
        if ([dateString isEqualToString:week]) {
            weekIndex = [weekArray indexOfObject:week];
        }
    }
    return weekIndex;
}

// 某月有多少天
- (NSInteger)dayCountForDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

- (void)getCurrentDateInfo:(YearMonthInfoBlock)dateInfo {
    NSInteger dayIndex = [_pickerView selectedRowInComponent:0];
    NSInteger hourIndex = [_pickerView selectedRowInComponent:1];
    NSInteger minuteIndex = [_pickerView selectedRowInComponent:2];
    
    DateInfoModel *model = _dayInfoListM[dayIndex];
    model.hour = hourIndex;
    model.minute = minuteIndex;
    dateInfo(model);
}
@end
