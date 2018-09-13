//
//  ATRefreshHeader.h
//  ATRefreshHeader
//
//  Created by alan on 18/6/13.
//  Copyright © 2018年 alan. All rights reserved.
//

#import "ATRefreshHeader.h"
#define MAS_SHORTHAND_GLOBALS //使用全局宏定义(需要放在.pch文件中)，可以使equalTo- 等效于mas_equalTo
#define MAS_SHORTHAND //使用全局宏定义(需要放在.pch文件中), 可以在调用masonry方法的时候不使用mas_前缀
#import "Masonry.h"

@interface ATRefreshHeader()
@property (weak, nonatomic) UILabel *label;

@property (weak, nonatomic) UIImageView *loadingView;

@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) BOOL isStopAnimation;
@end

@implementation ATRefreshHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"正在获取新的内容";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    [self addSubview:label];
    self.label = label;

    // logo
    UIImageView *loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉刷新"]];
    [self addSubview:loadingView];
    self.loadingView = loadingView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];

    [self.loadingView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.left).offset(-10);
        make.width.height.equalTo(16);
        make.centerY.equalTo(self.label);
    }];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            self.isStopAnimation = YES;
            break;
        case MJRefreshStatePulling:
            self.isStopAnimation = YES;
            break;
        case MJRefreshStateRefreshing:
            self.isStopAnimation = NO;
            [self startAnimation];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(pullingPercent * 0.8 * 180.0f * (M_PI / 180.0f));
    self.loadingView.transform = endAngle;
}
- (void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.loadingView.transform = endAngle;
    } completion:^(BOOL finished) {
        weakSelf.angle += 10;
        if (!weakSelf.isStopAnimation) {
            [self startAnimation];
        }
    }];
}

@end
