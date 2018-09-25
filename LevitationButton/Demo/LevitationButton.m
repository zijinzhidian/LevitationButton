//
//  LevitationButton.m
//  LevitationButton
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 zjbojin. All rights reserved.
//

#import "LevitationButton.h"

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@interface LevitationButton ()
@property(nonatomic,assign)MoveType moveType;
@end

@implementation LevitationButton

#pragma mark - Initail
- (instancetype)initWithFrame:(CGRect)frame moveType:(MoveType)moveType title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.moveType = moveType;
        self.minY = 0;
        self.maxY = screenH;
        self.isAdsorbable = YES;
        self.isOver = YES;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.backgroundColor = [UIColor orangeColor];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        //添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePosition:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - Actions
- (void)changePosition:(UIPanGestureRecognizer *)pan {
   
    //手指移动时平移的直
    CGPoint translation = [pan translationInView:pan.view];
   
    CGRect originalFrame = pan.view.frame;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.enabled = NO;
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            switch (self.moveType) {
                case MoveTypeNone:
                    originalFrame = [self changeXWithFrame:originalFrame translation:translation];
                    originalFrame = [self changeYWithFrame:originalFrame translation:translation];
                    break;
                
                case MoveTypeVerticalScroll:
                    originalFrame = [self changeXWithFrame:originalFrame translation:translation];
                    break;
                    
                case MoveTypeHorizontalScroll:
                    originalFrame = [self changeYWithFrame:originalFrame translation:translation];
                    break;
            }
            
            pan.view.frame = originalFrame;
            [pan setTranslation:CGPointZero inView:pan.view];
        
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            //判断是否可以吸附
            if (self.isAdsorbable) {
                
                originalFrame = [self adsorbWithFrame:originalFrame];
                originalFrame = [self amendYWithFrame:originalFrame];
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.frame = originalFrame;
                }];
                
            } else if (!self.isAdsorbable && self.isOver) {
               
                originalFrame = [self amendXWithFrame:originalFrame];
                originalFrame = [self amendYWithFrame:originalFrame];
                [UIView animateWithDuration:0.25 animations:^{
                    pan.view.frame = originalFrame;
                }];
                
            }
            
            self.enabled = YES;
        }
            break;
            
        default:
            self.enabled = YES;
            break;
    }
}

- (CGRect)changeXWithFrame:(CGRect)originalFrame translation:(CGPoint)translation {
    //判断是否可以越界
    if (self.isOver) {
        
        originalFrame.origin.x += translation.x;
        
    } else {
        
        originalFrame.origin.x = MAX(0, originalFrame.origin.x + translation.x);
        originalFrame.origin.x = MIN(screenW - originalFrame.size.width, originalFrame.origin.x);

    }
    return originalFrame;
}

- (CGRect)changeYWithFrame:(CGRect)originalFrame translation:(CGPoint)translation {
    
    //判断是否可以越界
    if (self.isOver) {
        
        originalFrame.origin.y = MAX(self.minY - originalFrame.size.height, originalFrame.origin.y + translation.y);
        originalFrame.origin.y = MIN(self.maxY, originalFrame.origin.y);
        
    } else {
        
        originalFrame.origin.y = MAX(self.minY, originalFrame.origin.y + translation.y);
        originalFrame.origin.y = MIN(self.maxY - originalFrame.size.height, originalFrame.origin.y);
        
    }
    return originalFrame;
}

//吸附
- (CGRect)adsorbWithFrame:(CGRect)originalFrame {
    
    CGFloat centerX = originalFrame.origin.x + originalFrame.size.width / 2;
    originalFrame.origin.x = centerX < screenW / 2 ? 0 : screenW - originalFrame.size.width;
    return originalFrame;
    
}

//X越界
- (CGRect)amendXWithFrame:(CGRect)originalFrame {
    
    
    if (originalFrame.origin.x < 0) {
        originalFrame.origin.x = 0;
    } else if (originalFrame.origin.x > screenW - originalFrame.size.width) {
        originalFrame.origin.x = screenW - originalFrame.size.width;
    }
    return originalFrame;
    
}

//Y越界
- (CGRect)amendYWithFrame:(CGRect)originalFrame {
    
    if (originalFrame.origin.y < self.minY) {
        originalFrame.origin.y = self.minY;
    } else if (originalFrame.origin.y > self.maxY - originalFrame.size.height) {
        originalFrame.origin.y = self.maxY - originalFrame.size.height;
    }
    return originalFrame;
}

#pragma mark - Public Actions
- (void)cornerRadius:(CGFloat)radius cornerType:(CornerType)type {
    
    UIBezierPath *maskPath;

    switch (type) {
        case CornerTypeAll:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
            break;
            
        case CornerTypeLeft:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
            break;
            
        case CornerTypeRight:
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
            break;
    }

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

#pragma mark - Getters And Setters
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}


- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}




@end
