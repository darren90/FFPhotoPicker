//
//  TFPickPhotoModel.h
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import <Foundation/Foundation.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface TFPickPhotoModel : NSObject

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) CGSize photoSize;

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, copy) NSString *imageFileUrl;

@property (nonatomic, copy) NSString *localIdentifier;


@end

NS_ASSUME_NONNULL_END
