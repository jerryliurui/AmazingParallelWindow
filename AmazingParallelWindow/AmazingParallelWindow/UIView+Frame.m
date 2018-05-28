//
//  UIView+Frame.m
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - Right

- (void)setustc_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)ustc_right {
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark - Bottom

- (void)setustc_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)ustc_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

#pragma mark - Origin

-(void)setustc_origin:(CGPoint)origin {
    CGRect rc = self.frame;
    rc.origin = origin;
    self.frame = rc;
}

-(CGPoint)ustc_origin {
    return self.frame.origin;
}

#pragma mark - Top

- (CGFloat)ustc_top {
    return self.frame.origin.y;
}

- (void)setustc_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

#pragma mark - Left

- (CGFloat)ustc_left {
    return self.frame.origin.x;
}

- (void)setustc_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setustc_x:(CGFloat)x {
    CGRect rc = self.frame;
    rc.origin.x = x;
    self.frame = rc;
}

-(void)setustc_y:(CGFloat)y {
    CGRect rc = self.frame;
    rc.origin.y = y;
    self.frame = rc;
}

-(void)setustc_size:(CGSize)sz {
    CGRect rc = self.frame;
    rc.size = sz;
    self.frame = rc;
}
-(void)setustc_width:(CGFloat)w {
    CGRect rc = self.frame;
    rc.size.width = w;
    self.frame = rc;
}

-(void)setustc_height:(CGFloat)h {
    CGRect rc = self.frame;
    rc.size.height = h;
    self.frame = rc;
}

-(void)setustc_centerY:(CGFloat)y {
    CGPoint pt = self.center;
    pt.y = y;
    self.center = pt;
}

-(void)setustc_centerX:(CGFloat)x {
    CGPoint pt = self.center;
    pt.x = x;
    self.center = pt;
}

-(CGFloat)ustc_x {
    return self.frame.origin.x;
}

-(CGFloat)ustc_y {
    return self.frame.origin.y;
}

-(CGSize)ustc_size {
    return self.frame.size;
}

-(CGFloat)ustc_height {
    return self.frame.size.height;
}

-(CGFloat)ustc_width {
    return self.frame.size.width;
}

-(CGFloat)ustc_centerX {
    return self.center.x;
}

-(CGFloat)ustc_centerY {
    return self.center.y;
}

-(CGFloat)ustc_maxX {
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)ustc_maxY {
    return CGRectGetMaxY(self.frame);
}
@end
