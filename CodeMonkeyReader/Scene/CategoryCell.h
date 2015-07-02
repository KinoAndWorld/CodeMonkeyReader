//
//  CategoryCell.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <UIKit/UIKit.h>

@class ReaderCategory;

@interface CategoryCell : UICollectionViewCell

- (void)configureWithModel:(ReaderCategory *)model;

@end
