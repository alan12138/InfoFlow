//
//  CommonUtils.m
//  InfoFlow
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils
+ (BOOL)iPhoneX
{
    return CGSizeEqualToSize((CGSize){375,812}, [UIScreen mainScreen].bounds.size);
}
@end
