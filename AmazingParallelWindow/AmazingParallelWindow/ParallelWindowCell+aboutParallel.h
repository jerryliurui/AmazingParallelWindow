//
//  ParallelWindowCell+aboutParallel.h
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import "ParallelWindowCell.h"

@interface ParallelWindowCell (aboutParallel)

/**
 用来实时计算和调整当前平行window大图背景的相对位置，主要是调整Y
 
 @param windowHeight 可视窗口高度
 @param maxVisibleHeight 整个屏幕中，可以看到大图的最大高度
 @param adImageHeight 实际的大图高度
 @param currentRectForSuperView 当前cell相对于tableView的父视图的相对坐标Rect
 @param newY KVO观察到的新的tableview contentoffset
 @param oldY KVO观察到的旧的tableview contentoffset
 */
- (void)configCurrentImageustcYWithWindowHeight:(CGFloat)windowHeight
                                 maxVisibleHeight:(CGFloat)maxVisibleHeight
                                    adImageHeight:(CGFloat)adImageHeight
                          currentRectForSuperView:(CGRect)currentRectForSuperView
                                             newY:(CGFloat)newY
                                             oldY:(CGFloat)oldY;


/**
 fillModel之后初始化ParallelBG
 
 @param viewModel cell当前的viewmodel
 @param indexPath cell当前所处的indexPath
 */
- (void)configParallerBGWithViewModel:(CellModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

/**
 处理是或者不是平行window类型的cell的情况
 */
- (void)configHasParallerBG;
- (void)configNoParallerBG;

/**
 重置bg的位置，调整动画位移
 */
- (void)reloadParalledBG;

@end
