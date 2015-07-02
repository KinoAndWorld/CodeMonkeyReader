//
//  HomeController.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "HomeController.h"
#import "ArticleListController.h"

#import "CategoryViewModel.h"
#import "CategoryCollectionView.h"

#import <Masonry/Masonry.h>


@interface HomeController ()

@property (strong, nonatomic) CategoryViewModel *viewModel;

@property (strong, nonatomic) CategoryCollectionView *categoryCollectionView;

@end

@implementation HomeController

- (instancetype)initWithViewModel:(CategoryViewModel *)viewModel{
    self = [super init];
    if (self){
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
    
    [self createUIAndLayout];
}

- (void)createUIAndLayout{
    self.title = @"码农周刊";
    
    //navgation
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor silverColor]];
    
    UIImage *icon = [UIImage imageNamed:@"setting_icon"];
    
    [[[self setNavgationItemWithImage:icon position:NavgationItemPositionLeft]
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            BFLog(@"show next view");
    }];
    
    [[[self setNavgationItemWithImage:[UIImage imageNamed:@"search_icon"]
                             position:NavgationItemPositionRight]
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            BFLog(@"show search view");
     }];
    
    //content view
    [self.view addSubview:self.categoryCollectionView];
    
    [self.categoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    RACSignal *selectSignal = [self.categoryCollectionView
         rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:)];
    [selectSignal subscribeNext:^(RACTuple *x) {
        BFLog(@"eee%@  and  %@    %@", x.first, x.second, x.third);
        NSIndexPath *idp = x.second;
        ArticleListController *dest = [[ArticleListController alloc] init];
        dest.viewModel = [_viewModel articleListViewModelAtIndex:idp.row];
        [self.navigationController pushViewController:dest animated:YES];
    }];
}

- (void)bindViewModel{
    
    [self startLoading];
    @weakify(self)
    [[_viewModel fetchCategoryItems] subscribeNext:^(id x) {
        @strongify(self)
        [self stopLoading];
        
        if ([x isKindOfClass:[NSArray class]]) {
            NSArray *datas = x;
            BFLog(@"items = %@",datas);
            
            [_categoryCollectionView reloadData];
        }else{
            BFLog(@"unkonw error");
        }
    } error:^(NSError *error) {
        [self stopLoading];
        BFLog(@"err =  %@",error);
    }];
}

#pragma mark - Proptories

- (CategoryCollectionView *)categoryCollectionView{
    if (!_categoryCollectionView) {
        _categoryCollectionView = [[CategoryCollectionView alloc] initWithFrame:self.view.bounds];
        _categoryCollectionView.viewModel = _viewModel;
    }
    return _categoryCollectionView;
}


@end
