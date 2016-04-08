//
//  XYCenterAlert.h
//  Wind
//
//  Created by XiaoYou on 16/4/8.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYCenterAlert;

@protocol  XYCenterAlertDelegate<NSObject>

@optional
- (void)CenterAlertView:(XYCenterAlert *)centerAlert ensureBtnPressed:(UIButton *)button;

@end

@interface XYCenterAlert : UIView

@property(nonatomic, assign) id<XYCenterAlertDelegate> delegate;

@end
