//
//  TFPickPhotoViewController.h
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import <UIKit/UIKit.h>
#import "TFPickPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPickPhotoViewController : UIViewController

@property (nonatomic, strong) UIColor *naviBgColor;

@property (nonatomic, strong) UIColor *selectItemBgColor;

@property (nonatomic, strong) UIColor *selectItemTitleColor;

@property (nonatomic, strong) UIImage *leftBtnImage;

@property (nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) NSString *rightBtnText;

@property (nonatomic, strong) UIColor *rightBtnColor;

@property (nonatomic, strong) NSArray<TFPickPhotoModel *> *selectAlbums;

@property (nonatomic, assign) NSInteger maxSelectedNum;



@property (nonatomic, copy) void(^didPickerCloseBlock)(void);

@property (nonatomic, copy) void(^didPickerFinishBlock)(NSArray<TFPickPhotoModel *> *selectPhotos);



- (void)showWithViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
