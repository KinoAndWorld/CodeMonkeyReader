//
//  ArticleListViewModel.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/30.
//
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "ArticleListViewModel.h"
#import "ArticleContentViewModel.h"


@interface ArticleListViewModel()

@property (strong, nonatomic) ReaderCategory *masterCategory;

@end

@implementation ArticleListViewModel

- (instancetype)initWithModel:(ReaderCategory *)cate{
    if (self = [super init]) {
        _masterCategory = cate;
    }
    return self;
}


- (RACSignal *)fetchArticlesByMasterCategory{
    return [self fetchArticlesByCategory:_masterCategory];
}

- (RACSignal *)fetchArticlesByCategory:(ReaderCategory *)cate{
    if (!cate) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendError:[NSError errorWithDomain:@"Category is nil" code:-1001 userInfo:nil]];
            return [RACDisposable disposableWithBlock:^{  }];
        }];
    }
    
    RLMResults *result = [ReaderArtcle objectsWhere:[NSString stringWithFormat:@"category.name = '%@'", cate.name]];
    if (result && result.count > 0 /* 这里还要加上过期时间判断 */) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (id item in result) {
                [tempArray addObject:item];
            }
            
            _articles = [NSArray arrayWithArray:tempArray];
            [subscriber sendNext:_articles];
            return [RACDisposable disposableWithBlock:^{
                [subscriber sendCompleted];
            }];
        }];
    }
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [RACDisposable disposableWithBlock:^{
            [subscriber sendCompleted];
        }];
    }];
}

- (ArticleContentViewModel *)articleContentViewModelAtIndex:(NSInteger)index{
    ArticleContentViewModel *vm = [[ArticleContentViewModel alloc] initWithArticle:[_articles safeObjectAtIndex:index]];
    return vm;
}

@end
