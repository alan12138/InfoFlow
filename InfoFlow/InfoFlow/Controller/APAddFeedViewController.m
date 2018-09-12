//
//  APAddFeedViewController.m
//  InfoFlow
//
//  Created by mac on 2018/8/6.
//  Copyright © 2018年 alan. All rights reserved.
//

#import "APAddFeedViewController.h"
#import "APAddFeedView.h"
#import "APMBProgressHUD.h"
#import "CommonUtils.h"
#import "TZVideoPlayerController.h"
#import "TZImagePickerController.h"
#import "APAddFeedViewRect.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define MAS_SHORTHAND_GLOBALS //使用全局宏定义(需要放在.pch文件中)，可以使equalTo- 等效于mas_equalTo
#define MAS_SHORTHAND //使用全局宏定义(需要放在.pch文件中), 可以在调用masonry方法的时候不使用mas_前缀
#import "Masonry.h"

@interface APAddFeedViewController()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) APAddFeedView *addFeedView;
@property (nonatomic, strong) APAddFeedViewRect *addFeedViewRect;
@property (nonatomic, weak) UIView *locationView;
@property (nonatomic, weak) UILabel *locationLabel;
@property (nonatomic, weak) UIImageView *locationImageView;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) NSInteger maxCountTF;
@property (nonatomic, assign) NSInteger columnNumberTF;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation APAddFeedViewController
- (APAddFeedViewRect *)addFeedViewRect {
    if (!_addFeedViewRect) {
        _addFeedViewRect = [[APAddFeedViewRect alloc] init];
        _addFeedViewRect.textViewTop = 16;
        _addFeedViewRect.textViewLeft = 12;
        _addFeedViewRect.textViewRight = 12;
        _addFeedViewRect.textViewHeight = 95;
        _addFeedViewRect.textViewCollectionMargin = 10;
        _addFeedViewRect.collectionLeft = 9;
        _addFeedViewRect.collectionRight = 9;
        _addFeedViewRect.collectionHeight = 100;
        _addFeedViewRect.collectionItemWH = 80;
        _addFeedViewRect.collectionMargin = 10;
    }
    return _addFeedViewRect;
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}
- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    [self setupUI];
}
- (void)setupUI {
    APAddFeedView *addFeedView = [[APAddFeedView alloc] init];
    self.addFeedView = addFeedView;
    self.maxCountTF = 9;
    addFeedView.maxCountTF = self.maxCountTF;
    __weak typeof(self) weakSelf = self;
    addFeedView.takePhotoBlock = ^(UICollectionView *collectionView,NSIndexPath *colIndexPath) {
        weakSelf.collectionView = collectionView;
        NSString *takePhotoTitle = @"相机";
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf takePhoto];
        }];
        [alertVc addAction:takePhotoAction];
        UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf pushTZImagePickerController];
        }];
        [alertVc addAction:imagePickerAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:colIndexPath];
        if (popover) {
            popover.sourceView = cell;
            popover.sourceRect = cell.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [weakSelf presentViewController:alertVc animated:YES completion:nil];
    };
    addFeedView.previewPhotoBlock = ^(UICollectionView *collectionView,NSIndexPath *colIndexPath) { //预览
        weakSelf.collectionView = collectionView;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:weakSelf.selectedAssets selectedPhotos:weakSelf.selectedPhotos index:colIndexPath.item];
        imagePickerVc.maxImagesCount = weakSelf.maxCountTF;
        imagePickerVc.showSelectedIndex = YES;
        imagePickerVc.isSelectOriginalPhoto = weakSelf.isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            weakSelf.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            weakSelf.selectedAssets = [NSMutableArray arrayWithArray:assets];
            weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;

            weakSelf.addFeedView.selectedAssets = weakSelf.selectedAssets;
            weakSelf.addFeedView.selectedPhotos = weakSelf.selectedPhotos;
            [weakSelf.addFeedView.collectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    };
    addFeedView.textPlaceHolder = @"说说自己的故事吧";
    addFeedView.maxTextCount = 500;
    [addFeedView setRect:self.addFeedViewRect];
    [self.view addSubview:addFeedView];
    [addFeedView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset([CommonUtils iPhoneX] ? 88 : 64);
        make.height.equalTo(221);
    }];
    
    UIView *locationView = [[UIView alloc] init];
    locationView.userInteractionEnabled = YES;
    UITapGestureRecognizer *locationViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap)];
    [locationView addGestureRecognizer:locationViewTap];
    [self.view addSubview:locationView];
    self.locationView = locationView;
    [locationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(addFeedView.bottom).offset(10);
        make.height.equalTo(30);
    }];
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = [UIImage imageNamed:@"添加我的位置"];
    [locationView addSubview:locationImageView];
    self.locationImageView = locationImageView;
    [locationImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationView).offset(9);
        make.top.equalTo(locationView);
        make.height.equalTo(19);
        make.width.equalTo(15);
    }];
    
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.text = @"添加我的位置";
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    [self.view addSubview:locationLabel];
    self.locationLabel = locationLabel;
    [locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.right).offset(10);
        make.centerY.equalTo(locationImageView);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"我的箭头"];
    [locationView addSubview:arrowImageView];
    [arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(locationView).offset(-9);
        make.centerY.equalTo(locationImageView);
        make.width.equalTo(6);
        make.height.equalTo(11);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [locationView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationView);
        make.right.equalTo(locationView);
        make.bottom.equalTo(locationView);
        make.height.equalTo(0.5);
    }];
}

#pragma mark - UIImagePickerController
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
    }
    return _imagePickerVc;
}
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel Action");
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        //防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Cancel Action");
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeMovie];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)pushTZImagePickerController {
    if (self.maxCountTF <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF columnNumber:self.columnNumberTF delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (self.maxCountTF > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = YES;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.allowPickingMultipleVideo = YES; // 是否可以多选视频
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.bounds.size.width - 2 * left;
    NSInteger top = (self.view.bounds.size.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    self.addFeedView.selectedAssets = _selectedAssets;
    self.addFeedView.selectedPhotos = _selectedPhotos;
    
    [self.addFeedView.collectionView reloadData];

}

// 如果用户选择了一个视频，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [_collectionView reloadData];
}

// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (NO) { // 允许裁剪,去裁剪
                            //                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                            //                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            //                            }];
                            //                            imagePicker.needCircleCrop = NO;
                            //                            imagePicker.circleCropRadius = 100;
                            //                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                if (!error) {
                    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO needFetchAssets:NO completion:^(TZAlbumModel *model) {
                        [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:YES allowPickingImage:NO completion:^(NSArray<TZAssetModel *> *models) {
                            [tzImagePickerVc hideProgressHUD];
                            TZAssetModel *assetModel = [models firstObject];
                            if (tzImagePickerVc.sortAscendingByModificationDate) {
                                assetModel = [models lastObject];
                            }
                            [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                                if (!isDegraded && photo) {
                                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                                }
                            }];
                        }];
                    }];
                } else {
                    [tzImagePickerVc hideProgressHUD];
                }
            }];
        }
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [self.selectedAssets addObject:asset];
    [self.selectedPhotos addObject:image];

    self.addFeedView.selectedAssets = self.selectedAssets;
    self.addFeedView.selectedPhotos = self.selectedPhotos;
    [self.addFeedView.collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}

- (void)locationViewTap {
    __weak typeof(self) weakSelf = self;
    [[APMBProgressHUD shareHUD] showHudOnView:self.view WithTitle:@"定位中" WithMode:MBProgressHUDModeIndeterminate hideTime:5];
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
        CLLocation *currentLocation = strongSelf.location;
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [[APMBProgressHUD shareHUD] hideAfterTimeIntervals:1];
        //地理反编码
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count >0) {
                CLPlacemark *placeMark = placemarks[0];
                NSString *currentCity = placeMark.locality;
                if (!currentCity) {
                    currentCity = @"无法定位当前城市";
                }
                self.locationLabel.text = [NSString stringWithFormat:@"%@.%@",currentCity,placeMark.name];
                self.locationLabel.textColor = [UIColor colorWithRed:118/255.0 green:118/255.0 blue:253/255.0 alpha:1];
                self.locationImageView.image = [UIImage imageNamed:@"已添加我的位置"];
            } else {
                [[APMBProgressHUD shareHUD] showHudOnView:self.view WithTitle:@"定位失败" WithMode:MBProgressHUDModeText hideTime:1];
            }
        }];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
        [[APMBProgressHUD shareHUD] hideAfterTimeIntervals:1];
        [[APMBProgressHUD shareHUD] showHudOnView:self.view WithTitle:@"定位失败" WithMode:MBProgressHUDModeText hideTime:1];
    }];
}
#pragma mark - button
- (void)rightBarButtonItemClick {
    
}
@end
