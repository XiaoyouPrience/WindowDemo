//
//  XYCenterAlert.m
//  Wind
//
//  Created by XiaoYou on 16/4/8.
//  Copyright © 2016年 XY. All rights reserved.
//

#define k_NotiCenter [NSNotificationCenter defaultCenter];

#import "XYCenterAlert.h"

@implementation XYCenterAlert
{
    UITextField *_textField;
    UIButton *_ensureBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        CGFloat bgW = 200;
        CGFloat bgH = bgW;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, bgW, bgH);
        bgView.center = self.center;
        bgView.layer.cornerRadius = 5;
        bgView.backgroundColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:.5];
        [self addSubview:bgView];
        
        // label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.center = CGPointMake(bgW/2, bgH/4);
        label.text = @"你好，请验证密码";
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        textField.center = CGPointMake(bgW/2, bgH/3 + 20);
        textField.layer.cornerRadius = 5;
        //textField.clipsToBounds = YES;
        textField.borderStyle = UITextBorderStyleLine;
        textField.layer.borderWidth = 1;
        //textField.layer.borderColor = [UIColor yellowColor].CGColor;
        textField.backgroundColor = [UIColor whiteColor];
        textField.secureTextEntry = YES;
        textField.placeholder = @"请输入密码";
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [bgView addSubview:textField];
        _textField = textField;
        
        UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ensureBtn.frame= CGRectMake(0, 0, 100, 40);
        ensureBtn.center = CGPointMake(bgW/2, bgH/2 + 40);
        ensureBtn.layer.cornerRadius = 5;
        ensureBtn.titleLabel.textColor = [UIColor blackColor];
        ensureBtn.backgroundColor = [UIColor blueColor];
        [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [ensureBtn addTarget:self action:@selector(CompleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:ensureBtn];
        _ensureBtn = ensureBtn;

        // 注册观察者，接收通知。
        [self acceptNotification];
        
    }
    return self;
}
/**
 *  注册观察者，接收通知。
 */
- (void)acceptNotification
{
    NSNotificationCenter *center = k_NotiCenter;
    [center addObserver:self selector:@selector(resign) name:@"touchBegan" object:nil];
}
/**
 *  移除观察者
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  监听window被点击时候收起键盘的动作
 */
- (void)resign
{
    [_textField resignFirstResponder];
}

/**
 *  拦截用户设置frame--只可以设置位置center || size
 */
- (void)setFrame:(CGRect)frame
{

    frame.size = CGSizeMake(200, 200);
    self.center = CGPointMake(375/2, 667/2);
    
    [super setFrame:frame];
}

/**完成按钮点击事件*/
- (void)CompleteBtnPressed:(UIButton *)btn
{
    if ([_textField.text isEqualToString:@"abcd"]) {
        
        [_textField resignFirstResponder];
        // 1.因为是单例，要清除每次输入过的记录，防止下一次还有这个text
        _textField.text = nil;

        // 2.调用代理方法
        if ([self.delegate respondsToSelector:@selector(CenterAlertView:ensureBtnPressed:)]) {
            [self.delegate CenterAlertView:self ensureBtnPressed:_ensureBtn];
        }
    }else
    {
        _textField.text = nil;
        [self showErrorAlertView];
    }
    
}

/**密码错误提示*/
- (void)showErrorAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"密码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}


@end
