//
//  ParallelWindowCell+aboutParallel.m
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import "ParallelWindowCell+aboutParallel.h"
#import "CellModel.h"
#import "UIView+Frame.h"

@implementation ParallelWindowCell (aboutParallel)

#pragma mark - PublicFunc

- (void)configCurrentImageustcYWithWindowHeight:(CGFloat)windowHeight
                                 maxVisibleHeight:(CGFloat)maxVisibleHeight
                                    adImageHeight:(CGFloat)adImageHeight
                          currentRectForSuperView:(CGRect)currentRectForSuperView
                                             newY:(CGFloat)newY
                                             oldY:(CGFloat)oldY {
    //cell相对于tableview的父view相对坐标的Y
    CGFloat currentRectForSuperViewY = currentRectForSuperView.origin.y;
    if (self.adWindowMaxDistance <= 0) {
        return;
    }
    
    if (currentRectForSuperViewY < self.adImageBottomLine && currentRectForSuperViewY > -self.imageBoard.ustc_y) {
        //素材高度不等于可见区域，相应的调整素材的位置
        //计算DIFF tableview滑动的距离
        CGFloat diff = newY - oldY;
        
        if (adImageHeight == maxVisibleHeight) {
            self.parallelAdBG.ustc_y += diff;
            return;
        }
        
        CGFloat totalDiff = 0.0f;//完整DIFF
        NSInteger factor = (adImageHeight > maxVisibleHeight) ? 1 : -1;//相对位移的乘法因子
        CGFloat parallelAdBGNeedChangeDistance = 0.0f;//平行视窗需要移动的绝对位移
        CGFloat remainderADImageDistance = 0.0f;//平行windowimage还需要移动的距离
        CGFloat remainderWindowDistance = 0.0f;//平行视窗还需要移动的距离
        
        currentRectForSuperViewY = currentRectForSuperViewY + diff;
        if (diff > 0) {
            //向上
            if (adImageHeight > maxVisibleHeight) {
                remainderADImageDistance = - self.parallelAdBG.ustc_y - currentRectForSuperViewY - self.imageBoard.ustc_y;
                remainderWindowDistance = currentRectForSuperViewY + self.imageBoard.ustc_y;
            } else if (adImageHeight < maxVisibleHeight) {
                remainderADImageDistance = currentRectForSuperViewY  + self.parallelAdBG.ustc_y + self.imageBoard.ustc_y;
                remainderWindowDistance = currentRectForSuperViewY + self.imageBoard.ustc_y;
            }
        } else if (diff < 0) {
            //向下
            if (adImageHeight > maxVisibleHeight) {
                //计算思路同上
                CGFloat adImageUnderWindowTop = adImageHeight + self.parallelAdBG.ustc_y;//图片从窗口位置下面的高度
                CGFloat adImageBetweenMaxBottomAndWindowTop = maxVisibleHeight - currentRectForSuperViewY - self.imageBoard.ustc_y;//图片在窗口顶到最大可视范围以上的高度
                remainderADImageDistance = adImageUnderWindowTop - adImageBetweenMaxBottomAndWindowTop;//已经移动的图片位移
                remainderWindowDistance = maxVisibleHeight - currentRectForSuperViewY - self.imageBoard.ustc_y - self.imageBoard.ustc_height;
            } else if (adImageHeight < maxVisibleHeight) {
                remainderADImageDistance = maxVisibleHeight - currentRectForSuperViewY - adImageHeight - self.parallelAdBG.ustc_y - self.imageBoard.ustc_y;
                remainderWindowDistance = maxVisibleHeight - currentRectForSuperViewY - self.imageBoard.ustc_y - self.imageBoard.ustc_height;
            }
        }
        
        if (remainderWindowDistance != 0) {
            //背景大图需要移动的距离
            parallelAdBGNeedChangeDistance = diff*remainderADImageDistance/remainderWindowDistance;
            //计算总的diff
            totalDiff += diff + factor * parallelAdBGNeedChangeDistance;
            //计算新的y值
            self.parallelAdBG.ustc_y += totalDiff;
        }
        
        //这里是临界值保护 最大值+最小值保护
        if (self.parallelAdBG.ustc_y > 0) {
            self.parallelAdBG.ustc_y = 0;
        }
        if (self.parallelAdBG.ustc_y < -(adImageHeight - windowHeight)) {
            self.parallelAdBG.ustc_y = -(adImageHeight - windowHeight);
        }
    } else {
        self.parallelAdBG.ustc_y = [self calculateCurrentImageustcYWithWindowHeight:windowHeight maxVisibleHeight:maxVisibleHeight adImageHeight:adImageHeight currentRectForSuperView:currentRectForSuperView];
    }
}

- (void)configParallerBGWithViewModel:(CellModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
    //图片真实高度
    [self.parallelAdBG setImage:[UIImage imageNamed:@"parallelwindow"]];
    CGFloat imageHeight = self.parallelAdBG.image.size.height;
    CGFloat imageWidth = self.parallelAdBG.image.size.width;
    if (imageWidth > 0) {
        CGFloat calculateHeight = (COVERNEWSCELL_IMAGE_WIDTH * imageHeight) / imageWidth;
        
        //test 短图
        if (viewModel.cellType == CellTypeParallelShort) {
            calculateHeight = [UIScreen mainScreen].bounds.size.height - 150;
        }
        
        CGFloat initialImageY = [self calculateInitialImageYWithImageHeight:calculateHeight atIndexPath:indexPath];
        self.parallelAdBG.frame = CGRectMake(0, initialImageY, COVERNEWSCELL_IMAGE_WIDTH, calculateHeight);
        self.parallelAdBG.hidden = NO;
    }
}

- (void)configHasParallerBG {
    [self.coverImageView setImage:nil];
    self.isParallelAd = YES;
}

- (void)configNoParallerBG {
    self.parallelAdBG.hidden = YES;
    self.parallelAdBG.image = nil;
    self.isParallelAd = NO;
}

- (void)calculateAllAnimationElementWithImageHeight:(CGFloat)adImageHeight {
    UITableView *tableView = [self relatedTableView];
    if (tableView) {
        //首先计算几个临界值
        CGSize maxVisibleRectForWindowAD = CGSizeMake(COVERNEWSCELL_IMAGE_WIDTH, tableView.ustc_height);//平行window所能展示的最大Size
        CGFloat bottomLine = maxVisibleRectForWindowAD.height - self.imageBoard.ustc_y;//图片在屏幕下方将要出现的临界位置
        CGFloat topLine = -(self.imageBoard.ustc_y + COVERNEWSCELL_IMAGE_HEIGHT);//窗口完整消失的临界点
        CGFloat adImageBottomLine = bottomLine - COVERNEWSCELL_IMAGE_HEIGHT;//窗口完整出现的临界点
        //整个滑动过程中，背景图片所要滑动的全程距离是
        CGFloat allDistanceForADImage = fabs(adImageHeight - maxVisibleRectForWindowAD.height);
        
        self.maxVisibleRectForWindowAD = maxVisibleRectForWindowAD;
        self.bottomLine = bottomLine;
        self.topLine = topLine;
        self.adImageBottomLine = adImageBottomLine;
        self.allDistanceForADImage = allDistanceForADImage;
        self.adWindowMaxDistance = maxVisibleRectForWindowAD.height - COVERNEWSCELL_IMAGE_HEIGHT;
    }
}

#pragma mark - HelpFunc

- (CGFloat)calculateInitialImageYWithImageHeight:(CGFloat)imageHeight atIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = [self relatedTableView];
    UIView *relatedSuperView = [self relatedSuperViewContainerView];
    if ([tableView isKindOfClass:[UITableView class]] && relatedSuperView && tableView) {
        CGFloat maxHeight = tableView.ustc_height;
        CGRect originRect = [tableView rectForRowAtIndexPath:indexPath];
        CGRect convertRect = [tableView convertRect:originRect toView:relatedSuperView];
        
        //首先计算几个临界值
        [self calculateAllAnimationElementWithImageHeight:imageHeight];
        
        return [self calculateCurrentImageustcYWithWindowHeight:COVERNEWSCELL_IMAGE_HEIGHT maxVisibleHeight:maxHeight adImageHeight:imageHeight currentRectForSuperView:convertRect];
    }
    
    return 0.0;
}

- (UITableView *)relatedTableView {
    if ([self.superview isKindOfClass:[UITableView class]]) {
        return (UITableView *)self.superview;
    } else if([self.superview.superview isKindOfClass:[UITableView class]]) {
        return (UITableView *)self.superview.superview;
    } else {
        return nil;
    }
}

- (UIView *)relatedSuperViewContainerView {
    if ([self.superview isKindOfClass:[UITableView class]]) {
        return (UIView *)self.superview.superview;
    } else if([self.superview.superview isKindOfClass:[UITableView class]]) {
        return (UIView *)self.superview.superview.superview;
    } else {
        return nil;
    }
}

- (CGFloat)calculateCurrentImageustcYWithWindowHeight:(CGFloat)windowHeight
                                       maxVisibleHeight:(CGFloat)maxVisibleHeight
                                          adImageHeight:(CGFloat)adImageHeight
                                currentRectForSuperView:(CGRect)currentRectForSuperView {
    //cell相对于tableview的父view相对坐标的Y
    CGFloat currentRectForSuperViewY = currentRectForSuperView.origin.y;
    //当前窗口真实滑动的距离
    CGFloat windowRealDistance = self.bottomLine - currentRectForSuperViewY;
    
    CGFloat finalY = 0.0f;
    if (currentRectForSuperViewY == self.bottomLine) {
        finalY = - adImageHeight;
    } else if (currentRectForSuperViewY < self.bottomLine && currentRectForSuperViewY > self.adImageBottomLine) {
        finalY = - adImageHeight + windowRealDistance;
    } else if (currentRectForSuperViewY == self.adImageBottomLine) {
        finalY = -(adImageHeight - windowHeight);
    } else if (currentRectForSuperViewY < self.adImageBottomLine && currentRectForSuperViewY > -self.imageBoard.ustc_y) {
        //相对位移阶段，也是最复杂的阶段
        if (adImageHeight == maxVisibleHeight) {
            finalY = -currentRectForSuperViewY;
        } else if (adImageHeight > maxVisibleHeight) {
            //窗口最大滑动距离
            CGFloat windowTopMax = maxVisibleHeight - windowHeight;
            //当前距离顶部有多少
            CGFloat currentTop = currentRectForSuperViewY + self.imageBoard.ustc_y;
            //计算得出当前window图距离它的最上边的距离
            if (windowTopMax != 0) {
                CGFloat currentAdTop = (self.allDistanceForADImage * currentTop) / windowTopMax;
                finalY = -(currentRectForSuperViewY + self.imageBoard.ustc_y + currentAdTop);
            } else {
                finalY = -currentRectForSuperViewY;
            }
        } else if (adImageHeight < maxVisibleHeight) {
            //窗口最大滑动距离
            CGFloat windowTopMax = maxVisibleHeight - windowHeight;
            //当前距离顶部有多少
            CGFloat currentTop = currentRectForSuperViewY + self.imageBoard.ustc_y;
            //计算得出当先window图距离它的最上边的距离
            if (windowTopMax != 0) {
                CGFloat currentAdTop = (self.allDistanceForADImage * currentTop) / windowTopMax;
                finalY = -(currentRectForSuperViewY + self.imageBoard.ustc_y - currentAdTop);
            } else {
                finalY = -currentRectForSuperViewY;
            }
        }
        //保护
        finalY = MIN(finalY, 0);
        finalY = MAX(finalY, -(adImageHeight - windowHeight));
    } else if (currentRectForSuperViewY == -self.imageBoard.ustc_y) {
        finalY = 0;
    } else if (currentRectForSuperViewY < -self.imageBoard.ustc_y && currentRectForSuperViewY > self.topLine) {
        finalY =  - currentRectForSuperViewY - self.imageBoard.ustc_y;
    } else if (currentRectForSuperViewY == self.topLine) {
        finalY = -self.topLine;
    }
    return finalY;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kParallelWindowObserverKeyPath] && [object isKindOfClass:[UITableView class]]) {
        UITableView *observedTableView = (UITableView *)object;
        CGFloat newY = [change[@"new"] CGPointValue].y;
        CGFloat oldY = [change[@"old"] CGPointValue].y;
        CGRect originRect = [observedTableView rectForRowAtIndexPath:self.currentCellIndex];
        CGRect convertRect = [observedTableView convertRect:originRect toView:observedTableView.superview];
        if (self.parallelAdBG.image) {
            [self configCurrentImageustcYWithWindowHeight:COVERNEWSCELL_IMAGE_HEIGHT maxVisibleHeight:observedTableView.ustc_height adImageHeight:self.parallelAdBG.ustc_height currentRectForSuperView:convertRect newY:newY oldY:oldY];
        }
    }
}

- (void)reloadParalledBG {
    CGFloat imageWidth = self.parallelAdBG.ustc_width;
    if (imageWidth > 0) {
        CGFloat initialImageY = [self calculateInitialImageYWithImageHeight:self.parallelAdBG.ustc_height atIndexPath:self.currentCellIndex];
        [UIView animateWithDuration:0.2 animations:^{
            self.parallelAdBG.ustc_y = initialImageY;
        }];
    }
}


@end
