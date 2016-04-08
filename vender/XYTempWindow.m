//
//  XYTempWindow.m
//  Wind
//
//  Created by XiaoYou on 16/4/7.
//  Copyright © 2016年 XY. All rights reserved.
//

#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define k_NotiCenter [NSNotificationCenter defaultCenter];


#import "XYTempWindow.h"
#import "XYTableViewController.h"
#import "XYViewController.h"
#import "XYCenterAlert.h"

@interface XYTempWindow ()<XYCenterAlertDelegate>

@end

@implementation XYTempWindow
{
    XYCenterAlert *_centerAlert;
}

+ (instancetype)window
{
    static id window = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        window = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return window;
}

- (void)show
{
    // 这个rootWindow必须要设置，了半天弯路
    self.rootViewController = [[XYViewController alloc] init];
    [self makeKeyWindow];
//    self.windowLevel = UIWindowLevelAlert;
    self.hidden = NO;
    NSLog(@"_______ ---show---");
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        // 先添加浮层蒙版
        [self setupMenBan];
        
        // 添加中间提示框
        [self setupCenterAlert];
        
        // 自己的背景颜色 -- window 不支持通过设置imageView设置bgView
        UIImage *image = [UIImage imageNamed:@"myself"]; // 默认
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}
/**拦截setBackgroundColor方法，可以给用户自定义背景图片*/
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    
    
    [super setBackgroundColor:backgroundColor];
}


/**设置一层蒙版*/
- (void)setupMenBan
{
    UIView *menBan = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    menBan.backgroundColor = [UIColor colorWithRed:10/255 green:10/255 blue:10/255 alpha:0.3];
    [self addSubview:menBan];

}

/**设置中间的alertView*/
- (void)setupCenterAlert
{
    XYCenterAlert *centerAlert = [[XYCenterAlert alloc] init];
    centerAlert.center = self.center;
    centerAlert.delegate = self;
    [self addSubview:centerAlert];
    _centerAlert = centerAlert;
}

/**监听window的点击*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 发送一个通知让键盘收回
    NSNotification *notifi = [[NSNotification alloc] initWithName:@"touchBegan" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notifi];
}


#pragma mark - XYCenterAlertDelegate
- (void)CenterAlertView:(XYCenterAlert *)centerAlert ensureBtnPressed:(UIButton *)button
{
    // 中间确认按钮点击，自己注销keyWindow
    [self resignKeyWindow];
    self.hidden = YES;  // 隐藏
}


@end
