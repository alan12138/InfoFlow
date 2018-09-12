#import "AUMBProgressHUD.h"

@implementation AUMBProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.margin = 10;
    }
    return self;
}

@end
