//
//  AKPickerView.m
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import "TLPickerView.h"

#import "TLCollectionViewCell.h"
#import <Availability.h>
#import "TLCollectionViewLayout.h"

#import "TLPickerViewDelegateIntercepter.h"



#define LINE_WIDTH              2
#define TIME_WIDTH              60 * 2
#define HOURE_WIDTH             60 * 60


@class TLCollectionViewLayout;
@class TLPickerViewDelegateIntercepter;





//整体的视图控件，内部使用的属性和方法
@interface TLPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TLCollectionViewLayoutDelegate>

//试图列表集控件，用于显示横向列表
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *centerLine;

@property (nonatomic, assign) NSUInteger selectedTime;

@property (nonatomic, strong) TLPickerViewDelegateIntercepter *intercepter;


@property (nonatomic) NSInteger itemCount;
@property (nonatomic) CGFloat lastContentOffset;

- (CGFloat)offsetForItem:(NSUInteger)item;
- (CGSize)sizeForString:(NSString *)string;



- (void)didEndScrolling;

@end



//整体的视图控件
@implementation TLPickerView




- (void)initialize
{
    
    self.backgroundColor = [UIColor whiteColor];
    
	self.pickerViewStyle = self.pickerViewStyle ?: TLPickerViewStyle3D;
    
	self.maskDisabled = self.maskDisabled;

    //创建列表视图
	[self.collectionView removeFromSuperview];
	self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self collectionViewLayout]];
    
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //添加数据源
	self.collectionView.dataSource = self;
    //注册选项内容视图
	[self.collectionView registerClass:[TLCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TLCollectionViewCell class])];
    
	[self addSubview:self.collectionView];

	self.intercepter = [TLPickerViewDelegateIntercepter new];
	self.intercepter.pickerView = self;
	self.intercepter.delegate = self.delegate;
    //添加事件
	self.collectionView.delegate = self.intercepter;
    
    self.centerLine = [UIView new];
    self.centerLine.frame = CGRectMake((self.frame.size.width - LINE_WIDTH) / 2.0f, 0, LINE_WIDTH, self.frame.size.height);
    self.centerLine.backgroundColor = [UIColor redColor];
    [self addSubview:self.centerLine];
}



- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)dealloc
{
	self.collectionView.delegate = nil;
}




#pragma mark - 视图子控件、视图控件大小属性

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.collectionView.collectionViewLayout = [self collectionViewLayout];
   
	self.collectionView.layer.mask.frame = self.collectionView.bounds;
}


//内容视图的坐标点，随着视图列表的滚动，该值会变换
- (CGPoint)contentOffset
{
	return self.collectionView.contentOffset;
}





#pragma mark -

- (void)setDelegate:(id<TLPickerViewDelegate>)delegate
{
	if (![_delegate isEqual:delegate]) {
		_delegate = delegate;
		self.intercepter.delegate = delegate;
	}
}


/**
 用于设置视图控件在3D显示效果时，偏移的量

 @param fisheyeFactor
 */
- (void)setFisheyeFactor:(CGFloat)fisheyeFactor
{
	_fisheyeFactor = fisheyeFactor;

	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -MAX(MIN(self.fisheyeFactor, 1.0), 0.0);
    
	self.collectionView.layer.sublayerTransform = transform;
}


//遮罩处理效果，主要用于处理两边的渐变效果
- (void)setMaskDisabled:(BOOL)maskDisabled
{
	_maskDisabled = maskDisabled;
    
    
	self.collectionView.layer.mask = !maskDisabled ? nil :
    
    ({
		CAGradientLayer *maskLayer = [CAGradientLayer layer];
		maskLayer.frame = self.collectionView.bounds;
		maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
							 (id)[[UIColor blackColor] CGColor],
							 (id)[[UIColor blackColor] CGColor],
							 (id)[[UIColor clearColor] CGColor],];
		maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
		maskLayer.startPoint = CGPointMake(0.0, 0.0);
		maskLayer.endPoint = CGPointMake(1.0, 0.0);
		maskLayer;
	});
}




#pragma mark -

//列表视图
- (TLCollectionViewLayout *)collectionViewLayout
{
	TLCollectionViewLayout *layout = [TLCollectionViewLayout new];
	layout.delegate = self;
	return layout;
}










#pragma mark -

- (void)reloadData
{
	[self invalidateIntrinsicContentSize];
    
	[self.collectionView.collectionViewLayout invalidateLayout];
	[self.collectionView reloadData];
    
}

//3D显示效果需要
- (CGFloat)offsetForItem:(NSUInteger)item
{
	NSAssert(item < [self.collectionView numberOfItemsInSection:0],
			 @"item out of range; '%lu' passed, but the maximum is '%lu'", item, [self.collectionView numberOfItemsInSection:0]);

	CGFloat offset = 0.0;

	for (NSInteger i = 0; i < item; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		CGSize cellSize = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath];
		offset += cellSize.width;
	}

	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	CGSize firstSize = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
	NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
	CGSize selectedSize = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:selectedIndexPath];
	offset -= (firstSize.width - selectedSize.width) / 2;

	return offset;
}

-(void)setBeginTime:(NSInteger)beginTime {
    if (beginTime > 0) {
        beginTime /= HOURE_WIDTH;
        beginTime *= HOURE_WIDTH;
    }
    _beginTime = beginTime;
}

-(void)setEndTime:(NSInteger)endTime {
    if (endTime > 0) {
        endTime /= HOURE_WIDTH;
        endTime *= HOURE_WIDTH;
    }
    _endTime = endTime;
}


-(NSInteger)itemFromTime:(NSInteger)time {
    if (time > 0) {
        time /= HOURE_WIDTH;
        time *= HOURE_WIDTH;
    }
    NSUInteger item = time - self.beginTime;
    item /= TIME_WIDTH;
    return item;
}

//时间, 是自1970的秒数
- (void)selectTime:(NSUInteger)time animated:(BOOL)animated {
    if (self.endTime > 0 && time > self.endTime) {
        time = self.endTime;
//        return;
    }
    
    [self selectItem:[self itemFromTime:time] animated:animated];
}

//时间, 是自1970的秒数
- (void)scrollToTime:(NSUInteger)time animated:(BOOL)animated {
    if (self.endTime > 0 && time > self.endTime) {
        time = self.endTime;
//        return;
    }
    [self scrollToItem:[self itemFromTime:time] animated:animated];
}





//选中指定选项
- (void)selectItem:(NSUInteger)item animated:(BOOL)animated
{
	[self selectItem:item animated:animated notifySelection:YES];
}


//选中指定选项
- (void)selectItem:(NSUInteger)item animated:(BOOL)animated notifySelection:(BOOL)notifySelection
{
    NSUInteger time = [self timeFromRow:item];
    if (self.endTime > 0 && time > self.endTime) {
        
        time = self.endTime;
        item = [self itemFromTime:time];
    }
    
    
	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
									  animated:animated
								scrollPosition:UICollectionViewScrollPositionNone];
    
    [self scrollToItem:item animated:animated];

    
	self.selectedTime = time;

    if (notifySelection && [self.delegate respondsToSelector:@selector(pickerView:didSelectTime:)]) {
		[self.delegate pickerView:self didSelectTime:time];
    }
}


//滚动到指定选项
- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated
{
    switch (self.pickerViewStyle) {
        case TLPickerViewStyleFlat: {
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:animated];
            
            break;
        }
        case TLPickerViewStyle3D: {
            
            [self.collectionView setContentOffset:CGPointMake([self offsetForItem:item], self.collectionView.contentOffset.y)
                                         animated:animated];
            break;
        }
        default: break;
    }
}

//停止滚动事件处理
- (void)didEndScrolling
{
	switch (self.pickerViewStyle) {
            
		case TLPickerViewStyleFlat: {
            
			CGPoint center = [self convertPoint:self.collectionView.center toView:self.collectionView];
			NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
            
			[self selectItem:indexPath.item animated:YES];
            
			break;
		}
            
		case TLPickerViewStyle3D: {
            
//			if ([self.dataSource numberOfItemsInPickerView:self]) {
//				for (NSUInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {
//					NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//					AKCollectionViewCell *cell = (AKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//					if ([self offsetForItem:i] + cell.bounds.size.width / 2 > self.collectionView.contentOffset.x) {
//						[self selectItem:i animated:YES];
//						break;
//					}
//				}
//			}
            
			break;
		}
		default: break;
	}
}


#pragma mark - UICollectionViewDelegate 绑定数据源和事件

-(NSInteger)timeFromRow:(NSUInteger)row {
    return self.beginTime + row * TIME_WIDTH;
}


-(NSInteger)itemCount {
    if (_itemCount == 0) {
        if (self.beginTime > 0) {
            
//            self.beginTime /= (60 * 60);
//            self.beginTime *= (60 * 60);
            
            NSDate *begin = [NSDate dateWithTimeIntervalSince1970:self.beginTime];
            NSDate *now = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60];
            NSTimeInterval timeInterval = (int)[now timeIntervalSinceDate:begin];;
//            if (timeInterval < 0) {
//                timeInterval *= -1;
//            }
            
            _itemCount = timeInterval / TIME_WIDTH ;
        }
        
    }
    return _itemCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemCount;
//	return [self.dataSource numberOfItemsInPickerView:self];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	TLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TLCollectionViewCell class])
																		   forIndexPath:indexPath];

    
    NSInteger row = indexPath.row;
    NSInteger time = [self timeFromRow:row];
    [cell setTimeFrom1970:time];
    BOOL available = NO;
    if (self.endTime > 0) {
        available = time >= self.beginTime && time <= self.endTime;
    }
    
    [cell setAvailableTime:available];
	return cell;
}

//设置每个项目的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //高度固定
    //初始宽度为间距大小
	CGSize size = CGSizeMake(3, collectionView.bounds.size.height);
	return size;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0.0;
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
	CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
	CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
	return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
							0, (collectionView.bounds.size.width - lastSize.width) / 2);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectItem:indexPath.item animated:YES];
}





#pragma mark - UIScrollViewDelegate


// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//    
//    NSInteger time = self.selectedTime;
//    if (time == self.endTime) {
//        
//        
//    }
//    CGFloat lastContentOffset = scrollView.contentOffset.x;
//}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    CGFloat lastContentOffset = scrollView.contentOffset.x;
////    if (self.lastContentOffset < scrollView.contentOffset.x) {
//////        JXLog(@"向上滚动");
////    }else{
//////        JXLog(@"向下滚动");
////    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat lastContentOffset = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
		[self.delegate scrollViewDidEndDecelerating:scrollView];
    }

	if (!scrollView.isTracking) [self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat lastContentOffset = scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		[self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }

	if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat lastContentOffset = scrollView.contentOffset.x;
    NSInteger time = self.selectedTime;
    
    if (self.lastContentOffset <= 0 || time <= 0) {
        self.lastContentOffset = lastContentOffset;
        
    } else if (self.lastContentOffset <= scrollView.contentOffset.x) {
        
//        self.collectionView.panGestureRecognizer.enabled = NO;
        [self selectTime:self.endTime animated:NO];
        return;
    }
    

    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
		[self.delegate scrollViewDidScroll:scrollView];
        
    }

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
	self.collectionView.layer.mask.frame = self.collectionView.bounds;
	[CATransaction commit];
}





#pragma mark - AKCollectionViewLayoutDelegate

//AKCollectionViewLayout内部用来判断是否为哪种显示样式
- (TLPickerViewStyle)pickerViewStyleForCollectionViewLayout:(TLCollectionViewLayout *)layout
{
	return self.pickerViewStyle;
}




@end




