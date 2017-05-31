//
//  AKPickerViewDelegateIntercepter.h
//  AKPickerViewSample
//
//  Created by soyute on 2017/5/29.
//  Copyright © 2017年 Akkyie Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLPickerView.h"

@class TLPickerView;

@interface TLPickerViewDelegateIntercepter : NSObject <UICollectionViewDelegate>

@property (nonatomic, weak) TLPickerView *pickerView;

@property (nonatomic, weak) id <UIScrollViewDelegate> delegate;

@end
