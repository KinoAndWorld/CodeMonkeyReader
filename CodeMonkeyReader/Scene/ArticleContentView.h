//
//  ArticleContentView.h
//  CodeMonkeyReader
//
//  Created by kino on 15/7/1.
//
//

#import <UIKit/UIKit.h>

@class ArticleContentViewModel;
@class WKWebView;

@interface ArticleContentView : UIView

@property (strong, nonatomic, readonly) WKWebView *contentWebView;


- (instancetype)initWithViewModel:(ArticleContentViewModel *)viewModel;

- (void)startLoadingWebView;

@end
