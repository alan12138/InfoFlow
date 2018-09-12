#import <Foundation/Foundation.h>
#import "AUMBProgressHUD.h"

typedef NS_ENUM(NSInteger, APMBProgressHUDStatus) {
    APMBProgressHUDStatusFailure = 0,
    APMBProgressHUDStatusSuccess = 1,
    APMBProgressHUDStatusInfo,
    APMBProgressHUDStatusLoading
};

@interface APMBProgressHUD : NSObject

@property (nonatomic) AUMBProgressHUD *hud;

+ (APMBProgressHUD *)shareHUD;

- (void)showHudOnView:(UIView*)aView WithTitle:(NSString*)aTitle WithMode:(MBProgressHUDMode)mode;

- (void)hideAfterTimeIntervals:(NSTimeInterval)timeDelay ;

/**
 *  显示图片 1.5秒后自动隐藏
 */
- (void)showHudOnView:(UIView*)aView text:(NSString *)text progressHUDStatus:(APMBProgressHUDStatus)status;

/**
 菊花-->timeDelay秒后隐藏 传nil 则需要手动隐藏 否则按时间隐藏
 */
- (void)showHudOnView:(UIView*)aView WithTitle:(NSString*)aTitle WithMode:(MBProgressHUDMode)mode hideTime:(NSTimeInterval)timeDelay;
@end
