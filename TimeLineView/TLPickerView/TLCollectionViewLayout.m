//
//  AKCollectionViewLayout.m
//  AKPickerViewSample
//
//  Created by soyute on 2017/5/29.
//  Copyright © 2017年 Akkyie Y. All rights reserved.
//

#import "TLCollectionViewLayout.h"


@interface TLCollectionViewLayout ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxAngle;

@end



@implementation TLCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0.0;
    }
    return self;
}



- (void)prepareLayout
{
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    self.midX = CGRectGetMidX(visibleRect);
    self.width = CGRectGetWidth(visibleRect) / 2;
    self.maxAngle = M_PI_2;
    
}

//是否重新渲染视图
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}






- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    
    switch ([self.delegate pickerViewStyleForCollectionViewLayout:self]) {
            
        case TLPickerViewStyleFlat: {
            
            return attributes;
            break;
        }
        case TLPickerViewStyle3D: {
            
            CGFloat distance = CGRectGetMidX(attributes.frame) - self.midX;
            CGFloat currentAngle = self.maxAngle * distance / self.width / M_PI_2;
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DTranslate(transform, -distance, 0, -self.width);
            transform = CATransform3DRotate(transform, currentAngle, 0, 1, 0);
            transform = CATransform3DTranslate(transform, 0, 0, self.width);
            attributes.transform3D = transform;
            attributes.alpha = (ABS(currentAngle) < self.maxAngle);
            return attributes;
            
            break;
            
        }
        default:
            return nil;
            break;
    }
}



- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    switch ([self.delegate pickerViewStyleForCollectionViewLayout:self]) {
            
        case TLPickerViewStyleFlat: {
            
            return [super layoutAttributesForElementsInRect:rect];
            break;
        }
        case TLPickerViewStyle3D: {
            
            NSMutableArray *attributes = [NSMutableArray array];
            if ([self.collectionView numberOfSections]) {
                for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
                }
            }
            
            return attributes;
            break;
        }
        default:
            return nil;
            break;
    }
}

@end
