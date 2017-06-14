//
//  ViewController.m
//  ReportViewDemo
//
//  Created by uplus on 2017/6/12.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import "ViewController.h"
#import "ReportView.h"
#import "DataSourceModel.h"
#import "Model.h"
#import "NSObject+propertyCode.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>
@interface ViewController ()<ReportViewDelegate>
{
    MBProgressHUD *_hud;
}
@property (strong,nonatomic) ReportView *reportView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //name,barcode，specifications，model，unit，origin
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    [self tableHeaderRefreshing];
}

-(ReportView *)reportView{
    if (!_reportView) {
        _reportView = [[ReportView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
        NSArray *titles = @[[[Model alloc] initWithTitle:@"名称" width:80.0 countColumn:0],
                            [[Model alloc] initWithTitle:@"条码" width:80.0 countColumn:0],
                            [[Model alloc] initWithTitle:@"规格" width:80.0 countColumn:0],
                            [[Model alloc] initWithTitle:@"型号" width:80.0 countColumn:0],
                            [[Model alloc] initWithTitle:@"单位" width:80.0 countColumn:0],
                            [[Model alloc] initWithTitle:@"产地" width:80.0 countColumn:0],
                            [[Model alloc] initWithTitle:@"库存量" width:80.0 countColumn:1]];
        [_reportView.titles addObjectsFromArray:titles];
        _reportView.bHeaderRefreshing = YES;
        [_reportView initContent];
        [self.view addSubview:_reportView];
    }
    return _reportView;
}
#pragma mark ---ReportViewDelegate
-(void)tableHeaderRefreshing{
    [_hud showAnimated:YES];
    NSArray *json = @[@{@"name":@"名称0",@"barcode":@"条码0",@"specifications":@"规格0",@"model":@"型号0",@"unit":@"单位0",@"origin":@"产地0",@"inventory":@"23"},
                      @{@"name":@"名称1",@"barcode":@"条码1",@"specifications":@"规格1",@"model":@"型号1",@"unit":@"单位1",@"origin":@"产地1",@"inventory":@"3"},
                      @{@"name":@"名称2",@"barcode":@"条码2",@"specifications":@"规格2",@"model":@"型号2",@"unit":@"单位2",@"origin":@"产地2",@"inventory":@"12"},
                      @{@"name":@"名称3",@"barcode":@"条码3",@"specifications":@"规格3",@"model":@"型号3",@"unit":@"单位3",@"origin":@"产地3",@"inventory":@"123"}];
    NSArray *result = [DataSourceModel mj_objectArrayWithKeyValuesArray:json];
    self.reportView.result = (NSMutableArray *)result;
    [_hud hideAnimated:YES];
    [self.reportView headerEndRefreshing];
    
    
}

-(void)tableFooterRefreshing{
    
}

-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj{
    DataSourceModel *m = (DataSourceModel *)obj;
    NSLog(@"第%ld行，名称:%@",index,m.name);
}
#pragma mark  ---action---
- (IBAction)setting:(UIBarButtonItem *)sender {
    [_reportView reInitContent];
    [self tableHeaderRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
