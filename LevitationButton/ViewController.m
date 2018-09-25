//
//  ViewController.m
//  LevitationButton
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 zjbojin. All rights reserved.
//

#import "ViewController.h"
#import "LevitationButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 88)];
    view1.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 500, self.view.frame.size.width, self.view.frame.size.height - 500)];
    view2.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    LevitationButton *levitationButton = [[LevitationButton alloc] initWithFrame:CGRectMake(0, 100, 100, 50) moveType:MoveTypeHorizontalScroll title:@"这是\n一个测试的悬浮按钮"];
    [levitationButton cornerRadius:25 cornerType:CornerTypeRight];
    levitationButton.minY = 88;
    levitationButton.maxY = 500;
//    levitationButton.isOver = NO;
    levitationButton.isAdsorbable = NO;
    
    [levitationButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:levitationButton];
    });
}


- (void)test {
    NSLog(@"点击");
}

@end
