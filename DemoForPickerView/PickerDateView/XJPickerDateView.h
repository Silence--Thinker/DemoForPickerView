//
//  XJPickerDateView.h
//  DemoForPickerView
//
//  Created by Silent on 2017/5/23.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateInfoModel.h"

typedef void(^DateInfoBlock)(DateInfoModel *dateModel);

@interface XJPickerDateView : UIView

@property (nonatomic, copy) DateInfoBlock didClickSure;
@property (nonatomic, strong) NSDate *currentDate;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)dissMiss;

@end
