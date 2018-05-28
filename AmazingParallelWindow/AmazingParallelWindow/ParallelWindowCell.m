//
//  ParallelWindowCell.m
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import "ParallelWindowCell.h"
#import "CellModel.h"
#import "UIView+Frame.h"
#import "ParallelWindowCell+aboutParallel.h"

@interface ParallelWindowCell()

@property (nonatomic, strong) CellModel *viewModel;
@property (nonatomic, strong) UIImageView *videoPlayImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ParallelWindowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.numberOfLines = 2;
        UIImageView *imageBoard = [UIImageView new];
        imageBoard.contentMode = UIViewContentModeCenter;
        imageBoard.clipsToBounds = YES;
        imageBoard.image = [UIImage imageNamed:@"image_placeholder"];
        imageBoard.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor grayColor].CGColor;

        [self.contentView addSubview:imageBoard];
        [imageBoard addSubview:imageView];
        
        self.coverImageView = imageView;
        self.imageBoard = imageBoard;
        
        //平行window Image
        [self.imageBoard addSubview:self.parallelAdBG];
    }
    return self;
}

- (UIImageView *)parallelAdBG {
    if (!_parallelAdBG) {
        _parallelAdBG = [[UIImageView alloc] init];
        _parallelAdBG.hidden = YES;
        _parallelAdBG.contentMode = UIViewContentModeScaleToFill;
    }
    return _parallelAdBG;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    //标题
    self.titleLabel.ustc_x = 11;
    self.titleLabel.ustc_y = 11;
    self.titleLabel.frame = CGRectMake(self.titleLabel.ustc_x, self.titleLabel.ustc_y, 100, 30);
    //图片
    self.imageBoard.frame = CGRectMake(11, self.titleLabel.ustc_bottom + 8, CGSizeMake(COVERNEWSCELL_IMAGE_WIDTH, COVERNEWSCELL_IMAGE_HEIGHT).width, CGSizeMake(COVERNEWSCELL_IMAGE_WIDTH, COVERNEWSCELL_IMAGE_HEIGHT).height);
    self.coverImageView.frame = self.imageBoard.bounds;
}

- (void)fillDataWithViewModel:(CellModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
    if (![viewModel isKindOfClass:[CellModel class]]) {
        return;
    }
    
    self.viewModel = viewModel;
    self.currentCellIndex = indexPath;
    
    if (viewModel.cellType == CellTypeParallelShort || viewModel.cellType == CellTypeParallelLong) {
        //平行Window CEll
        [self configHasParallerBG];
        [self configParallerBGWithViewModel:viewModel atIndexPath:indexPath];
    } else {
        [self configNoParallerBG];
        [self.coverImageView setImage:[UIImage imageNamed:@"paralleldemo"]];
    }
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.attributedText = viewModel.titleLabelAttributedText;
}

@end
