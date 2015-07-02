//
//  CategoryCell.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "CategoryCell.h"

#import "ReaderCategory.h"
#import <Masonry/Masonry.h>


#import <BFKit/BFKit.h>

@interface CategoryCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *iconImageV;

//@property (strong, nonatomic) 

@end

@implementation CategoryCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageV];
        
        self.contentView.backgroundColor = [UIColor randomColor];
    }
    return self;
}

- (void)configureWithModel:(ReaderCategory *)model{
    self.titleLabel.text = model.name;
    
    [self setupLayout];
}

- (void)setupLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width - 40, 30));
        make.left.mas_equalTo(20.f);
    }];
}

#pragma mark - Properties

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont flatFontOfSize:18.f]; //[UIFont fontForFontName:FontNameTamilSangamMN size:15.f];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageV{
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc] init];
    }
    return _iconImageV;
}

@end
