//
//  APMyFeedViewController.m
//  ArrangeApp
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 xhx. All rights reserved.
//

#import "APMyFeedViewController.h"
#import "APMyFeedTableViewCell.h"
#import "APMyFeed.h"
#import "UITableViewCell+ATCalcCellHeight.h"
#import "HZPhotoBrowser.h"
#define MAS_SHORTHAND_GLOBALS //使用全局宏定义(需要放在.pch文件中)，可以使equalTo- 等效于mas_equalTo
#define MAS_SHORTHAND //使用全局宏定义(需要放在.pch文件中), 可以在调用masonry方法的时候不使用mas_前缀
#import "Masonry.h"

@interface APMyFeedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *feeds;
@end

@implementation APMyFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setNaviTitle:@"我的动态"];
//    [self setRightButtonWithImageName:@"发现发布按钮"];
    [self setupUI];
    [self requestData];
    
}
- (void)requestData {
    self.feeds = [NSMutableArray array];
    for (int i = 0; i < 13; i++) {
        APMyFeed *myFeed = [[APMyFeed alloc] init];
        myFeed.headIcon = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
        myFeed.name = @"王者小能手";
        myFeed.sex = @"性别女";
        myFeed.level = @"等级1";
        if (i % 3 == 0) {
            myFeed.content = @"国服在线接单！今日特价！#王者高校争霸赛#";
            myFeed.contentImages = [NSMutableArray array];
        }
        if (i % 3 == 1) {
            myFeed.content = @"来来来！一起上车！#王者高校争霸赛#";
            myFeed.contentImages = [NSMutableArray arrayWithObjects:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg", nil];
        }
        if (i % 3 == 2) {
            myFeed.content = @"关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？";
                myFeed.contentImages = [NSMutableArray arrayWithObjects:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg",@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg", nil];
        }
        
        myFeed.time = @"5分钟前";
        myFeed.location = @"南京·麒麟国际企业研发园";
        myFeed.comment = @"12";
        myFeed.zan = @"10";
        myFeed.expand = NO;
        [self.feeds addObject:myFeed];
        [self.mainTableView reloadData];
    }
}
- (void)setupUI {
    UITableView *mainTableView = [[UITableView alloc] init];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
    [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(88);
    }];
}
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    APMyFeedTableViewCell *cell = [APMyFeedTableViewCell cellWithTableView:tableView];

    APMyFeed *myFeed = self.feeds[indexPath.row];
    cell.myFeed = myFeed;
    cell.expandBlock = ^(BOOL isExpand) {
        myFeed.expand = isExpand;
        [tableView reloadRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    };
    cell.previewPhotosBlock = ^(NSMutableArray *icons, int i) {
        HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
        browser.isFullWidthForLandScape = YES;
        browser.isNeedLandscape = YES;
        browser.currentImageIndex = i;
        browser.imageArray = icons;
        [browser show];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    APMyFeed *myFeed = self.feeds[indexPath.row];

    myFeed.cacheId = indexPath.row + 1;
   
    NSString *stateKey = nil;
    if (myFeed.isExpand) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }
    
    return [APMyFeedTableViewCell cellHeightWithTableView:tableView transModel:^(UITableViewCell *sourceCell) {
        APMyFeedTableViewCell *cell = (APMyFeedTableViewCell *)sourceCell;
        // 配置数据
        cell.myFeed = myFeed;
        
    } cache:^NSDictionary *{
        return @{ATCacheUniqueKey: [NSString stringWithFormat:@"%ld", myFeed.cacheId],
                 ATCacheStateKey : stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 ATRecalcForStateKey : @(YES) // 标识不用重新更新
                 };
        
    }];
    
}
@end
