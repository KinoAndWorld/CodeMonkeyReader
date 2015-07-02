//
//  APIManager.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "APIManager.h"

#import <AFNetworking/AFNetworking.h>



static NSString *kReaderAPI = @"https://github.com/nemoTyrant/manong/blob/master/README.md";

@interface APIManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation APIManager

+ (APIManager *)shareManager{
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[APIManager alloc] init];
        instance.manager = [AFHTTPRequestOperationManager manager];
        instance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        instance.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.manager.requestSerializer.timeoutInterval = 20.0f;
    });
    return instance;
}

- (RACSignal *)fetReaderDatas{
    return [self signalFromAPIMethod:kReaderAPI params:nil];
}

- (RACSignal *)signalFromAPIMethod:(NSString *)method
                            params:(NSDictionary *)params{
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        AFHTTPRequestOperation *op = [self.manager GET:kReaderAPI
                                            parameters:params
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   [subscriber sendNext:responseObject];
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                   NSData *jsonData = [op.responseString dataUsingEncoding:NSUTF8StringEncoding];
//                                                   [error findErrorMessage:jsonData];
                                                   NSLog(@"network error:%@",op.responseString);
                                                   [subscriber sendError:error];
                                               }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }];
    
}

@end
