//
//  TFAssetLibraryUtils.h
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import <Foundation/Foundation.h>
#import "TFPickPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAssetLibraryUtils : NSObject


+ (instancetype)sharedInstance;

+ (void)fetchCollectionsWithCompletionBlock:(void(^)(NSArray *))completion;

+ (void)requestAuthorizationWithCompletionBlock:(void(^)(BOOL))completion;

- (void)obtainImage:(TFPickPhotoModel *)photoModel expectSize:(CGSize)size callBack:(void(^)(UIImage *asset, TFPickPhotoModel *photoInfo))callback;

- (void)obtainImages:(NSArray<TFPickPhotoModel *> *)photoModels expectSize:(CGSize)size callBack:(void(^)(NSArray<UIImage *> *imageArray))callback;

@end

NS_ASSUME_NONNULL_END
