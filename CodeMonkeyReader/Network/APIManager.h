//
//  APIManager.h
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface APIManager : NSObject

+ (APIManager *)shareManager;

- (RACSignal *)fetReaderDatas;

@end
