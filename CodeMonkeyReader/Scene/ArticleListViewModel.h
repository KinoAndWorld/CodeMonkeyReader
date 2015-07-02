//
//  ArticleListViewModel.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import "RVMViewModel.h"
#import "ReaderCategory.h"

@class ArticleContentViewModel;

@interface ArticleListViewModel : RVMViewModel

@property (strong, nonatomic, readonly) NSArray *articles;
@property (strong, nonatomic, readonly) ReaderCategory *masterCategory;

- (instancetype)initWithModel:(ReaderCategory *)cate;

- (RACSignal *)fetchArticlesByMasterCategory;
- (RACSignal *)fetchArticlesByCategory:(ReaderCategory *)cate;

- (ArticleContentViewModel *)articleContentViewModelAtIndex:(NSInteger)index;

@end
