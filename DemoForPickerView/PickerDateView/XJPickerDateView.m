//
//  XJPickerDateView.m
//  DemoForPickerView
//
//  Created by Silent on 2017/5/23.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "XJPickerDateView.h"

#define COLOR_WITH_HEX_STRING_92c659 [UIColor blackColor]

static CGFloat const kPickerHeight = 216;
static NSTimeInterval const kAnimatimeDuration = 0.35;
//static CGFloat const kAlpha = 0.45;

@interface XJPickerDateView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *animateView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIDatePicker *dateView;

@end
@implementation XJPickerDateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xj_buildingDateView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self xj_buildingDateView];
    }
    return self;
}

- (void)xj_buildingDateView {
    self.frame = [UIScreen mainScreen].bounds;
    _contentView = ({
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = self.bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickDisMiss:)];
        [contentView addGestureRecognizer:tap];
        [self addSubview:contentView];
        contentView;
    });
    
    _bgImageView = ({
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        bgImageView.frame = self.bounds;
        [_contentView addSubview:bgImageView];
        bgImageView;
    });
    
    _animateView = ({
        UIImageView *animateView = [[UIImageView alloc] init];
        animateView.image = [self imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(CGRectGetWidth(self.bounds), kPickerHeight + 40)];
        animateView.userInteractionEnabled = YES;
        animateView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), self.bounds.size.width, kPickerHeight + 40);
        [_contentView addSubview:animateView];
        animateView;
    });
    
    _titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"选择喂药时间";
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = COLOR_WITH_HEX_STRING_92c659;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(60, 0, CGRectGetWidth(self.bounds) - 120, 40);
        [_animateView addSubview:titleLabel];
        titleLabel;
    });
    
    UIButton * cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_WITH_HEX_STRING_92c659 forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [_animateView addSubview:cancelBtn];
    
    
    UIButton * selectedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 40);
    [selectedBtn setTitle:@"确认" forState:UIControlStateNormal];
    selectedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectedBtn setTitleColor:COLOR_WITH_HEX_STRING_92c659 forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(didClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_animateView addSubview:selectedBtn];
    
    _lineView = ({
        UIImage *image = [UIImage imageNamed:@"separator_e4"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:0];
        UIImageView *lineView = [[UIImageView alloc]initWithImage:image];
        lineView.frame = CGRectMake(0, 40, CGRectGetWidth(self.bounds), image.size.height);
        [_animateView addSubview:lineView];
        lineView;
    });
    
    _pickerView = ({
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.frame = CGRectMake(0, 40, self.bounds.size.width, kPickerHeight);
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [_animateView addSubview:pickerView];
        pickerView;
    });
}

// MARK - UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 180; //[UIScreen mainScreen].bounds.size.width;
    }
    return 65;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

// MARK - action

- (void)didClickDisMiss:(UITapGestureRecognizer *)tap {
    [self dissMiss];
}

- (void)didClickSureBtn:(UIButton *)sender {
    
    [self dissMiss];
}

- (void)show {
    [self showInView:nil];
}
- (void)showInView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    _bgImageView.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:kAnimatimeDuration animations:^{
       _animateView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kPickerHeight - 40, self.bounds.size.width, kPickerHeight + 40);
        _bgImageView.alpha = 1;
    }];
}

- (void)dissMiss {
    _bgImageView.alpha = 1;
    [UIView animateWithDuration:kAnimatimeDuration animations:^{
        _animateView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), self.bounds.size.width, kPickerHeight + 40);
        _bgImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
