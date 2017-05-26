//
//  DateInfoModel.h
//  WisdomTree
//
//  Created by Silent on 2017/5/25.
//  Copyright © 2017年 hyww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateInfoModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) BOOL today;

@property (nonatomic, strong, readonly) NSString *dateString;
@property (nonatomic, strong, readonly) NSString *weekString;

@end
