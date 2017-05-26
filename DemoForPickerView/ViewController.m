//
//  ViewController.m
//  DemoForPickerView
//
//  Created by Silent on 2017/5/23.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "XJPickerDateView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didClickBtn:(UIButton *)sender {
    XJPickerDateView *dateView = [[XJPickerDateView alloc] init];
    dateView.didClickSure= ^(DateInfoModel *dateModel){
        self.label.text = dateModel.dateString;
    };
    [dateView show];
//    [self.view addSubview:dateView];
}


@end
