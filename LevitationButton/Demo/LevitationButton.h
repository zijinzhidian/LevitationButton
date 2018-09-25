//
//  LevitationButton.h
//  LevitationButton
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 zjbojin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MoveType) {
    MoveTypeNone = 0,           //随便移动
    MoveTypeVerticalScroll,     //只能水平移动
    MoveTypeHorizontalScroll    //只能竖直移动
};

typedef NS_ENUM(NSUInteger, CornerType) {
    CornerTypeAll = 0,          //全部圆角
    CornerTypeLeft,             //左侧圆角
    CornerTypeRight             //右侧圆角
};

@interface LevitationButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame
                     moveType:(MoveType)moveType
                        title:(NSString *)title;

- (void)cornerRadius:(CGFloat)radius cornerType:(CornerType)type;

//字体颜色,默认为white
@property(nonatomic,strong)UIColor *titleColor;
//字体大小,默认为11
@property(nonatomic,strong)UIFont *titleFont;
//背景图片,默认无
@property(nonatomic,strong)UIImage *backgroundImage;
//有效活动范围的最小Y坐标,默认为0
@property(nonatomic,assign)CGFloat minY;
//有效活动范围的最小Y坐标,默认为屏幕高度最大值
@property(nonatomic,assign)CGFloat maxY;
//是否可以左右吸附,默认为YES
@property(nonatomic,assign)BOOL isAdsorbable;
//是否可以越界,默认为YES
@property(nonatomic,assign)BOOL isOver;
@end
