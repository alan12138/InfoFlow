//
//  UITableViewCell+ATCalcCellHeight.h
//  rowHeightTest
//
//  Created by 谷士雄 on 16/9/8.
//  Copyright © 2016年 alan. All rights reserved.
//

//使用注意点：自定义cell的Masonry要放在cell的初始化方法中
#import <UIKit/UIKit.h>

 //为cell传递数据block
typedef void(^ATCellModelBlock)(UITableViewCell *sourceCell);

//缓存行高block
typedef NSDictionary *(^ATCacheHeight)();

//行高模型的唯一标识
FOUNDATION_EXTERN NSString *const ATCacheUniqueKey;
//对于同一个model，如果有不同状态，而且不同状态下高度不一样，那么也需要指定
FOUNDATION_EXTERN NSString *const ATCacheStateKey;
//用于指定更新某种状态的缓存，比如当评论时，增加了一条评论，此时该状态的高度若已经缓存过，则需要指定来更新缓存
FOUNDATION_EXTERN NSString *const ATRecalcForStateKey;



@interface UITableViewCell (ATCalcCellHeight)

//表示设置cell中最后一个自添加view距离cell底部的距离
@property (nonatomic, assign) CGFloat lastViewToBottomDis;

/**
 *  计算行高的类方法
 *
 *  @param tableView  需要计算行高的tableView
 *  @param transModel 在这里传入模型数据，利用模型数据计算高度
 *
 *  @return 返回行高
 */
+ (CGFloat)cellHeightWithTableView:(UITableView *)tableView transModel:(ATCellModelBlock)transModel;

/**
 *  计算行高的类方法（有缓存）
 *
 *  @param tableView  需要计算行高的tableView
 *  @param transModel 在这里传入模型数据，利用模型数据计算高度
 *  @param cache      缓存操作
 *
 *  @return 返回行高
 */
+ (CGFloat)cellHeightWithTableView:(UITableView *)tableView transModel:(ATCellModelBlock)transModel cache:(ATCacheHeight)cache;
@end
