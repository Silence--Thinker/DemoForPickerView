//
//  DatePickerView.h
//  DemoForPickerView
//
//  Created by Silent on 2017/5/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateInfoModel.h"

typedef void(^YearMonthInfoBlock)(DateInfoModel *dateModel);

@interface DatePickerView : UIView

@property (nonatomic, strong) NSDate *currentDate;

- (void)getCurrentDateInfo:(YearMonthInfoBlock)dateInfo;
@end
