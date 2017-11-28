//
//  WwLogisticsViewController.m
//  prizeClaw
//
//  Created by ganyanchao on 03/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import "WwLogisticsViewController.h"
#import "WwLogisticsDataModel.h"
#import "WwLogisticsCell.h"
#import "WwLogisticsHeaderView.h"
#import "WwLogisticsView.h"

@interface WwLogisticsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary * _heightCollecttions;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WwLogisticsCell * testHeightCell;

@property (nonatomic, strong) WwLogisticsDataModel *dataModel;

@property (nonatomic, strong) WwLogisticsHeaderView  *headerView;

@end

@implementation WwLogisticsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _heightCollecttions = [@{} mutableCopy];
    
    [self.dataModel fetchData];
    
    // Do any additional setup after loading the view from its nib.
    // TODO
//    [self Ww_adjustTableView:self.tableView];
    self.testHeightCell = WwLoadNib(@"WwLogisticsCell");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WwLogisticsCell" bundle:nil] forCellReuseIdentifier:@"WwLogisticsCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WwLogisticsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"WwLogisticsHeaderView"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.sectionFooterHeight = 0.01;
    self.tableView.backgroundView = nil;
    
    
    self.headerView = WwLoadNib(@"WwLogisticsHeaderView");
    
    CGFloat height = ScreenWidth * 132 / 375.0;
    self.headerView.frame = (CGRect){0,0,ScreenWidth,height};
    self.tableView.tableHeaderView = self.headerView;
    
    WwWawaOrderModel *orderModel = self.Ww_InitData;
    [self.headerView  fillContentWithOrderModel:orderModel];
    
}

- (void)dataChange:(WwLogisticsDataModel *)model
{
    if (model == self.dataModel) {
        [self.tableView reloadData];
        [self.headerView loadData:model.recorderModel];
        
    }
}

- (IBAction)closeBtnAction:(id)sender
{
    [WwLogisticsView dismiss];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel.recorderModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WwLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WwLogisticsCell" forIndexPath:indexPath];
    
    NSArray *listArr = self.dataModel.recorderModel.list;
    WwLogisticsListInfo *listInfo = [listArr safeObjectAtIndex:indexPath.row];
    listInfo.isLast = NO;
    if (indexPath.row == 0) {
        listInfo.isFirst = YES;
    }
    else {
        listInfo.isFirst = NO;
    }
    if (indexPath.row == listArr.count - 1) {
        listInfo.isLast = YES;
    }
    
    [cell loadWithData:listInfo];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSNumber *key = @(row);
    NSNumber *rowHeight = _heightCollecttions[key];
    if (rowHeight == nil) {
        
        WwLogisticsListInfo *listInfo = [self.dataModel.recorderModel.list safeObjectAtIndex:indexPath.row];
        [self.testHeightCell loadWithData:listInfo];
        CGSize newsize = [self.testHeightCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _heightCollecttions[key] = @(newsize.height);
         return newsize.height;
    }
    else {
        return [rowHeight  intValue];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    WwLogisticsHeaderView *headerView =  [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WwLogisticsHeaderView"];
//    
//    [headerView loadData:self.dataModel.recorderModel];
//    
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat height = ScreenWidth * 132 / 375.0;
//    return height;
//}

#pragma mark - Getter Setter
- (WwLogisticsDataModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[WwLogisticsDataModel alloc] init];
        _dataModel.ownVc = self;
    }
    return _dataModel;
}

@end
