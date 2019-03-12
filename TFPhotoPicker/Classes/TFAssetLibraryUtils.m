//
//  TFAssetLibraryUtils.m
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import "TFAssetLibraryUtils.h"
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, TFPLAuthorizationStatus) {
    TFPLAuthorizationStatusNotDetermined = 0,
    TFPLAuthorizationStatusDenied        = 1,
    TFPLAuthorizationStatusAuthorized    = 2
};

@interface TFAssetLibraryUtils()

@property (nonatomic, strong) PHImageManager *imageManage;

@end

@implementation TFAssetLibraryUtils

+ (instancetype)sharedInstance {
    static TFAssetLibraryUtils *draftSleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        draftSleton = [[TFAssetLibraryUtils alloc] init];
    });
    return draftSleton;
}

- (instancetype)init {
    if (self = [super init]) {
        self.imageManage = [PHImageManager defaultManager];
    }
    return self;
}

+ (void)fetchCollectionsWithCompletionBlock:(void(^)(NSArray *))completion {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:option];
    
    NSMutableArray *albums = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TFPickPhotoModel *model = [TFPickPhotoModel new];
        model.asset = obj;
        model.photoSize = CGSizeMake(obj.pixelWidth, obj.pixelHeight);
        model.localIdentifier = obj.localIdentifier;
        [albums addObject:model];
    }];
    completion(albums);
}

+ (void)requestAuthorizationWithCompletionBlock:(void(^)(BOOL))completion {
    if ([self authorizationStatus] == TFPLAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(status == PHAuthorizationStatusAuthorized);
            });
        }];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([self authorizationStatus] == TFPLAuthorizationStatusAuthorized);
        });
    }
}

+ (TFPLAuthorizationStatus)authorizationStatus{
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusDenied:
            return TFPLAuthorizationStatusDenied;
            break;
        case PHAuthorizationStatusRestricted:
            return TFPLAuthorizationStatusDenied;
            break;
        case PHAuthorizationStatusAuthorized:
            return TFPLAuthorizationStatusAuthorized;
            break;
        default:
            return TFPLAuthorizationStatusNotDetermined;
            break;
    }
}

- (void)obtainImage:(TFPickPhotoModel *)photoModel expectSize:(CGSize)size callBack:(void(^)(UIImage *asset, TFPickPhotoModel *photoInfo))callback {
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    option.networkAccessAllowed = YES;
    option.version = PHImageRequestOptionsVersionCurrent;
    [self.imageManage requestImageForAsset:photoModel.asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        photoModel.thumbnailImage = result;
        !callback ?: callback(result, photoModel);
    }];
}

- (void)obtainImages:(NSArray<TFPickPhotoModel *> *)photoModels expectSize:(CGSize)size callBack:(void(^)(NSArray<UIImage *> *imageArray))callback {
    NSMutableArray *array = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (TFPickPhotoModel *obj in photoModels) {
        dispatch_group_enter(group);
        [self obtainImage:obj expectSize:size callBack:^(UIImage * _Nonnull image, TFPickPhotoModel  * _Nonnull photoInfo) {
            [array addObject:image];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group,dispatch_get_main_queue(), ^{
        !callback ?: callback(array);
    });
}

@end
