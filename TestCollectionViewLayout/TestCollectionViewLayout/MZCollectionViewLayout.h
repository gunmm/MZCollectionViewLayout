//
//  MZCollectionViewLayout.h
//  TestCollectionViewLayout
//
//  Created by minzhe on 2019/6/6.
//  Copyright © 2019 minzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZCollectionViewLayoutDataSource<NSObject>

@optional

// cell宽度
- (CGFloat)collectionView:(UICollectionView *)collectionView widthAtIndexPath:(NSIndexPath *)indexPath;
// 分组行高
- (CGFloat)collectionView:(UICollectionView *)collectionView heightAtSection:(NSInteger)section;
/// 分组内行距
- (CGFloat)collectionView:(UICollectionView *)collectionView rowSpacingAtSection:(NSInteger)section;
// 分组内列列
- (CGFloat)collectionView:(UICollectionView *)collectionView columnSpacingAtSection:(NSInteger)section;
// 分组的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView insetAtSection:(NSInteger)section;
// 组的头视图高度
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderAtSection:(NSInteger)section;
// 组的尾视图高度
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForFooterAtSection:(NSInteger)section;

@end

@interface MZCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MZCollectionViewLayoutDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
