//
//  APMyFeedTableViewCell.m
//  ArrangeApp
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 xhx. All rights reserved.
//

#import "APMyFeedTableViewCell.h"
#import "UIButton+webCache.h"
#import "APMyFeed.h"
#define MAS_SHORTHAND_GLOBALS //使用全局宏定义(需要放在.pch文件中)，可以使equalTo- 等效于mas_equalTo
#define MAS_SHORTHAND //使用全局宏定义(需要放在.pch文件中), 可以在调用masonry方法的时候不使用mas_前缀
#import "Masonry.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define CONTENT_BTN_TAG_CONST 10000

@interface APMyFeedTableViewCell()
@property (nonatomic, weak) UIButton *headIconBtn;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *sexIconView;
@property (nonatomic, weak) UIImageView *levelIconView;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, strong) NSMutableArray *contentImageBtns;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *locationLabel;
@property (nonatomic, weak) UILabel *zanLabel;
@property (nonatomic, weak) UILabel *commentLabel;

@property (nonatomic, weak) UIButton *expandBtn;
@property (nonatomic, assign) BOOL isExpandedNow;
@end

@implementation APMyFeedTableViewCell

+ (APMyFeedTableViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"APMyFeedTableViewCell";
    APMyFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == NULL) {
        cell = [[APMyFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (void)setMyFeed:(APMyFeed *)myFeed {
    _myFeed = myFeed;
    [self.headIconBtn sd_setImageWithURL:[NSURL URLWithString:myFeed.headIcon] forState:UIControlStateNormal];
    self.nameLabel.text = myFeed.name;
    [self.sexIconView setImage:[UIImage imageNamed:myFeed.sex]];
    [self.levelIconView setImage:[UIImage imageNamed:myFeed.level]];
    self.contentLabel.text = myFeed.content;
    self.timeLabel.text = myFeed.time;
    self.locationLabel.text = myFeed.location;
    self.zanLabel.text = myFeed.zan;
    self.commentLabel.text = myFeed.comment;
    
    if ([self calculateRowHeightWithContent:myFeed.content] < 110) {
        self.expandBtn.hidden = YES;
        [self.expandBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.top.equalTo(self.contentLabel.bottom);
            make.width.equalTo(30);
            make.height.equalTo(0.01);
        }];
    } else {
        self.expandBtn.hidden = NO;
        [self.expandBtn remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.top.equalTo(self.contentLabel.bottom).offset(10);
            make.width.equalTo(30);
            make.height.equalTo(20);
        }];
    }

    if (myFeed.isExpand != self.isExpandedNow) {
        self.isExpandedNow = myFeed.isExpand;
        if (self.isExpandedNow) {
            [self.contentLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headIconBtn);
                make.right.equalTo(self).offset(-16);
                make.top.equalTo(self.headIconBtn.bottom).offset(10);
            }];
            [self.expandBtn setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_lessThanOrEqualTo(110);
            }];
            [self.expandBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }
    for (UIButton *btn in self.contentImageBtns) {
        [btn removeFromSuperview];
    }
    [self.contentImageBtns removeAllObjects];
    if (myFeed.contentImages.count == 0) {
        [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.expandBtn.bottom).offset(10);
        }];
    } else if (myFeed.contentImages.count == 1) {
        UIButton *contentImageBtn = [[UIButton alloc] init];
        [self.contentView addSubview:contentImageBtn];
        [contentImageBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(11);
            make.top.equalTo(self.expandBtn.bottom).offset(10);
            make.width.equalTo(250);
            make.height.equalTo(150);
        }];
        [self.contentImageBtns addObject:contentImageBtn];
    } else if (myFeed.contentImages.count == 2 || myFeed.contentImages.count == 3) {
        for (int i = 0; i < myFeed.contentImages.count; i++) {
            UIButton *contentImageBtn = [[UIButton alloc] init];
            [self.contentView addSubview:contentImageBtn];
            [contentImageBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(11 + i * (10 + 90));
                make.top.equalTo(self.expandBtn.bottom).offset(10);
                make.width.equalTo(90);
                make.height.equalTo(90);
            }];
            [self.contentImageBtns addObject:contentImageBtn];
        }
    } else if (myFeed.contentImages.count == 4) {
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                UIButton *contentImageBtn = [[UIButton alloc] init];
                [self.contentView addSubview:contentImageBtn];
                [contentImageBtn makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(11 + j * (10 + 90));
                    make.top.equalTo(self.expandBtn.bottom).offset(10 + i * (10 + 90));
                    make.width.equalTo(90);
                    make.height.equalTo(90);
                }];
                [self.contentImageBtns addObject:contentImageBtn];
            }
        }
    } else if (myFeed.contentImages.count == 5 || myFeed.contentImages.count == 6 || myFeed.contentImages.count == 7 || myFeed.contentImages.count == 8 || myFeed.contentImages.count == 9) {
        for (int i = 0; i < myFeed.contentImages.count; i++) {
                UIButton *contentImageBtn = [[UIButton alloc] init];
                [self.contentView addSubview:contentImageBtn];
                [contentImageBtn makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(11 + (i % 3) * (10 + 90));
                    make.top.equalTo(self.expandBtn.bottom).offset(10 + (i / 3) * (10 + 90));
                    make.width.equalTo(90);
                    make.height.equalTo(90);
                }];
                [self.contentImageBtns addObject:contentImageBtn];
        }
    }

    if (self.contentImageBtns.count > 0) {
        for (int i = 0; i < self.contentImageBtns.count; i++) {
            UIButton *btn = self.contentImageBtns[i];
            btn.tag = CONTENT_BTN_TAG_CONST + i;
            [btn addTarget:self action:@selector(contentImageClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn sd_setImageWithURL:[NSURL URLWithString:myFeed.contentImages[i]] forState:UIControlStateNormal];
            if (i == self.contentImageBtns.count - 1) {
                [self.timeLabel remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(10);
                    make.top.equalTo(btn.bottom).offset(10);
                }];
            }
        }
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        self.contentImageBtns = [NSMutableArray array];
        self.isExpandedNow = YES;
    }
    return self;
}
- (void)setupUI {
    UIButton *headIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
    //告诉layer将位于它之下的layer都遮盖住
    headIconBtn.layer.masksToBounds = YES;
    //设置layer的圆角,刚好是自身宽度的一半，这样就成了圆形
    headIconBtn.layer.cornerRadius = headIconBtn.bounds.size.width * 0.5;
    [self.contentView addSubview:headIconBtn];
    self.headIconBtn = headIconBtn;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headIconBtn.right).offset(11);
        make.top.equalTo(self).offset(17);
    }];
    
    UIImageView *sexIconView = [[UIImageView alloc] init];
    [self.contentView addSubview:sexIconView];
    self.sexIconView = sexIconView;
    [sexIconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headIconBtn.right).offset(9);
        make.top.equalTo(nameLabel.bottom).offset(6);
        make.width.height.equalTo(12);
    }];
    
    UIImageView *levelIconView = [[UIImageView alloc] init];
    [self.contentView addSubview:levelIconView];
    self.levelIconView = levelIconView;
    [levelIconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexIconView.right).offset(5);
        make.centerY.equalTo(sexIconView);
        make.width.equalTo(37);
        make.height.equalTo(12);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headIconBtn);
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(headIconBtn.bottom).offset(10);
    }];
    
    UIButton *expandBtn = [[UIButton alloc] init];
    [expandBtn setTitle:@"全文" forState:UIControlStateNormal];
    expandBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [expandBtn setTitleColor:[UIColor colorWithRed:118/255.0 green:118/255.0 blue:253/255.0 alpha:1] forState:UIControlStateNormal];
    [expandBtn addTarget:self action:@selector(expandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:expandBtn];
    self.expandBtn = expandBtn;
    [expandBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel);
        make.top.equalTo(contentLabel.bottom).offset(10);
        make.width.equalTo(30);
        make.height.equalTo(20);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(expandBtn.bottom).offset(10);
    }];
    
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.font = [UIFont systemFontOfSize:12];
    locationLabel.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:253/255.0 alpha:1];
    [self.contentView addSubview:locationLabel];
    self.locationLabel = locationLabel;
    [locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(timeLabel.right).offset(10);
    }];
    
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setImage:[UIImage imageNamed:@"删除动态"] forState:UIControlStateNormal];
    [self.contentView addSubview:delBtn];
    [delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(timeLabel.bottom).offset(15);
        make.width.equalTo(16);
        make.height.equalTo(18);
    }];
    
    UILabel *zanLabel = [[UILabel alloc] init];
    zanLabel.font = [UIFont systemFontOfSize:12];
    zanLabel.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    [self.contentView addSubview:zanLabel];
    self.zanLabel = zanLabel;
    [zanLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(delBtn);
    }];
    UIButton *zanBtn = [[UIButton alloc] init];
    [zanBtn setImage:[UIImage imageNamed:@"我的动态点赞"] forState:UIControlStateNormal];
    [self.contentView addSubview:zanBtn];
    [zanBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zanLabel.left).offset(-5);
        make.centerY.equalTo(zanLabel);
    }];
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.font = [UIFont systemFontOfSize:12];
    commentLabel.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1];
    [self.contentView addSubview:commentLabel];
    self.commentLabel = commentLabel;
    [commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zanBtn.left).offset(-15);
        make.centerY.equalTo(zanBtn);
    }];
    UIButton *commentBtn = [[UIButton alloc] init];
    [commentBtn setImage:[UIImage imageNamed:@"我的动态评论"] forState:UIControlStateNormal];
    [self.contentView addSubview:commentBtn];
    [commentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commentLabel.left).offset(-5);
        make.centerY.equalTo(commentLabel);
    }];
    
    UIView *seperatorView = [[UIView alloc] init];
    seperatorView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.contentView addSubview:seperatorView];
    [seperatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(15);
        make.top.equalTo(delBtn.bottom).offset(10);
    }];
    
    // 应该始终要加上这一句
    // 不然在6/6plus上就不准确了
    self.contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 26;
}

- (void)expandBtnClick:(UIButton *)btn {
    if (self.expandBlock) {
        self.expandBlock(!self.isExpandedNow);
    }
}

- (CGFloat)calculateRowHeightWithContent:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 26, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

- (void)contentImageClick:(UIButton *)btn {
    if (self.previewPhotosBlock) {
        self.previewPhotosBlock(self.myFeed.contentImages,(int)(btn.tag - CONTENT_BTN_TAG_CONST));
    }
    
}
@end
