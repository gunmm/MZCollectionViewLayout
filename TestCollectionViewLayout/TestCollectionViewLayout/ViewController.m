//
//  ViewController.m
//  TestCollectionViewLayout
//
//  Created by minzhe on 2019/6/6.
//  Copyright © 2019 minzhe. All rights reserved.
//

#import "ViewController.h"
#import "MZCollectionViewLayout.h"
#import "MyCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MZCollectionViewLayoutDataSource>

@property (nonatomic, strong) NSArray <NSArray *> *allArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    MZCollectionViewLayout *layout = [[MZCollectionViewLayout alloc] init];
    NSArray *sec1 = @[@"1111", @"1111", @"1111", @"1111", @"1111", @"1111", @"1111", @"1111", @"11"];
    NSArray *sec2 = @[@"2222", @"2222", @"2222", @"22222", @"22222", @"22222", @"22222", @"2222", @"22"];
    NSArray *sec3 = @[@"3333", @"333333333", @"333333333333", @"333333333", @"3333333", @"22222", @"222", @"22222", @"22222"];

    self.allArray = @[sec1, sec2, sec3];
    layout.dataSource = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, 375, 300) collectionViewLayout:layout];
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

}


#pragma mark----UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.allArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allArray[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.allArray[indexPath.section][indexPath.row];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = (kind==UICollectionElementKindSectionHeader) ? @"header" : @"footer";

    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    view.backgroundColor = [UIColor whiteColor];
    if (kind==UICollectionElementKindSectionFooter) {
        view.backgroundColor = [UIColor redColor];
    }
    return view;
}

#pragma mark <MZCollectionViewLayoutDataSource>

- (CGFloat)collectionView:(UICollectionView *)collectionView widthAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *calculateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 27)];
    calculateLabel.font = [UIFont systemFontOfSize:14];
    NSString *titleString = self.allArray[indexPath.section][indexPath.row];
    if (titleString.length > 10) {
        titleString = [NSString stringWithFormat:@"%@…", [titleString substringToIndex:10]];
    }
    calculateLabel.text = titleString;
    [calculateLabel sizeToFit];
    CGFloat w = calculateLabel.bounds.size.width + 22;
    return w;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderAtSection:(NSInteger)section {
    return 40;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView heightForFooterAtSection:(NSInteger)section {
//    return 20;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView rowSpacingAtSection:(NSInteger)section {
    return 15;
}
@end
