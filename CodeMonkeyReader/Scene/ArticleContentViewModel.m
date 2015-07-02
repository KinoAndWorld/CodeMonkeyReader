//
//  ArticleContentViewModel.m
//  CodeMonkeyReader
//
//  Created by kino on 15/7/1.
//
//

#import "ArticleContentViewModel.h"

@interface ArticleContentViewModel()

@property (strong, nonatomic) ReaderArtcle *article;

@end

@implementation ArticleContentViewModel


- (id)initWithArticle:(ReaderArtcle *)article{
    if (self = [super init]) {
        _article = article;
    }
    return self;
}



@end
