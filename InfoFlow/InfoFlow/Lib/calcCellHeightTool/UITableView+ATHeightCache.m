//
//  UITableView+ATHeightCache.m
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/8.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "UITableView+ATHeightCache.h"
#import <objc/message.h>

const void * ATCalcCellDictKey = "ATCalcCellDictKey";
const void * ATCacheCellHeightDictKey = "ATCacheCellHeightDictKey";

@implementation UITableView (ATHeightCache)
- (NSMutableDictionary *)calcCellDict {
    NSMutableDictionary *cellDict = objc_getAssociatedObject(self, ATCalcCellDictKey);
    
    if (cellDict == nil) {
        cellDict = [[NSMutableDictionary alloc] init];
        
        objc_setAssociatedObject(self,
                                 ATCalcCellDictKey,
                                 cellDict,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return cellDict;
}
- (NSMutableDictionary *)cacheCellHeightDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, ATCacheCellHeightDictKey);
    
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        
        objc_setAssociatedObject(self,
                                 ATCacheCellHeightDictKey,
                                 dict,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dict;
}
@end
