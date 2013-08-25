//
//  BCTScheduleCollectionViewLayout.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTScheduleCollectionViewLayout.h"

static CGFloat const kBCTScheduleCollectionViewLayoutItemHeight = 44.f;
static CGFloat const kBCTScheduleCollectionViewLayoutItemWidth = 160.f;

@interface BCTScheduleCollectionViewLayout ()

@property (assign, nonatomic, readonly) CGSize contentSize;
@property (strong, nonatomic, readonly) NSArray *layoutAttributes;

@end

@implementation BCTScheduleCollectionViewLayout

@synthesize contentSize = _contentSize;
@synthesize layoutAttributes = _layoutAttributes;

#pragma mark - UICollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat height = self.collectionView.numberOfSections ? kBCTScheduleCollectionViewLayoutItemHeight * [self.collectionView numberOfItemsInSection:0] + kBCTScheduleCollectionViewLayoutItemHeight : 0.f;
    CGFloat width = self.collectionView.numberOfSections * kBCTScheduleCollectionViewLayoutItemWidth;
    
    _contentSize = CGSizeMake(width, height);
    
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSInteger section = 0, numberOfSections = self.collectionView.numberOfSections; section < numberOfSections; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [attributes addObject:attribute];
        
        for (NSInteger item = 0, numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section]; item < numberOfItemsInSection; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            [attributes addObject:attribute];
        }
    }
    
    _layoutAttributes = [attributes copy];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    attributes.center = CGPointMake(kBCTScheduleCollectionViewLayoutItemWidth * indexPath.section + (kBCTScheduleCollectionViewLayoutItemWidth / 2), self.collectionView.contentOffset.y + kBCTScheduleCollectionViewLayoutItemHeight / 2);
    attributes.size = CGSizeMake(kBCTScheduleCollectionViewLayoutItemWidth, kBCTScheduleCollectionViewLayoutItemHeight);
    attributes.zIndex = 1;
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.center = CGPointMake(kBCTScheduleCollectionViewLayoutItemWidth * indexPath.section + (kBCTScheduleCollectionViewLayoutItemWidth / 2), kBCTScheduleCollectionViewLayoutItemHeight * indexPath.item + 1.5 * kBCTScheduleCollectionViewLayoutItemHeight);
    attributes.size = CGSizeMake(kBCTScheduleCollectionViewLayoutItemWidth, kBCTScheduleCollectionViewLayoutItemHeight);
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [@[] mutableCopy];
    for (UICollectionViewLayoutAttributes *attribute in self.layoutAttributes) {
        if (!CGRectIntersectsRect(rect, attribute.frame)) {
            continue;
        }

        [attributes addObject:attribute];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
