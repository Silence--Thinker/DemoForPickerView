//
//  DateInfoModel.m
//  WisdomTree
//
//  Created by Silent on 2017/5/25.
//  Copyright © 2017年 hyww. All rights reserved.
//

#import "DateInfoModel.h"

@implementation DateInfoModel

- (NSString *)weekString {
//    _week 1--7 周日---周六
    NSArray *weeks = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    return [weeks objectAtIndex:_week - 1];
}

- (NSString *)dateString {
    if (_today) {
        return @"今天";
    }
    return [NSString stringWithFormat:@"%zd年%0.2zd月%0.2zd日%@", _year, _month, _day, self.weekString];
}
@end
