//
//  WwNewAddressViewController.m
//  WawaSDKDemo
//

#import "WwNewAddressViewController.h"
#import "STPickerArea.h"
#import "NSString+WawaKit.h"
#import "WwUserAddressDataModel.h"

@interface WwNewAddressViewController ()<UITextFieldDelegate, UITextViewDelegate, STPickerAreaDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *regionTextField; // 地区选择器
@property (weak, nonatomic) IBOutlet UITextView *textView0;
@property (weak, nonatomic) IBOutlet UISwitch *switchM;
@property (weak, nonatomic) IBOutlet UIView *deleteV;
@property (weak, nonatomic) IBOutlet UIView *defaultV;

@property (nonatomic, strong) UILabel *XxAddressLabel;  // 详细占位label
@property (nonatomic, strong) WwAddressModel * userAddressM; /**< 用户地址*/
@property (nonatomic, strong) WwAddressProvinceItem * provinceM; /**< 省份信息*/
@property (nonatomic, strong) WwAddressCityItem * cityM; /**< 信息*/
@property (nonatomic, strong) WwAddressAreaItem * areaM; /**< 省份信息*/
@property (nonatomic, strong) STPickerArea * pickerV; /**< 省市区选择器*/
@property (nonatomic, strong) UIButton *saveBtn; // 保存按钮
@property (nonatomic, assign) BOOL rightClicked;
@property (nonatomic, strong) WwUserAddressDataModel *dataModel;
@end

@implementation WwNewAddressViewController

- (void)dealloc {    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    [self updateAddressInfo];
    self.rightClicked = NO;
    
    // 请求地址列表
    [self.dataModel refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTitle];
    [self updateAddressInfo];
    
    if (self.navigationController.tabBarController) {
        UITabBarController *tabVC = self.navigationController.tabBarController;
        tabVC.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.tabBarController) {
        UITabBarController *tabVC = self.navigationController.tabBarController;
        tabVC.tabBar.hidden = NO;
    }
    [self keyboardHide:nil];
}


#pragma mark - Private Methods
- (void)updateTitle {
    self.navigationItem.title = @"添加新地址";
    if ([self.defaultUserAddress isKindOfClass:[WwAddressModel class]]) {
        self.navigationItem.title = @"编辑地址";
    }
}
- (void)customUI {
    if (![WwLocalPcasCodeManager shareManager].pcasMarr.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [[WwLocalPcasCodeManager shareManager] recodeDataFromLocalJson];
        });
    }
    // 修改placeholder默认字体颜色
    [_nameTextField setValue:RGBCOLORV(0xaeaeae) forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextField setValue:RGBCOLORV(0xaeaeae) forKeyPath:@"_placeholderLabel.textColor"];
    [_regionTextField setValue:RGBCOLORV(0xaeaeae) forKeyPath:@"_placeholderLabel.textColor"];
    
    // 右上角保持按钮
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.size = CGSizeMake(40, 20);
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_saveBtn setTitleColor:RGBCOLORV(0x4c4c4c) forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(rightBtn:)];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:_saveBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    self.phoneTextField.delegate = self;
    self.regionTextField.delegate = self;
    
    // 自定义地址选择输入框
    self.regionTextField.inputView = self.pickerV;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // 详细地址的占位label
    self.XxAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 300, 50)];
    self.XxAddressLabel.text = @"请填写详细地址";
    self.XxAddressLabel.font = [UIFont systemFontOfSize:15.f];
    self.XxAddressLabel.enabled = NO;
    self.XxAddressLabel.textColor = RGB(205, 205, 210);
    [self.textView0 addSubview:self.XxAddressLabel];
    self.textView0.delegate = self;
}

- (void)updateAddressInfo {
    if (!self.defaultUserAddress) {
        return;
    }
    //编辑地址
    if (!self.provinceM) {
        self.provinceM = [WwAddressProvinceItem new];
        self.provinceM.name = self.defaultUserAddress.province;
    }
    if (!self.cityM) {
        self.cityM = [WwAddressCityItem new];
        self.cityM.name = self.defaultUserAddress.city;
    }
    if (!self.areaM) {
        self.areaM = [WwAddressAreaItem new];
        self.areaM.name = self.defaultUserAddress.district;
    }
    //编辑地址
    self.nameTextField.text = self.defaultUserAddress.name;
    self.phoneTextField.text = self.defaultUserAddress.phone;
    self.regionTextField.text = [NSString stringWithFormat:@"%@ %@ %@",self.defaultUserAddress.province,self.defaultUserAddress.city,self.defaultUserAddress.district];
    self.XxAddressLabel.text = @"";
    self.textView0.text = self.defaultUserAddress.address;
    self.deleteV.hidden = NO;
    self.defaultV.hidden = YES;
    self.switchM.on = self.defaultUserAddress.isDefault;
    [self findPickerIndex];
}

- (void)findPickerIndex {
    if (self.provinceM && self.cityM && self.areaM) {
        // 通过选择的省份信息找到下标
        [self.pickerV findIndexWithProvince:self.provinceM.name city:self.cityM.name area:self.areaM.name];
    } else if (self.defaultUserAddress) {
        // 通过传入的省份信息找到picker的下标
        [self.pickerV findIndexWithProvince:self.defaultUserAddress.province city:self.defaultUserAddress.city area:self.defaultUserAddress.district];
    }
}

#pragma mark - Action
-(void)rightBtn:(UIButton *)sender {
    if (self.rightClicked == YES) {
        return;
    }
    
    // 姓名
    if (!self.nameTextField.text.length) {
        NSLog(@"姓名不能为空哦~");
        return;
    }
    
    // 手机
    if (![self.phoneTextField.text validateMobile]) {
        NSLog(@"手机号格式不合法哦~");
        return;
    }
    // 省份信息
    if (!self.defaultUserAddress) {
        //新加地址
        if (self.provinceM || self.cityM || self.areaM) {
            //任何一个存在，都可以
        }
        else {
            NSLog(@"省份信息不能为空哦~");
            return;
        }
    }

    // 详细地址
    if (!self.textView0.text.length) {
        NSLog(@"详细地址不能为空哦~");
        return;
    }
    
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    mDic[@"name"] = realString(self.nameTextField.text);
    mDic[@"phone"] = realString(self.phoneTextField.text);
    mDic[@"province"] = realString(self.provinceM.name);
    mDic[@"city"] = realString(self.cityM.name);
    mDic[@"district"] = realString(self.areaM.name);
    mDic[@"address"] = realString(self.textView0.text);
    mDic[@"isDefault"] = @(self.switchM.on);
    if (self.defaultUserAddress.aID) {
        mDic[@"id"] = @(self.defaultUserAddress.aID);
    }
    
    @weakify(self);
    sender.enabled = NO;
    self.rightClicked = YES;

    if (self.defaultUserAddress) {
        // 修改
//        [ZXHttpTask POST:kUserAddressEdit parameters:mDic taskResponse:^(DVLHttpResponse *response) {
//            @strongify(self);
//            self.rightClicked = NO;
//            sender.enabled = YES;
//            if (!response.code) {
//                NSLog(@"地址保存成功");
//                if (self.navigationController.presentingViewController) {
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                } else {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//                [kZXUserModel requestAddressList];
//            }
//        }];
    } else {
        // 新建
//        [ZXHttpTask POST:kUserAddressAdd parameters:mDic taskResponse:^(DVLHttpResponse *response) {
//            @strongify(self);
//            self.rightClicked = NO;
//            sender.enabled = YES;
//            if (!response.code) {
//                NSLog(@"地址保存成功");
//                if (self.navigationController.presentingViewController) {
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                } else {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//                [kZXUserModel requestAddressList];
//            } else {
//                [ZYTipsView showInfoWithStatus:response.message];
//            }
//        }];
    }
}

- (IBAction)deleteAction:(id)sender {
//    [ZXHttpTask POST:kUserAddressDelete parameters:@{@"id":@(self.defaultUserAddress.aID)} taskResponse:^(DVLHttpResponse *response) {
//        if (!response.code) {
//            [ZYTipsView showInfoWithStatus:@"删除成功"];
//            [kZXUserModel requestAddressList];
//            if (self.navigationController.presentingViewController) {
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            } else {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
//    }];
}


#pragma mark - STPickerAreaDelegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(WwAddressProvinceItem *)province city:(WwAddressCityItem *)city area:(WwAddressAreaItem *)area {
    // 记录数据
    self.provinceM = province; self.cityM = city; self.areaM = area;
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province.name, realString(city.name), realString(area.name)];
    self.regionTextField.text = text;
}

- (void)pickerDidClickCancel {
    [self.regionTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.regionTextField) {
        [self.pickerV showRightNow];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length) {
        NSMutableString * mStr = [NSMutableString stringWithString:textField.text];
        [mStr replaceCharactersInRange:range withString:string];
        if (![mStr validateNumber] || mStr.length > 11) {
            return NO;
        }
    }
    return YES;
}

// 撤销第一相应
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.textView0 resignFirstResponder];
    [self.regionTextField resignFirstResponder];
}

// 详细地址的占位label
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一响应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.XxAddressLabel.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.XxAddressLabel.alpha = 1;
    }
    return YES;
}

#pragma mark - Getter
- (STPickerArea *)pickerV {
    if (!_pickerV) {
        _pickerV = [STPickerArea inputPickerView];
        [_pickerV setDelegate:self];
    }
    return _pickerV;
}

#pragma mark - Getter
- (WwUserAddressDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[WwUserAddressDataModel alloc] init];
    }
    return _dataModel;
}

@end
