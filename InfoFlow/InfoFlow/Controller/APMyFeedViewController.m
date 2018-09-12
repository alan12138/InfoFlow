//
//  APMyFeedViewController.m
//  InfoFlow
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 alan. All rights reserved.
//

#import "APMyFeedViewController.h"
#import "APMyFeedTableViewCell.h"
#import "APMyFeed.h"
#import "UITableViewCell+ATCalcCellHeight.h"
#import "MWPhotoBrowser.h"
#import "APMyFeedContentImage.h"
#import "APAddFeedViewController.h"
#import "CommonUtils.h"

#define MAS_SHORTHAND_GLOBALS //使用全局宏定义(需要放在.pch文件中)，可以使equalTo- 等效于mas_equalTo
#define MAS_SHORTHAND //使用全局宏定义(需要放在.pch文件中), 可以在调用masonry方法的时候不使用mas_前缀
#import "Masonry.h"

@interface APMyFeedViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation APMyFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的动态";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];

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
        if (i % 3 == 0) {
            myFeed.content = @"国服在线接单！今日特价！#王者高校争霸赛#";
            APMyFeedContentImage *image1 = [[APMyFeedContentImage alloc] init];
            image1.imageUrlStr = @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=381f7e282b9759ee555066cb82fa434e/0dd7912397dda1449dd17697bfb7d0a20cf4863e.jpg";
            image1.videoUrlStr = @"https://bpic.588ku.com/video_listen/588ku_preview/18/02/09/13/46/03/84/video5a7d359bc470b.mp4";
            myFeed.contentImages = [NSMutableArray arrayWithObjects:image1, nil];
        }
        if (i % 3 == 1) {
            myFeed.content = @"来来来！一起上车！#王者高校争霸赛#";
            APMyFeedContentImage *image1 = [[APMyFeedContentImage alloc] init];
            image1.imageUrlStr = @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=381f7e282b9759ee555066cb82fa434e/0dd7912397dda1449dd17697bfb7d0a20cf4863e.jpg";
            image1.videoUrlStr = @"https://bpic.588ku.com/video_listen/588ku_preview/18/02/09/13/46/03/84/video5a7d359bc470b.mp4";
            APMyFeedContentImage *image2 = [[APMyFeedContentImage alloc] init];
            image2.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image3 = [[APMyFeedContentImage alloc] init];
            image3.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image4 = [[APMyFeedContentImage alloc] init];
            image4.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            myFeed.contentImages = [NSMutableArray arrayWithObjects:image1,image2,image3,image4, nil];
        }
        if (i % 3 == 2) {
            myFeed.content = @"关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？关联对象的五种关联策略有什么区别，有什么坑？";
            APMyFeedContentImage *image1 = [[APMyFeedContentImage alloc] init];
            image1.imageUrlStr = @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=381f7e282b9759ee555066cb82fa434e/0dd7912397dda1449dd17697bfb7d0a20cf4863e.jpg";
            image1.videoUrlStr = @"https://bpic.588ku.com/video_listen/588ku_preview/18/02/09/13/46/03/84/video5a7d359bc470b.mp4";
            APMyFeedContentImage *image2 = [[APMyFeedContentImage alloc] init];
            image2.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image3 = [[APMyFeedContentImage alloc] init];
            image3.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image4 = [[APMyFeedContentImage alloc] init];
            image4.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image5 = [[APMyFeedContentImage alloc] init];
            image5.imageUrlStr = @"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=381f7e282b9759ee555066cb82fa434e/0dd7912397dda1449dd17697bfb7d0a20cf4863e.jpg";
            image5.videoUrlStr = @"https://bpic.588ku.com/video_listen/588ku_preview/18/02/09/13/46/03/84/video5a7d359bc470b.mp4";
            APMyFeedContentImage *image6 = [[APMyFeedContentImage alloc] init];
            image6.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image7 = [[APMyFeedContentImage alloc] init];
            image7.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            APMyFeedContentImage *image8 = [[APMyFeedContentImage alloc] init];
            image8.imageUrlStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2118739199,3378602431&fm=26&gp=0.jpg";
            myFeed.contentImages = [NSMutableArray arrayWithObjects:image1,image2,image3,image4,image5,image6,image7,image8, nil];
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
        make.top.equalTo(self.view).offset([CommonUtils iPhoneX] ? 88 : 64);
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
    __weak typeof(self) weakSelf = self;
    cell.previewPhotosBlock = ^(NSMutableArray *icons, int i) {
        NSMutableArray *photos = [NSMutableArray array];
        weakSelf.photos = photos;
        for (APMyFeedContentImage *myFeedContentImage in icons) {
            if(myFeedContentImage.videoUrlStr != nil) {
                MWPhoto *video = [MWPhoto photoWithURL:[NSURL URLWithString:myFeedContentImage.imageUrlStr]];
                video.videoURL = [[NSURL alloc] initWithString:myFeedContentImage.videoUrlStr];
                [photos addObject:video];
            } else {
                [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:myFeedContentImage.imageUrlStr]]];
            }
        }
//        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
//        MWPhoto *photo, *thumb;
//        self.thumbs = thumbs;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = YES;
        browser.autoPlayOnAppear = NO;
        
        browser.displayActionButton =NO;//分享按钮,默认是
        browser.displayNavArrows = NO;//左右分页切换,默认否<屏幕下方的左右角标>
        [browser setCurrentPhotoIndex:i];

        browser.customImageSelectedIconName = @"ImageSelected.png";
        browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";

        [weakSelf.navigationController pushViewController:browser animated:YES];
        
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
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


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - button
- (void)rightBarButtonItemClick {
    APAddFeedViewController *vc = [[APAddFeedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
