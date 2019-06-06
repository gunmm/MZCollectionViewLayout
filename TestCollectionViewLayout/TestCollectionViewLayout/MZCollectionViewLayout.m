//
//  MZCollectionViewLayout.m
//  TestCollectionViewLayout
//
//  Created by minzhe on 2019/6/6.
//  Copyright © 2019 minzhe. All rights reserved.
//

#import "MZCollectionViewLayout.h"

//行距
static const CGFloat defualtRowSpacing = 10;
//列距
static const CGFloat defualtColumnSpacing = 10;
//cell高度
static const CGFloat defualtItemHeight = 27;
//cell宽度
static const CGFloat defualtItemWidth = 50;

//内间距
static const UIEdgeInsets defualtContentInset = {15, 15, 15, 15};


@interface MZCollectionViewLayout ()

@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;


@property (nonatomic, strong) NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *itemLayoutAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *headerLayoutAttributes;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *footerLayoutAttributes;



@end

@implementation MZCollectionViewLayout



//collectionview的内容尺寸
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.totalWidth, self.totalHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.collectionView.isDecelerating || self.collectionView.isDragging) {
        return;
    }
    _currentX = 0;
    _currentY = 0;
    _itemLayoutAttributes = [NSMutableArray array];
    _headerLayoutAttributes = [NSMutableArray array];
    _footerLayoutAttributes = [NSMutableArray array];
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    self.totalWidth = contentWidth;

    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
   
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfRows = [self.collectionView numberOfItemsInSection:section];
        CGFloat columnHeight = [self itemHeigthAtSection:section];
        CGFloat rowSpacing = [self rowSpacingAtSection:section];
        CGFloat columnSpacing = [self columnSpacingAtSection:section];
        UIEdgeInsets contentInset = [self contentInsetForSection:section];
        CGFloat headerHeight = [self heightForHeaderAtSection:section];
        CGFloat footerHeight = [self heightForFooterAtSection:section];
        
        if (headerHeight > 0) {
            UICollectionViewLayoutAttributes *headerLayoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerLayoutAttribute.frame = CGRectMake(0.0, _currentY, contentWidth, headerHeight);
            [_headerLayoutAttributes addObject:headerLayoutAttribute];
            _currentY += headerHeight;
        }
        
        _currentX += contentInset.left;
        _currentY += contentInset.top;

        NSMutableArray *layoutAttributeOfSection = [NSMutableArray arrayWithCapacity:numberOfRows];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath columnHeight:columnHeight rowSpacing:rowSpacing columnSpacing:columnSpacing contentInset:contentInset];
            [layoutAttributeOfSection addObject:attributes];
            
        }
        [_itemLayoutAttributes addObject:layoutAttributeOfSection];
        
        _currentX = 0;
        _currentY = _currentY + columnHeight + contentInset.bottom;
        
        
        if (footerHeight > 0) {
            UICollectionViewLayoutAttributes *footerLayoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            footerLayoutAttribute.frame = CGRectMake(0.0, _currentY, contentWidth, footerHeight);
            [_footerLayoutAttributes addObject:footerLayoutAttribute];
            _currentY += footerHeight;
        }
        self.totalHeight = self.currentY;
    }
}

//返回所有元素的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray array];
    [_itemLayoutAttributes enumerateObjectsUsingBlock:^(NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeOfSection, NSUInteger idx, BOOL *stop) {
        [layoutAttributeOfSection enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
            if (CGRectIntersectsRect(rect, attribute.frame)) {
                [result addObject:attribute];
            }
        }];
    }];
    [_headerLayoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
        if (attribute.frame.size.height && CGRectIntersectsRect(rect, attribute.frame)) {
            [result addObject:attribute];
        }
    }];
    [_footerLayoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
        if (attribute.frame.size.height && CGRectIntersectsRect(rect, attribute.frame)) {
            [result addObject:attribute];
        }
    }];
    return result;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
                                                            columnHeight:(CGFloat)columnHeight
                                                              rowSpacing:(CGFloat)rowSpacing
                                                           columnSpacing:(CGFloat)columnSpacing
                                                            contentInset:(UIEdgeInsets)contentInset {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemWidth = [self itemWidthAtIndexPath:indexPath];
    //判断剩余宽度够不够放下一个cell
    if ((self.totalWidth - self.currentX - contentInset.right) < itemWidth) {
        self.currentX = contentInset.left;
        self.currentY = self.currentY + columnSpacing + columnHeight;
    }
    attribute.frame = CGRectMake(self.currentX, self.currentY, itemWidth, columnHeight);
    self.currentX = self.currentX + itemWidth + rowSpacing;
    return attribute;
}


#pragma mark ----Private

//cell宽度
- (CGFloat)itemWidthAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = defualtItemWidth;
    if ([self.dataSource respondsToSelector:@selector(collectionView:widthAtIndexPath:)]) {
        itemWidth = [self.dataSource collectionView:self.collectionView widthAtIndexPath:indexPath];
    }
    return itemWidth;
}

//cell高度
- (CGFloat)itemHeigthAtSection:(NSInteger)section {
    CGFloat itemHeight = defualtItemHeight;
    if ([self.dataSource respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        itemHeight = [self.dataSource collectionView:self.collectionView heightForHeaderAtSection:section];
    }
    return itemHeight;
}

//行距
- (CGFloat)rowSpacingAtSection:(NSInteger)section {
    CGFloat rowSpacing = defualtRowSpacing;
    if ([self.dataSource respondsToSelector:@selector(collectionView:rowSpacingAtSection:)]) {
        rowSpacing = [self.dataSource collectionView:self.collectionView rowSpacingAtSection:section];
    }
    return rowSpacing;
}

//列距
- (CGFloat)columnSpacingAtSection:(NSInteger)section {
    CGFloat columnSpacing = defualtColumnSpacing;
    if ([self.dataSource respondsToSelector:@selector(collectionView:columnSpacingAtSection:)]) {
        columnSpacing = [self.dataSource collectionView:self.collectionView rowSpacingAtSection:section];
    }
    return columnSpacing;
}

//内间距
- (UIEdgeInsets)contentInsetForSection:(NSInteger)section {
    UIEdgeInsets edgeInsets = defualtContentInset;
    if ([self.dataSource respondsToSelector:@selector(collectionView:insetAtSection:)]) {
        edgeInsets = [self.dataSource collectionView:self.collectionView insetAtSection:section];
    }
    return edgeInsets;
}

//头视图高度
- (CGFloat)heightForHeaderAtSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(collectionView:heightForHeaderAtSection:)]) {
        return [self.dataSource collectionView:self.collectionView heightForHeaderAtSection:section];
    }
    return 0;
}

//尾视图高度
- (CGFloat)heightForFooterAtSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(collectionView:heightForFooterAtSection:)]) {
        return [self.dataSource collectionView:self.collectionView heightForFooterAtSection:section];
    }
    return 0;
}

@end
