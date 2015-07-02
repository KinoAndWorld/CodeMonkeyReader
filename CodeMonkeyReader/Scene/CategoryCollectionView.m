//
//  CategoryCollectionView.m
//  CodeMonkeyReader
//
//  Created by kino on 15/6/29.
//
//

#import "CategoryCollectionView.h"

#import "CategoryCell.h"

#import "ReaderCategory.h"
#import "CategoryViewModel.h"

#import <Masonry/Masonry.h>


@interface CategoryCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) SelectCateBlock selectedBlock;

@end

@implementation CategoryCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"CategoryCell"];
    }
    return self;
}


#pragma mark - DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    ReaderCategory *cate = self.viewModel.categories[indexPath.row];
    [cell configureWithModel:cate];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return .1f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH / 2.f - 8, SCREEN_WIDTH / 2.f - 8);
}

#pragma mark - Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedBlock){
        self.selectedBlock(indexPath.item);
    }
}

#pragma mark - Private

- (void)_handleSelectAreaCallback:(SelectCateBlock)block{
    if (!_selectedBlock){
        _selectedBlock = block;
    }
}

@end
