//
//  UITableViewCell+ATCalcCellHeight.m
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/8.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "UITableViewCell+ATCalcCellHeight.h"
#import <objc/message.h>
#import "UITableView+ATHeightCache.h"

NSString *const ATCacheUniqueKey = @"ATCacheUniqueKey";
NSString *const ATCacheStateKey = @"ATCacheStateKey";
NSString *const ATRecalcForStateKey = @"ATRecalculateForStateKey";

const void * ATLastViewToBottomDisKey = @"ATLastViewToBottomDis";


@implementation UITableViewCell (ATCalcCellHeight)

//设置关联属性
- (void)setLastViewToBottomDis:(CGFloat)lastViewToBottomDis {
    objc_setAssociatedObject(self, ATLastViewToBottomDisKey, @(lastViewToBottomDis), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)lastViewToBottomDis {
    NSNumber *distance = objc_getAssociatedObject(self, ATLastViewToBottomDisKey);
    if ([distance respondsToSelector:@selector(floatValue)]) {
        return [distance floatValue];
    }
    return 0;
}

//计算行高外部调用方法（无缓存）
+ (CGFloat)cellHeightWithTableView:(UITableView *)tableView transModel:(ATCellModelBlock)transModel {
    UITableViewCell *cell = [tableView.calcCellDict objectForKey:[[self class] description]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [tableView.calcCellDict setObject:cell forKey:[[self class] description]];
    }
    if (transModel) {
        transModel(cell);
    }
    
    return [cell heightForTableView:tableView];
}

//计算行高外部调用方法（有缓存）
+ (CGFloat)cellHeightWithTableView:(UITableView *)tableView transModel:(ATCellModelBlock)transModel cache:(ATCacheHeight)cache {
    if (cache) {
        NSDictionary *cacheKeys = cache();
        NSString *key = cacheKeys[ATCacheUniqueKey];
        NSString *stateKey = cacheKeys[ATCacheStateKey];
        NSString *shouldUpdate = cacheKeys[ATRecalcForStateKey];
        
        NSMutableDictionary *stateDict = tableView.cacheCellHeightDict[key];
        NSString *cacheHeight = stateDict[stateKey];
        
        if (tableView.cacheCellHeightDict.count == 0
            || shouldUpdate.boolValue
            || cacheHeight == nil) {
            CGFloat height = [self cellHeightWithTableView:tableView transModel:transModel];
            
            if (stateDict == nil) {
                stateDict = [[NSMutableDictionary alloc] init];
                tableView.cacheCellHeightDict[key] = stateDict;
            }
            
            if (stateKey) {
                [stateDict setObject:[NSString stringWithFormat:@"%lf", height] forKey:stateKey];
            }
            
            
            return height;
        } else if (tableView.cacheCellHeightDict.count != 0
                   && cacheHeight != nil
                   && cacheHeight.integerValue != 0) {
            return cacheHeight.floatValue;
        }
    }

    return [self cellHeightWithTableView:tableView transModel:transModel];
}

#pragma mark -m 计算行高的方法
- (CGFloat)heightForTableView:(UITableView *)tableView {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGFloat rowHeight = 0;
    
    for (UIView *bottomView in self.contentView.subviews) {
        if (rowHeight < CGRectGetMaxY(bottomView.frame)) {
            rowHeight = CGRectGetMaxY(bottomView.frame);
        }
    }
    
    rowHeight += self.lastViewToBottomDis;
    
    return rowHeight;

}
@end
