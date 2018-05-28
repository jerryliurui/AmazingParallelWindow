//
//  ParallelWindowCell.h
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kParallelWindowObserverKeyPath = @"contentOffset";
#define COVERNEWSCELL_IMAGE_WIDTH  ([UIScreen mainScreen].bounds.size.width-2*11)
#define COVERNEWSCELL_IMAGE_HEIGHT floorf(COVERNEWSCELL_IMAGE_WIDTH /2)

@class CellModel;

@interface ParallelWindowCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *imageBoard;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImageView *parallelAdBG;//平行windo
@property (nonatomic, strong) NSIndexPath *currentCellIndex;//当前所处的indexPath
@property (nonatomic, assign) BOOL isParallelAd;

//平行window相关参数
@property (nonatomic, assign) CGSize maxVisibleRectForWindowAD;//平行window所能展示的最大Size
@property (nonatomic, assign) CGFloat bottomLine;//图片在屏幕下方将要出现的临界位置
@property (nonatomic, assign) CGFloat topLine;//窗口完整消失的临界点
@property (nonatomic, assign) CGFloat adImageBottomLine;//窗口完整出现的临界点
@property (nonatomic, assign) CGFloat allDistanceForADImage;//整个滑动过程中，背景图片所要滑动的全程距离
@property (nonatomic, assign) CGFloat adWindowMaxDistance;//adWindow中间状态所能够滑动的最大距离

- (void)fillDataWithViewModel:(CellModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

@end
