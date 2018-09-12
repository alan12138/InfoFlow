//
//  APAddFeedView.m
//  InfoFlow
//
//  Created by mac on 2018/9/11.
//  Copyright © 2018年 alan. All rights reserved.
//

#import "APAddFeedView.h"
#import "FSTextView.h"
#import "TZTestCell.h"
#import "APAddFeedViewRect.h"
#define MAS_SHORTHAND_GLOBALS //使用全局宏定义(需要放在.pch文件中)，可以使equalTo- 等效于mas_equalTo
#define MAS_SHORTHAND //使用全局宏定义(需要放在.pch文件中), 可以在调用masonry方法的时候不使用mas_前缀
#import "Masonry.h"

@interface APAddFeedView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) FSTextView *textView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation APAddFeedView
- (void)setTextPlaceHolder:(NSString *)textPlaceHolder {
    _textPlaceHolder = textPlaceHolder;
    self.textView.placeholder = textPlaceHolder;
}
- (void)setMaxTextCount:(NSUInteger)maxTextCount {
    _maxTextCount = maxTextCount;
    self.textView.maxLength = maxTextCount;
}
- (void)setRect:(APAddFeedViewRect *)rect {
    _rect = rect;
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(rect.textViewLeft);
        make.top.equalTo(self).offset(rect.textViewTop);
        make.height.equalTo(rect.textViewHeight);
        make.right.equalTo(self).offset(-rect.textViewRight);
    }];
    
    _layout.minimumInteritemSpacing = rect.collectionMargin;
    _layout.minimumLineSpacing = rect.collectionMargin;
    _layout.itemSize = CGSizeMake(rect.collectionItemWH, rect.collectionItemWH);
    [_collectionView setCollectionViewLayout:_layout];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(rect.collectionLeft);
        make.top.equalTo(self.textView.bottom).offset(rect.textViewCollectionMargin);
        make.height.equalTo(rect.collectionHeight);
        make.right.equalTo(self).offset(-rect.collectionRight);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    FSTextView *textView = [FSTextView textView];
    textView.placeholderColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    [self addSubview:textView];
    self.textView = textView;
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= self.maxCountTF) {
        return _selectedPhotos.count;
    }
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"addImage"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.item];
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        if (self.takePhotoBlock) {
            self.takePhotoBlock(collectionView,indexPath);
        }
    } else { //预览照片或者视频
        if (self.previewPhotoBlock) {
            self.previewPhotoBlock(collectionView,indexPath);
        }
    }
}
#pragma mark - Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}
@end
