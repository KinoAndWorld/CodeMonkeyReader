//
//  ArticleCell.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import <UIKit/UIKit.h>


@class ReaderArtcle;

@interface ArticleCell : UITableViewCell

@property  (strong, nonatomic) UILabel *titleLabel;

- (void)configureCellWithModel:(ReaderArtcle *)model;

@end
