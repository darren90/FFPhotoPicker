//
//  TFPickPhotoCell.m
//  Pods-TFPhotoPicker_Example
//
//  Created by fengtengfei on 2019/3/12.
//

#import "TFPickPhotoCell.h"

@interface TFPickPhotoCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) BOOL isSelect;

@end

@implementation TFPickPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_selectBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectBtn];
        
        _countLabel = [UILabel new];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:11.f];
        _countLabel.adjustsFontSizeToFitWidth = YES;
        _countLabel.textColor = [UIColor whiteColor];
        [_countLabel sizeToFit];
        _countLabel.layer.cornerRadius = _countLabel.frame.size.height / 2.f;
        _countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _countLabel.layer.borderWidth = 1.f;
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.clipsToBounds = YES;
        [self addSubview:_countLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
//    self.selectBtn.size = CGSizeMake(self.width / 2, self.height / 2);
//    self.selectBtn.top = 0;
//    self.selectBtn.right = self.width;
//
//    self.countLabel.top = 8;
//    self.countLabel.right = self.width - 8;
}

- (void)selectBtnClick {
    self.photoModel.isSelect = !self.photoModel.isSelect;
    
    if (self.didSelectBlock) {
        self.didSelectBlock(self.photoModel);
    }
}

- (void)setPhotoModel:(TFPickPhotoModel *)photoModel {
    _photoModel = photoModel;
    
    self.isSelect = photoModel.isSelect;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    if (isSelect) {
        self.countLabel.text = [NSString stringWithFormat:@"%@", @(self.photoModel.selectIndex)];
        self.countLabel.layer.borderColor = self.selectItemBgColor.CGColor;
        self.countLabel.backgroundColor = self.selectItemBgColor;
    } else {
        self.countLabel.text = @"";
        self.countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.countLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

# pragma mark - Other Setting

- (UIColor *)selectItemBgColor {
    if (!_selectItemBgColor) {
        return [UIColor lightGrayColor];
    }
    return _selectItemBgColor;
}


@end
