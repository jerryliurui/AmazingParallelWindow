//
//  CellModel.h
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeCover = 0,
    CellTypeSingle = 1,
    CellTypeParallelLong = 2,//图片比可视区域大
    CellTypeParallelShort = 3,//图片比可视区域小
};

@interface CellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageSrc;
@property (nonatomic, assign) CellType cellType;


@property (nonatomic, copy) NSAttributedString *titleLabelAttributedText;

- (void)calculateTitleSize;

@end
