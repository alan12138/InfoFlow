#import "APMBProgressHUD.h"

@implementation APMBProgressHUD
/**
 *  单例
 *
 *  @return 返回显示的单例
 */
+ (APMBProgressHUD *)shareHUD
{
    static APMBProgressHUD *_cucuhud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_cucuhud) {
            _cucuhud = [[self alloc]init];
        }
    });
    return _cucuhud;
}
/**
 *  展现提示语句
 *
 *  @param aView  显示的view
 *  @param aTitle 显示的字体
 *  @param mode   常用mode 	MBProgressHUDModeText(纯文字) 	MBProgressHUDModeIndeterminate(打圈|默认)
 */
- (void)showHudOnView:(UIView*)aView WithTitle:(NSString*)aTitle WithMode:(MBProgressHUDMode)mode
{
    [self.hud removeFromSuperview];
    self.hud = [[AUMBProgressHUD alloc]initWithView:aView];
    self.hud.yOffset = -20.0f;
    [aView addSubview:_hud];
    _hud.minSize = CGSizeMake(45.f, 45.f);
    if (!mode) {
        self.hud.mode = MBProgressHUDModeIndeterminate;
    } else {
        self.hud.mode = mode;
        _hud.minSize = CGSizeMake(65.f, 15.f);
    }
    if (aTitle) {
        self.hud.detailsLabelText = aTitle;
    } else {
        self.hud.detailsLabelText = @"";
    }
    self.hud.detailsLabelFont = [UIFont systemFontOfSize:16.0];
    [self.hud show:YES];
}

- (void)showHudOnView:(UIView*)aView text:(NSString *)text progressHUDStatus:(APMBProgressHUDStatus)status
{
    [self.hud removeFromSuperview];
    self.hud = [[AUMBProgressHUD alloc]initWithView:aView];
    [aView addSubview:_hud];
    self.hud.mode = MBProgressHUDModeCustomView;
    [self.hud setMinSize:CGSizeMake(23, 23)];
    self.hud.detailsLabelText = text ? text : @"";
    self.hud.detailsLabelFont = [UIFont systemFontOfSize:16.0];
    self.hud.animationType = MBProgressHUDAnimationZoomOut;
    self.hud.yOffset = -20.0f;
    [self.hud show:YES];
    
    switch (status) {
            
        case APMBProgressHUDStatusFailure: {
            
            self.hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBPUD_hud_error"]];
            self.hud.customView = errorView;
            [self hideAfterTimeIntervals:1.5];
        }
            break;
            
            
        case APMBProgressHUDStatusSuccess: {
            
            self.hud.mode = MBProgressHUDModeCustomView;
            UIImageView *successView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBPUD_hud_success"]];
            self.hud.customView = successView;
            [self hideAfterTimeIntervals:1.5];
        }
            break;
            
        case APMBProgressHUDStatusInfo: {
            
            self.hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBPUD_hud_info"]];
            self.hud.customView = infoView;
            [self hideAfterTimeIntervals:1.5];
        }
            break;
            
        case APMBProgressHUDStatusLoading:{
            self.hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        default:
            break;
    }
}

- (void)showHudOnView:(UIView*)aView WithTitle:(NSString*)aTitle WithMode:(MBProgressHUDMode)mode hideTime:(NSTimeInterval)timeDelay
{
    [self.hud removeFromSuperview];
    self.hud = [[AUMBProgressHUD alloc]initWithView:aView];
    self.hud.yOffset = -20.0f;
    [aView addSubview:_hud];
    _hud.minSize = CGSizeMake(45.f, 45.f);
    if (!mode) {
        self.hud.mode = MBProgressHUDModeIndeterminate;
    } else {
        self.hud.mode = mode;
        _hud.minSize = CGSizeMake(65.f, 15.f);
    }
    if (aTitle) {
        self.hud.detailsLabelText = aTitle;
    } else {
        self.hud.detailsLabelText = @"";
    }
    self.hud.detailsLabelFont = [UIFont systemFontOfSize:16.0];
    [self.hud show:YES];
    if (timeDelay) {
        [self hideAfterTimeIntervals:timeDelay];
    }
}

/**
 *  隐藏提示
 *
 *  @param timeDelay 多少秒后隐藏
 */
- (void)hideAfterTimeIntervals:(NSTimeInterval)timeDelay {
    if (self.hud) {
        [self.hud hide:YES afterDelay:timeDelay];
    }
    if (self.hud.hidden) {
        [self.hud removeFromSuperview];
    }
}
@end
