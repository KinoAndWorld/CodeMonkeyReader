//
//  ArticleContentController.m
//  CodeMonkeyReader
//
//  Created by kino on 15/7/1.
//
//

#import "ArticleContentController.h"

#import "ArticleContentViewModel.h"

#import "ArticleContentView.h"

#import "ReaderArtcle.h"

#import <TUSafariActivity.h>
#import <ARChromeActivity.h>

@import WebKit;

@interface ArticleContentController ()<WKNavigationDelegate>

@property (strong, nonatomic) ArticleContentView *contentView;

// Bar buttons
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem, *forwardBarButtonItem, *refreshBarButtonItem, *stopBarButtonItem, *actionBarButtonItem;

@end

@implementation ArticleContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(_viewModel.article != nil , @"fuck .... wrong article, it's not nil");
    
    if (!_viewModel) {
        _viewModel = [[ArticleContentViewModel alloc] init];
    }
    
    _viewModel.controller = self;
    
    [self createUIAndLayout];
    
    [self updateToolbarItems];
}

- (void)createUIAndLayout{
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //begin loading
    [self.contentView startLoadingWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"AFWebViewController needs to be contained in a UINavigationController. Use AFModalWebViewController for modal presentation.");
    
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - proporty

- (ArticleContentView *)contentView{
    if (!_contentView) {
        _contentView = [[ArticleContentView alloc] initWithViewModel:_viewModel];
    }
    return _contentView;
}

#pragma mark - Getters

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AFWebViewController.bundle/Back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackTapped:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AFWebViewController.bundle/Forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardTapped:)];
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.contentView.contentWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.contentView.contentWebView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.contentView.contentWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat toolbarWidth = 250;
        fixedSpace.width = 35;
        
        NSArray *items = @[fixedSpace,
                           refreshStopBarButtonItem,
                           fixedSpace,
                           self.backBarButtonItem,
                           fixedSpace,
                           self.forwardBarButtonItem,
                           fixedSpace,
                           self.actionBarButtonItem];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolbarWidth, 44)];
        toolbar.items = items;
        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    else {
        NSArray *items = @[fixedSpace,
                           self.backBarButtonItem,
                           flexibleSpace,
                           self.forwardBarButtonItem,
                           flexibleSpace,
                           refreshStopBarButtonItem,
                           flexibleSpace,
                           self.actionBarButtonItem,
                           fixedSpace];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - Target actions

- (void)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.contentView.contentWebView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.contentView.contentWebView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.contentView.contentWebView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.contentView.contentWebView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.contentView.contentWebView.URL;
    if (url) {
        // More activities should be added in the future
        NSArray *activities = @[[TUSafariActivity new], [ARChromeActivity new]];
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
            [documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        }
        else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UIPopoverPresentationController *popover = activityController.popoverPresentationController;
                popover.sourceView = self.view;
                popover.barButtonItem = sender;
            }
            
            [self presentViewController:activityController animated:YES completion:NULL];
        }
    }
}

#pragma mark - WKNavigation delegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (!self.navigationItem.title) {
        self.navigationItem.title = webView.title;
    }
    
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateToolbarItems];
}

@end
