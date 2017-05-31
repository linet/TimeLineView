//
//  VideoAngleView.m
//  AKPickerViewSample
//
//  Created by soyute on 2017/5/31.
//  Copyright © 2017年 Akkyie Y. All rights reserved.
//

#import "VideoAngleView.h"

#define TEXT_WIDTH              35
#define TEXT_HEIGHT             15


#define startAngle              (M_PI + M_PI / 4.0f)
#define endAngle                (M_PI + M_PI * 3.0f / 4.0f)
#define padding                 5


@interface VideoAngleView ()


@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat radius1;
@property (nonatomic) CGFloat radius2;

@property (nonatomic) CGFloat center_x1;
@property (nonatomic) CGFloat center_y1;
@property (nonatomic) CGFloat center_x2;
@property (nonatomic) CGFloat center_y2;

@property (nonatomic) CGFloat left_x1;
@property (nonatomic) CGFloat left_y1;
@property (nonatomic) CGFloat left_x2;
@property (nonatomic) CGFloat left_y2;

@property (nonatomic) CGFloat right_x1;
@property (nonatomic) CGFloat right_y1;
@property (nonatomic) CGFloat right_x2;
@property (nonatomic) CGFloat right_y2;

@property (nonatomic, strong) UILabel *leftLbl;
@property (nonatomic, strong) UILabel *rightLbl;


@end



@implementation VideoAngleView


-(UILabel *)leftLbl {
    if (!_leftLbl) {
        _leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TEXT_WIDTH, TEXT_HEIGHT)];
        _leftLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:_leftLbl];
    }
    return _leftLbl;
}

-(UILabel *)rightLbl {
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TEXT_WIDTH, TEXT_HEIGHT)];
        [self addSubview:_rightLbl];
    }
    return _rightLbl;
}


-(void)setFont:(UIFont *)font {
    _font = font;
    self.leftLbl.font = self.rightLbl.font = font;
}

-(void)setCurveColor:(UIColor *)curveColor {
    _curveColor = curveColor;
    self.leftLbl.textColor = self.rightLbl.textColor = curveColor;
}


-(void)setStartAngleText:(NSString *)startAngleText {
    _startAngleText = startAngleText;
    
    
    self.leftLbl.text = startAngleText;
}

-(void)setEndAngleText:(NSString *)endAngleText {
    _endAngleText = endAngleText;
    
    
    self.rightLbl.text = endAngleText;
    
    
    
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



- (void)initialize
{
    self.font = self.font ?: [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.startAngleText = self.startAngleText ?: @"0";
    self.endAngleText = self.endAngleText ?: @"150";
    
    self.curveColor = self.curveColor ?: [UIColor redColor];
    
    self.x = 100;
    self.y = 100;
    self.radius = 80;
    
    self.radius1 = self.radius + padding;
    self.radius2 = self.radius - padding;
    
    
    self.center_x1 = self.x;
    self.center_x2 = self.x;
    self.center_y1 = self.y - self.radius1;
    self.center_y2 = self.y - self.radius2;
    
    //边线1
    self.left_x1 = self.x + self.radius1 * cosf(startAngle);
    self.left_y1 = self.y + self.radius1 * sinf(startAngle);
    self.left_x2 = self.x + self.radius2 * cosf(startAngle);
    self.left_y2 = self.y + self.radius2 * sinf(startAngle);
    
    
    self.right_x1 = self.x + self.radius1 * cosf(endAngle);
    self.right_y1 = self.y + self.radius1 * sinf(endAngle);
    self.right_x2 = self.x + self.radius2 * cosf(endAngle);
    self.right_y2 = self.y + self.radius2 * sinf(endAngle);
    
    [self setTextPosition];
}


-(void)setTextPosition {
    
    CGFloat x = self.left_x1 - TEXT_WIDTH - 5;
    CGFloat y = self.left_y1;
    self.leftLbl.frame = CGRectMake(x, y, TEXT_WIDTH, TEXT_HEIGHT);
    
    
    x = self.right_x1 + 5;
    y = self.right_y1;
    self.rightLbl.frame = CGRectMake(x, y, TEXT_WIDTH, TEXT_HEIGHT);
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置画图相关样式参数
    
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(ctx, self.curveColor.CGColor);//设置颜色有很多方法，我觉得这个方法最好用
    //设置笔触宽度
    CGContextSetLineWidth(ctx, 2);
    //设置填充色
    CGContextSetFillColorWithColor(ctx, self.curveColor.CGColor);
    //设置拐点样式
    //    enum CGLineJoin {
    //        kCGLineJoinMiter, //尖的，斜接
    //        kCGLineJoinRound, //圆
    //        kCGLineJoinBevel //斜面
    //    };
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //Line cap 线的两端的样式
    //    enum CGLineCap {
    //        kCGLineCapButt,
    //        kCGLineCapRound,
    //        kCGLineCapSquare
    //    };
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //虚线线条样式
    //CGFloat lengths[] = {10,10};

    //画圆、圆弧
    [self drawMyCurve:ctx];
}



-(void)drawMyCurve:(CGContextRef)ctx {
    
    CGContextSetStrokeColorWithColor(ctx, self.curveColor.CGColor);
    
    /* 绘制路径 方法一
     void CGContextAddArc (
     CGContextRef c,
     CGFloat x,             //圆心的x坐标
     CGFloat y,    //圆心的x坐标
     CGFloat radius,   //圆的半径
     CGFloat startAngle,    //开始弧度
     CGFloat endAngle,   //结束弧度
     int clockwise          //0表示顺时针，1表示逆时针
     );
     */
    
    
    CGContextAddArc (ctx, self.x, self.y, self.radius, startAngle, endAngle, 0);
    CGContextStrokePath(ctx);
    
    CGPoint points1[] = {CGPointMake(self.center_x1, self.center_y1),CGPointMake(self.center_x1, self.center_y2)};
    CGContextAddLines(ctx, points1, 2);
    CGContextStrokePath(ctx);
    
    
    CGPoint points2[] = {CGPointMake(self.left_x1, self.left_y1),CGPointMake(self.left_x2, self.left_y2)};
    CGContextAddLines(ctx, points2, 2);
    CGContextStrokePath(ctx);
    
    
    //边线2
    CGPoint points3[] = {CGPointMake(self.right_x1, self.right_y1),CGPointMake(self.right_x2, self.right_y2)};
    CGContextAddLines(ctx, points3, 2);
    CGContextStrokePath(ctx);
    
    
    //位置点
    //圆
    CGFloat p = 0.4;
    CGFloat angle = startAngle + (endAngle - startAngle) * p;
    
    CGFloat x1 = self.x + self.radius * cosf(angle);
    CGFloat y1 = self.y + self.radius * sinf(angle);
    
    CGContextSetFillColorWithColor(ctx, self.curveColor.CGColor);
    CGContextAddArc (ctx, x1, y1, 5, 0, M_PI* 2 , 0);
    CGContextFillPath(ctx);

}


//画图片
-(void)drawPicture:(CGContextRef)context{
    /*图片*/
    UIImage *image = [UIImage imageNamed:@"head.jpeg"];
    [image drawInRect:CGRectMake(10, 300, 100, 100)];//在坐标中画出图片
}


//画文字
-(void)drawText:(CGContextRef)ctx{
    //文字样式
    UIFont *font = [UIFont systemFontOfSize:18];
    NSDictionary *dict = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [@"hello world" drawInRect:CGRectMake(120 , 350, 500, 50) withAttributes:dict];
}






@end
