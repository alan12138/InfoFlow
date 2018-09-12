//
//  APMyFeed.h
//  InfoFlow
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APMyFeedContentImage;
@interface APMyFeed : NSObject
@property (nonatomic, copy) NSString *headIcon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray<APMyFeedContentImage *> *contentImages;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *zan;

@property (nonatomic, assign) NSUInteger cacheId;
@property (nonatomic, assign, getter=isExpand) BOOL expand;
@end
