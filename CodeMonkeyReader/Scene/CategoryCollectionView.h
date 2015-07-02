//
//  CategoryCollectionView.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <UIKit/UIKit.h>

@class CategoryViewModel;

typedef void (^SelectCateBlock)(NSUInteger index);

@interface CategoryCollectionView : UICollectionView

//@property (strong, nonatomic) NSArray *categories;

@property (weak, nonatomic) CategoryViewModel *viewModel;

@end
