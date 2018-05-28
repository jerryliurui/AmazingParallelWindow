//
//  ViewController.m
//  AmazingParallelWindow
//
//  Created by JerryLiu on 2018/5/25.
//  Copyright © 2018年 JerryLiu. All rights reserved.
//

#import "ViewController.h"
#import "CellModel.h"
#import "ParallelWindowCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *demoTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *currentAddObserverIndexPathes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataArray];
    [self.view addSubview:self.demoTableView];
}

- (UITableView *)demoTableView {
    if (!_demoTableView) {
        _demoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _demoTableView.delegate = self;
        _demoTableView.dataSource = self;
        _demoTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _demoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _demoTableView.backgroundColor = [UIColor clearColor];
        _demoTableView.estimatedRowHeight = 0;
    }
    return _demoTableView;
}

#pragma mark - HelpFunc

- (void)safeToRemoveObserverWith:(NSObject *)object observer:(NSObject *)target keyPath:(NSString *)keypath {
    @try {
        [object removeObserver:target forKeyPath:keypath];
    }
    @catch (NSException * __unused exception) {}
}

- (void)configParallelWindowWithWillDisplayCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    id obj = self.dataArray[indexPath.row];
    if ([obj isKindOfClass:[CellModel class]]) {
        CellModel *model = (CellModel *)obj;
        if (model.cellType == CellTypeParallelLong || model.cellType == CellTypeParallelShort) {
            //如果是平行窗口
            //add 观察者
            ParallelWindowCell *coverCell = (ParallelWindowCell *)cell;
            if (coverCell && indexPath) {
                if (![self.currentAddObserverIndexPathes containsObject:indexPath]) {
                    [self.demoTableView addObserver:coverCell
                                         forKeyPath:kParallelWindowObserverKeyPath
                                            options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                                            context:nil];
                    [self.currentAddObserverIndexPathes addObject:indexPath];
                }
            }
        }
    }
}

- (void)configParallelWindowWithDidEndDisplayCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    id obj = self.dataArray[indexPath.row];
    if ([obj isKindOfClass:[CellModel class]]) {
        CellModel *model = (CellModel *)obj;
        if (model.cellType == CellTypeParallelLong || model.cellType == CellTypeParallelShort) {
            //如果是平行窗口
            //remove 观察者
            ParallelWindowCell *coverCell = (ParallelWindowCell *)cell;
            if (coverCell && indexPath) {
                if (self.demoTableView) {
                    if ([self.currentAddObserverIndexPathes containsObject:indexPath]) {
                        [self safeToRemoveObserverWith:self.demoTableView observer:coverCell keyPath:kParallelWindowObserverKeyPath];
                        [self.currentAddObserverIndexPathes removeObject:indexPath];
                    }
                }
            }
        }
    }
}

#pragma mark - DATA

- (void)createDataArray {
    NSMutableArray *resultArray = [NSMutableArray new];
    for (int i = 0; i < 16; i ++) {
        CellModel *model = [CellModel new];
        model.title = [NSString stringWithFormat:@"这是一条很正经的但是没有什么卵用的cell%i",i];
        model.imageSrc = @"http://www.6gdown.com/uploads/allimg/1609/1326055647-1.jpg";
        if (i % 3 == 0) {
            model.cellType = CellTypeCover;
        } else {
            model.cellType = CellTypeSingle;
        }
        
        if (i == 4) {
            model.cellType = CellTypeParallelShort;
        }
        
        if (i == 6) {
            model.cellType = CellTypeParallelLong;
        }
        
        [resultArray addObject:model];
    }
    
    self.dataArray = [resultArray copy];
}

- (NSMutableArray<NSIndexPath *> *)currentAddObserverIndexPathes {
    if (!_currentAddObserverIndexPathes) {
        _currentAddObserverIndexPathes = [NSMutableArray array];
    }
    return _currentAddObserverIndexPathes;
}


#pragma mark - TableViewDelegateandDataSource

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row >= [self.dataArray count]) {
        return;
    }

    [self configParallelWindowWithDidEndDisplayCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.dataArray count]) {
        return;
    }

    [self configParallelWindowWithWillDisplayCell:cell atIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.dataArray.count) {
        return nil;
    }
    
    return NSStringFromClass([ParallelWindowCell class]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0;
    if (indexPath.row < self.dataArray.count && self.dataArray.count) {
        cellHeight = 230;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self tableView:tableView cellIdentifierAtIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count && self.dataArray.count) {
        ParallelWindowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        id content = self.dataArray[indexPath.row];
        if (!cell) {
            cell = [[ParallelWindowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        [cell fillDataWithViewModel:content atIndexPath:indexPath];
        return cell;
    }

    return nil;
}

@end
