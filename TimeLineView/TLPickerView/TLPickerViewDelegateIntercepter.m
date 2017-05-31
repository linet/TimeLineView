//
//  AKPickerViewDelegateIntercepter.m
//  AKPickerViewSample
//
//  Created by soyute on 2017/5/29.
//  Copyright © 2017年 Akkyie Y. All rights reserved.
//

#import "TLPickerViewDelegateIntercepter.h"


@implementation TLPickerViewDelegateIntercepter


- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.pickerView respondsToSelector:aSelector]) return self.pickerView;
    if ([self.delegate respondsToSelector:aSelector]) return self.delegate;
    
    return [super forwardingTargetForSelector:aSelector];
}


- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.pickerView respondsToSelector:aSelector]) return YES;
    if ([self.delegate respondsToSelector:aSelector]) return YES;
    
    return [super respondsToSelector:aSelector];
}

@end
