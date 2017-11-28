//
//  STPickerArea.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerArea.h"

@interface STPickerArea()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected; //当前选中省的城市列表

/** 6.省份 */
@property (nonatomic, strong, nullable)WwAddressProvinceItem *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)WwAddressCityItem *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)WwAddressAreaItem *area;

@end

@implementation STPickerArea

+ (instancetype)inputPickerView {
    STPickerArea * pickerV = [[STPickerArea alloc] init];
    return pickerV;
}

- (void)showRightNow {
    CGRect rect = self.contentView.frame;
    self.frame = CGRectMake(0, -CGRectGetHeight(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    self.contentView.frame = self.bounds;
    [self.layer setOpacity:1.0];
}

- (void)findIndexWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area {
    if (!province || !city || !area) {
        return;
    }
    NSArray * nextArr = nil;
    // 省
    for (WwAddressProvinceItem * proM in self.arrayProvince) {
        if ([proM.name isEqualToString:province]) {
            self.province = proM;
            [self.pickerView selectRow:[self.arrayProvince indexOfObject:proM] inComponent:0 animated:YES];
            nextArr = proM.childs;
            break;
        }
    }
    // 市
    [self.arrayCity removeAllObjects];
    [self.arrayCity addObjectsFromArray:nextArr];
    [self.pickerView reloadComponent:1];
    
    for (WwAddressCityItem * cityM in nextArr) {
        if ([cityM.name isEqualToString:city]) {
            self.city = cityM;
            [self.pickerView selectRow:[nextArr indexOfObject:cityM] inComponent:1 animated:YES];
            nextArr = cityM.childs;
            break;
        }
    }
    // 区
    [self.arrayArea removeAllObjects];
    [self.arrayArea addObjectsFromArray:nextArr];
    [self.pickerView reloadComponent:2];
    
    for (WwAddressAreaItem * areaM in nextArr) {
        if ([areaM.name isEqualToString:area]) {
            self.area = areaM;
            [self.pickerView selectRow:[nextArr indexOfObject:areaM] inComponent:2 animated:YES];
            break;
        }
    }
}

#pragma mark - Overwrite
- (void)remove {
    if ([self.delegate respondsToSelector:@selector(pickerDidClickCancel)]) {
        [self.delegate pickerDidClickCancel];
    }
}

#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    // 1.获取数据
    self.arrayCity = [[self.arrayProvince.firstObject childs] mutableCopy];
    self.arrayArea = [[[self.arrayCity firstObject] childs] mutableCopy];
    
    self.province = self.arrayProvince.firstObject;
    self.city = self.arrayCity.firstObject;
    self.area = self.arrayArea.firstObject;
    
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市地区"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.arraySelected = [self.arrayProvince[row] childs];

        [self.arrayCity removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(WwAddressCityItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj];
        }];

        self.arrayArea = [NSMutableArray arrayWithArray:[(WwAddressCityItem *)[self.arraySelected firstObject] childs]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [[self.arrayProvince firstObject] childs];
        }
        if (self.arraySelected.count > row) {
            self.arrayArea = [[self.arraySelected objectAtIndex:row] childs];
        } else {
            self.arrayArea = [NSMutableArray array];
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    NSString *text;
    if (component == 0) {
        text =  [self.arrayProvince[row] name];
    }else if (component == 1){
        text =  [self.arrayCity[row] name];
    }else{
        if (self.arrayArea.count > 0) {
            text = [self.arrayArea[row] name];
        }else{
            text =  @"";
        }
    }


    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;


}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate pickerArea:self province:self.province city:self.city area:self.area];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    if (index1 >= self.arrayCity.count) {
        self.city = self.arrayCity.lastObject;
    } else {
        self.city = self.arrayCity[index1];
    }
    
    if (self.arrayArea.count != 0) {
        if (index2 >= self.arrayArea.count) {
            self.area = self.arrayArea.lastObject;
        } else {
            self.area = self.arrayArea[index2];
        }
    }else{
        self.area = nil;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province.name, realString(self.city.name), realString(self.area.name)];
    [self setTitle:title];

}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [[WwLocalPcasCodeManager shareManager].pcasMarr mutableCopy];
        if (!_arrayProvince.count) {
            [[WwLocalPcasCodeManager shareManager] recodeDataFromLocalJson];
            _arrayProvince = [[WwLocalPcasCodeManager shareManager].pcasMarr mutableCopy];
        }
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

@end


