//
//  ViewController.m
//  TimeLineView
//
//  Created by soyute on 2017/5/31.
//  Copyright © 2017年 soyute. All rights reserved.
//

#import "ViewController.h"

#import "TLPickerView.h"
#import "VideoAngleView.h"

@interface ViewController () <TLPickerViewDelegate>

@property (nonatomic, strong) TLPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UILabel *dateLbl;
@property (nonatomic, strong) NSString *todayString;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    CGRect frame = CGRectMake(0, 120, self.view.frame.size.width, 80);
    self.pickerView = [[TLPickerView alloc] initWithFrame:frame];
    self.pickerView.delegate = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pickerView];
    
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = TLPickerViewStyleFlat;
    //	self.pickerView.maskDisabled = false;
    
    
    //用秒计算间隔
    NSDate *begin = [NSDate dateWithTimeIntervalSinceNow:- 15 * 24 * 60 * 60];
    NSInteger timeInterval = [begin timeIntervalSince1970];
    self.pickerView.beginTime = timeInterval;
    
    NSInteger time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    self.pickerView.endTime = time;
    
    [self.pickerView reloadData];
    [self.pickerView selectTime:time animated:NO];
    
    
    NSInteger width = 100;
    NSInteger height = 50;
    self.dateLbl = [UILabel new];
    self.dateLbl.backgroundColor = [UIColor whiteColor];
    self.dateLbl.textAlignment = NSTextAlignmentCenter;
    self.dateLbl.textColor = [UIColor redColor];
    self.dateLbl.layer.masksToBounds = YES;
    self.dateLbl.layer.cornerRadius = 25;
    self.dateLbl.frame = CGRectMake((self.view.frame.size.width - width) / 2.0f, 50, width, height);
    [self.view addSubview:self.dateLbl];
    
    
    self.todayString = [self stringFromDate:time];
    
    
    
    self.view.backgroundColor = [UIColor grayColor];
    VideoAngleView *angleView = [VideoAngleView new];
    angleView.backgroundColor = [UIColor whiteColor];
    angleView.frame = CGRectMake(0, 250, self.view.frame.size.width, 400);
    [self.view addSubview:angleView];
    
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(TLPickerView *)pickerView
{
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(TLPickerView *)pickerView titleForItem:(NSInteger)item
{
    return self.titles[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate
//
//- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
//{
//	NSLog(@"%@", self.titles[item]);
//}

-(NSString*)stringFromDate:(NSInteger)timeFrom1970 {
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeFrom1970];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

-(void)pickerView:(TLPickerView *)pickerView didSelectTime:(NSInteger)time {
    
    NSString *timeString = [self stringFromDate:time];
    if ([timeString isEqualToString:self.todayString]) {
        timeString = @"今天";
    }
    
    self.dateLbl.text = timeString;
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
 saturation:1.0
 brightness:1.0
 alpha:1.0];
 }
 */

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
