//
//  ArticleContentViewModel.h
//  CodeMonkeyReader
//
//  Created by kino on 15/7/1.
//
//

#import "RVMViewModel.h"
#import "ReaderArtcle.h"

@interface ArticleContentViewModel : RVMViewModel

@property (strong, nonatomic, readonly) ReaderArtcle *article;
@property (weak, nonatomic) UIViewController *controller;

- (id)initWithArticle:(ReaderArtcle *)article;

@end
