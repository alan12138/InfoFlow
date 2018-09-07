//
//  UITableView+ATHeightCache.h
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/8.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ATHeightCache)

//用于存储计算行高的cell的字典，之所以用字典是为了节约内存，每次只需要一个cell用来计算
@property (nonatomic, strong, readonly) NSMutableDictionary *calcCellDict;

//缓存行高字典
@property (nonatomic, strong, readonly) NSMutableDictionary *cacheCellHeightDict;
@end
