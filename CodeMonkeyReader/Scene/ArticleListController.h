//
//  ArticleListController.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import "BaseController.h"

//@class ReaderCategory;

@class ArticleListViewModel;

@interface ArticleListController : BaseController

@property (strong, nonatomic) ArticleListViewModel *viewModel;
//@property (strong, nonatomic) ReaderCategory *masterCategory;

@end
