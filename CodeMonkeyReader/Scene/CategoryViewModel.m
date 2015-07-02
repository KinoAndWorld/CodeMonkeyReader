//
//  CategoryViewModel.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "CategoryViewModel.h"
#import "ArticleListViewModel.h"

//
#import "APIManager.h"
#import "ReaderParser.h"
#import "ReaderCategory.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation CategoryViewModel

- (RACSignal *)fetchCategoryItems{
    //first fetch in database
    RLMResults *result = [ReaderCategory allObjects];
    if (result && result.count > 0 /* 这里还要加上过期时间判断 */) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (id item in result) {
                [tempArray addObject:item];
            }
            _categories = [NSArray arrayWithArray:tempArray];
            [subscriber sendNext:_categories];
            return [RACDisposable disposableWithBlock:^{
                [subscriber sendCompleted];
            }];
        }];
    }
    return [[[[APIManager shareManager] fetReaderDatas]
            map:^id(id value) {
                NSMutableDictionary *parseResult = [ReaderParser parseSourceDataToArray:value];
                if ([parseResult isKindOfClass:[NSMutableDictionary class]]) {
                    _categories = [self modelTranslate:parseResult Persistence:YES];
                }
                return _categories;
            }]catch:^RACSignal *(NSError *error) {
                return [RACSignal error:error];
            }];
}

- (NSArray *)modelTranslate:(NSMutableDictionary *)dic Persistence:(BOOL)persistence{
    __block NSMutableArray *tempArray = [NSMutableArray array];
    __block NSMutableArray *articles = [NSMutableArray array];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        __block ReaderCategory *category = [[ReaderCategory alloc] init];
        
        if ([key hasPrefix:@"user-content-"]) {
            category.name = [key substringFromIndex:[@"user-content-" length]];
        }else{
            category.name = key;
        }
        
        category.updateDate = [NSDate date];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = obj;
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ReaderArtcle *artcle = [[ReaderArtcle alloc] init];
                artcle.title = obj[kName];
                artcle.link = obj[kUrl];
                artcle.originLink = obj[kOriginUrl];
                
                artcle.category = category;
                [articles addObject:artcle];
            }];
        }
        [tempArray addObject:category];
    }];
    
    if ([tempArray isKindOfClass:[NSMutableArray class]] && tempArray.count > 0 && persistence) {
        // Get the default Realm
        RLMRealm *realm = [RLMRealm defaultRealm];
        // You only need to do this once (per thread)
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObjects:articles];
        [realm addObjects:tempArray];
        [realm commitWriteTransaction];
    }    
    return [NSArray arrayWithArray:tempArray];
}

#pragma mark - dispatch

- (ArticleListViewModel *)articleListViewModelAtIndex:(NSInteger)index{
    
    ArticleListViewModel *vm = [[ArticleListViewModel alloc] initWithModel:[_categories safeObjectAtIndex:index]];
    
    return vm;
}


@end
