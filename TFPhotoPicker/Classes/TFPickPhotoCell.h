//
//  TFPickPhotoCell.h
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import <UIKit/UIKit.h>
#import "TFPickPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPickPhotoCell : UICollectionViewCell

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, strong) UIColor *selectItemBgColor;

@property (nonatomic, strong) UIColor *selectItemTitleColor;

@property (nonatomic, strong) TFPickPhotoModel *photoModel;

@property (nonatomic, copy) void (^didSelectBlock)(TFPickPhotoModel *photoModel);

@end

NS_ASSUME_NONNULL_END
