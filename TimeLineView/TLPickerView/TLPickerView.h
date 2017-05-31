//
//  AKPickerView.h
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import <UIKit/UIKit.h>

//文字显示效果
typedef NS_ENUM(NSInteger, TLPickerViewStyle) {
	TLPickerViewStyle3D = 1,        //3D效果
	TLPickerViewStyleFlat           //平铺效果
};

@class TLPickerView;


//事件处理协议，继承滚动协议
@protocol TLPickerViewDelegate <UIScrollViewDelegate>

@optional

//时间, 是自1970的秒数
- (void)pickerView:(TLPickerView *)pickerView didSelectTime:(NSInteger)time;

@end


//整体视图控件，对外提供的属性和方法
@interface TLPickerView : UIView

@property (nonatomic, weak) id <TLPickerViewDelegate> delegate;

//@property (nonatomic, assign) CGFloat interitemSpacing;         //间隔宽度

@property (nonatomic, assign) CGFloat fisheyeFactor; // 0...1; slight value recommended such as 0.0001

@property (nonatomic, assign, getter=isMaskDisabled) BOOL maskDisabled;


/**
 视图显示效果
 */
@property (nonatomic, assign) TLPickerViewStyle pickerViewStyle;

@property (nonatomic, assign, readonly) NSUInteger selectedTime;

/**
 容器的边距设置
 */
@property (nonatomic, assign, readonly) CGPoint contentOffset;



@property (nonatomic) NSInteger beginTime; //录像起始时间, 是自1970的秒数

@property (nonatomic) NSInteger endTime;

- (void)reloadData;

//时间, 是自1970的秒数
- (void)scrollToTime:(NSUInteger)time animated:(BOOL)animated;

//时间, 是自1970的秒数
- (void)selectTime:(NSUInteger)time animated:(BOOL)animated;


@end
