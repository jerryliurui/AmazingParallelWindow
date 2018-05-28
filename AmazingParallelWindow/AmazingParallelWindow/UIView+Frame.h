//
//  UIView+Frame.h
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, getter = ustc_top, setter = setustc_top:) CGFloat ustc_y;
@property (nonatomic, getter = ustc_left, setter = setustc_left:) CGFloat ustc_x;
@property (nonatomic) CGFloat ustc_right;
@property (nonatomic) CGFloat ustc_bottom;

-(void)setustc_origin:(CGPoint)loc;
-(void)setustc_x:(CGFloat)x;
-(void)setustc_y:(CGFloat)y;
-(void)setustc_size:(CGSize)sz;
-(void)setustc_width:(CGFloat)w;
-(void)setustc_height:(CGFloat)h;
-(void)setustc_centerX:(CGFloat)x;
-(void)setustc_centerY:(CGFloat)y;

-(CGSize)ustc_size;
-(CGPoint)ustc_origin;

-(CGFloat)ustc_x;
-(CGFloat)ustc_y;
-(CGFloat)ustc_left;
-(CGFloat)ustc_top;
-(CGFloat)ustc_bottom;
-(CGFloat)ustc_right;
-(CGFloat)ustc_height;
-(CGFloat)ustc_width;
-(CGFloat)ustc_centerX;
-(CGFloat)ustc_centerY;
-(CGFloat)ustc_maxX;
-(CGFloat)ustc_maxY;

@end
