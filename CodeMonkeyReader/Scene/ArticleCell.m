//
//  ArticleCell.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import "ArticleCell.h"

#import "ReaderCategory.h"

@implementation ArticleCell

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self.contentView addSubview:self.titleLabel];
//    }
//    return self;
//}

- (void)configureCellWithModel:(ReaderArtcle *)model{
    self.titleLabel.text = model.title;
    
    [self setupLayout];
}

- (void)setupLayout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width - 40, 80));
        make.left.mas_equalTo(20.f);
    }];
}

#pragma mark - Proporties

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont flatFontOfSize:18.f];
        _titleLabel.numberOfLines = 0.f;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
