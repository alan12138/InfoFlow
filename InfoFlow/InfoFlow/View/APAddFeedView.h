//
//  APAddFeedView.h
//  InfoFlow
//
//  Created by mac on 2018/9/11.
//  Copyright © 2018年 alan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakePhotoBlock)(UICollectionView *collectionView,NSIndexPath *colIndexPath);
typedef void(^PreviewPhotoBlock)(UICollectionView *collectionView,NSIndexPath *colIndexPath);

@class APAddFeedViewRect;
@interface APAddFeedView : UIView
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) NSInteger maxCountTF;
@property (nonatomic, copy) TakePhotoBlock takePhotoBlock;
@property (nonatomic, copy) PreviewPhotoBlock previewPhotoBlock;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSString *textPlaceHolder;
@property (nonatomic, assign) NSUInteger maxTextCount;
@property (nonatomic, strong) APAddFeedViewRect *rect;

@end

