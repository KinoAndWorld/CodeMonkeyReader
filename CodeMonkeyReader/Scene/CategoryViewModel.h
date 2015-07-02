//
//  CategoryViewModel.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <Foundation/Foundation.h>
#import "ReaderCategory.h"

#import <RVMViewModel.h>

@class ArticleListViewModel;

@interface CategoryViewModel : RVMViewModel

@property (strong, nonatomic, readonly) NSArray *categories;

//- (instancetype)initWithCategory:(ReaderCategory *)category;

- (RACSignal *)fetchCategoryItems;

- (ArticleListViewModel *)articleListViewModelAtIndex:(NSInteger)index;

@end
