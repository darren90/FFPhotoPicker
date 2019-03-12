//
//  TFPickPhotoViewController.m
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import "TFPickPhotoViewController.h"
#import "TFPickPhotoCell.h"
#import "TFAssetLibraryUtils.h"
#import <Photos/Photos.h>
#import "TFPickPhotoModel.h"

@interface TFPickPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *rightBarButton;

@property (nonatomic, strong) NSArray<TFPickPhotoModel *> *albums;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, strong) NSMutableArray<TFPickPhotoModel *> *selectedAlbums;

@end

@implementation TFPickPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.titleText.length ? self.titleText : @"选择图片";
    titleLabel.textColor = self.titleColor ? self.titleColor : [UIColor blackColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBarButton setImage: self.leftBtnImage ? self.leftBtnImage : [UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton  sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBarButton = rightBarButton;
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBarButton setTitleColor: self.rightBtnColor ? self.rightBtnColor : [UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton setTitle: self.rightBtnText.length > 0 ? self.rightBtnText : @"完成" forState:UIControlStateNormal];
    [rightBarButton sizeToFit];
    [rightBarButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    [self addCollection];
    
    if (self.selectAlbums.count) {
        self.selectedAlbums = [NSMutableArray arrayWithArray:self.selectAlbums];
    } else {
        self.selectedAlbums = [NSMutableArray array];
    }
    
    [TFAssetLibraryUtils requestAuthorizationWithCompletionBlock:^(BOOL result) {
        if (result) {
            [self getAlbums];
        } else {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"请允许%@访问您的手机相册", [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"]] preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    }];
}

- (void)addCollection {
    CGFloat balanceValue = 100;
    NSInteger viewCount = [UIScreen mainScreen].bounds.size.width / balanceValue / [UIScreen mainScreen].scale;
    viewCount = viewCount < 3 ? 3 : viewCount;
    CGFloat margin = 15;
    self.cellWidth = ([UIScreen mainScreen].bounds.size.width -( viewCount - 1 ) * margin - 30) / viewCount;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.cellWidth, self.cellWidth );
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout: layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[TFPickPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([TFPickPhotoCell class])];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.collectionView];
}

- (void)closeAction {
    !self.didPickerCloseBlock ?: self.didPickerCloseBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction {
    NSMutableArray *photos = @[].mutableCopy;
    for (TFPickPhotoModel *obj in self.albums) {
        if (obj.isSelect) {
            [photos addObject:obj];
        }
    }
 
    NSArray *selectPhotos = photos.copy;
    
    !self.didPickerFinishBlock ?: self.didPickerFinishBlock(selectPhotos);
    [self closeAction];
}

- (void)getAlbums {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [TFAssetLibraryUtils fetchCollectionsWithCompletionBlock:^(NSArray *albums) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albums = albums;
                
                if (self.selectedAlbums.count > 0) {
                    NSMutableArray *selected = [NSMutableArray arrayWithCapacity:self.selectedAlbums.count];
                    for (TFPickPhotoModel *obj in self.albums) {
                        TFPickPhotoModel *selectItem = nil;
                        for (TFPickPhotoModel *item in self.selectedAlbums) {
                            if ([obj.localIdentifier isEqualToString:item.localIdentifier] && item.isSelect) {
                                selectItem = item;
                            }
                        }
        
                        if (selectItem) {
                            obj.selectIndex = selectItem.selectIndex;
                            obj.isSelect = YES;
                            [selected addObject:obj];
                        }
                    }
 
                    self.selectedAlbums = selected;
                }
                [self.collectionView reloadData];
            });
        }];
    });
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFPickPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: NSStringFromClass([TFPickPhotoCell class]) forIndexPath:indexPath];
    cell.selectItemBgColor = self.selectItemBgColor;
    TFPickPhotoModel *photoModel = self.albums[indexPath.row];
    cell.photoModel = photoModel;
    PHAsset *ass = photoModel.asset;
    cell.representedAssetIdentifier = ass.localIdentifier;
    if (!photoModel.thumbnailImage){
        [[TFAssetLibraryUtils sharedInstance] obtainImage:photoModel expectSize:CGSizeMake(self.cellWidth, self.cellWidth) callBack:^(UIImage * _Nonnull image, TFPickPhotoModel * _Nonnull phtoInfo) {
            cell.thumbnailImage = image;
        }];
    } else {
        cell.thumbnailImage = photoModel.thumbnailImage;
    }
    cell.didSelectBlock = ^(TFPickPhotoModel * _Nonnull photoModel) {
        if (photoModel.isSelect) {
            if (self.selectedAlbums.count >= self.maxSelectedNum && self.maxSelectedNum > 0) {
                photoModel.isSelect = NO;
                [self showSplash];
                return ;
            }
            [self.selectedAlbums addObject:photoModel];
        } else {
            [self.selectedAlbums removeObject:photoModel];
        }
        
        for (int i = 0; i < self.selectedAlbums.count; i++) {
            TFPickPhotoModel *obj = self.selectedAlbums[i];
            obj.selectIndex = (index + 1);
        }
        
        self.rightBarButton.enabled = self.selectedAlbums.count > 0;
        [self.collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

# pragma mark - Other Setting

- (void)showWithViewController:(UIViewController *)viewController {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    nav.navigationBar.barTintColor = self.naviBgColor ? self.naviBgColor : [UIColor whiteColor];
    [viewController presentViewController:nav animated:YES completion:nil];
}

- (void)showSplash{
#warning TODO -
//    最多可以选择%@张图片
}


@end
