//
//  AKCollectionViewLayout.h
//  AKPickerViewSample
//
//  Created by soyute on 2017/5/29.
//  Copyright © 2017年 Akkyie Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLPickerView.h"

@class TLPickerView;
@class TLCollectionViewLayout;



//这个协议，为的的是用来获取当前视图显示效果，是否为‘平铺’，还是'3D'
@protocol TLCollectionViewLayoutDelegate <NSObject>

- (TLPickerViewStyle)pickerViewStyleForCollectionViewLayout:(TLCollectionViewLayout *)layout;

@end





@interface TLCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id <TLCollectionViewLayoutDelegate> delegate;

@end
