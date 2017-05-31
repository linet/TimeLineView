//
//  AKCollectionViewCell.m
//  AKPickerViewSample
//
//  Created by soyute on 2017/5/29.
//  Copyright © 2017年 Akkyie Y. All rights reserved.
//

#import "TLCollectionViewCell.h"

#define LINE_WIDTH           0.5
#define LINE_HEIGHT          10
#define LINE_HEIGHT2         15
#define LINE_HEIGHT3         35

#define PADDING_LEFT         1.5
//#define PADDING_LEFT         (3 - LINE_WIDTH) / 2.0f



@interface TLCollectionViewCell ()


@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;


@end

@implementation TLCollectionViewCell


-(UIView *)line1 {
    if (!_line1) {
        _line1 = [UIView new];
        _line1.frame = CGRectMake(PADDING_LEFT, 0, LINE_WIDTH, LINE_HEIGHT);
        _line1.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_line1];
    }
    return _line1;
}



-(UIView *)line2 {
    if (!_line2) {
        _line2 = [UIView new];
        _line2.frame = CGRectMake(PADDING_LEFT, self.frame.size.height - LINE_HEIGHT, LINE_WIDTH, LINE_HEIGHT);
        _line2.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_line2];
    }
    return _line2;
}

- (void)initialize
{
    self.layer.doubleSided = NO;
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 3, 20)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 1;
    self.label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.label.highlightedTextColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:10];
    self.label.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleRightMargin);
    [self.contentView addSubview:self.label];
    
    
    
    
    self.line1.hidden = NO;
    self.line2.hidden = NO;
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


-(void)setAvailableTime:(BOOL)availableTime {
    
    self.contentView.backgroundColor = availableTime ? [[UIColor blueColor] colorWithAlphaComponent:0.5] : [UIColor clearColor];
}


-(void)setTimeFrom1970:(NSInteger)timeFrom1970 {
    
    _timeFrom1970 = timeFrom1970;
    if (timeFrom1970 > 0) {
        
        //小时位置
        if (timeFrom1970 % (60 * 60) == 0) {
            
            [self setTimeHeight:LINE_HEIGHT3];
            
            
            [self setTextString:[self stringFromDate:timeFrom1970]];
//            [self setTimeText:[self stringFromDate:timeFrom1970]];
            //            self.label.hidden = NO;
        }
        //10分制位置
        else if (timeFrom1970 % (60 * 10) == 0)
        {
            
            [self setTimeHeight:LINE_HEIGHT2];
//            self.lblTime.hidden = YES;
            //            self.label.text = @"";
            
            [self setTextString:@""];
//            NSLog(@"----------->MM=%ld", (long)timeFrom1970);
        } else {
            [self setTimeHeight:LINE_HEIGHT];
//            self.lblTime.hidden = YES;
            //            self.label.text = @"";
            
            [self setTextString:@""];
//            NSLog(@"----------->SS=%ld", (long)timeFrom1970);
            
        }
        
    }
}


-(NSString*)stringFromDate:(NSInteger)timeFrom1970 {
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeFrom1970];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}


-(void)setTimeHeight:(NSInteger)height {
    
    CGRect frame = self.line1.frame;
    frame.size.height = height;
    self.line1.frame = frame;
    
    frame = self.line2.frame;
    frame.origin.y = self.frame.size.height - height;
    frame.size.height = height;
    self.line2.frame = frame;
    
}


-(void)setTextString:(NSString *)textString {
    if (!textString) {
        textString = @"";
    }
//    _textString = textString;
    
    self.label.text = textString;
    
    
    self.label.bounds = (CGRect){CGPointZero, [self sizeForString:textString]};
}



//根据字体计算字符串需要的大小位置
- (CGSize)sizeForString:(NSString *)string
{
    CGSize size;
    CGSize highlightedSize;
    
    size = [string sizeWithFont:self.label.font];
    highlightedSize = [string sizeWithFont:self.label.font];
    
    CGSize size1 = CGSizeMake(ceilf(MAX(size.width, highlightedSize.width)), ceilf(MAX(size.height, highlightedSize.height)));
    return size1;
}

@end
