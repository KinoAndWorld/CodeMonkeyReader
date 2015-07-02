//
//  ArticleContentView.m
//  CodeMonkeyReader
//
//  Created by kino on 15/7/1.
//
//

#import "ArticleContentView.h"

#import "ArticleContentViewModel.h"

@import WebKit;

@interface ArticleContentView()

// Bar buttons
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem, *forwardBarButtonItem, *refreshBarButtonItem, *stopBarButtonItem, *actionBarButtonItem;
@property (strong, nonatomic) WKWebView *contentWebView;

@end

@implementation ArticleContentView{
    ArticleContentViewModel *_viewModel;
}

- (instancetype)initWithViewModel:(ArticleContentViewModel *)viewModel{
    if (self = [super init]) {
        _viewModel = viewModel;
        [self createViewAndLayout];
    }
    return self;
}

- (void)createViewAndLayout{

    [self addSubview:self.contentWebView];
    
    [_contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // loadding page
    [self startLoadingWebView];
}


- (void)startLoadingWebView{
    
    NSURL *linkUrl = [NSURL URLWithString:_viewModel.article.link];
    
    [_contentWebView loadRequest:[NSURLRequest requestWithURL:linkUrl]];
}

#pragma mark - getter

- (WKWebView *)contentWebView{
    if (!_contentWebView) {
        _contentWebView = [[WKWebView alloc] init];
        _contentWebView.navigationDelegate = (id<WKNavigationDelegate>)_viewModel.controller;
    }
    return _contentWebView;
}

@end
