//
//  ReportView.m
//  ReportViewDemo
//
//  Created by uplus on 2017/6/12.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import "ReportView.h"
#import <MJRefresh.h>
#import "Model.h"
#import "DataSourceModel.h"
#import <MJExtension.h>
@implementation ReportView
{
    
}
@synthesize result = _result;
@synthesize titles,leftTitleView,contentTitleView,titleSC;
@synthesize headerColor,leftTitleColor ;
@synthesize bFooterRefreshing = _bFooterRefreshing,bHeaderRefreshing = _bHeaderRefreshing;
@synthesize leftIsOrder;
@synthesize totalColumns;
@synthesize bInit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.fixColumn = 1;
        self.rowHeight = 30;
        self.titles = [NSMutableArray array];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.fixColumn = 1;
    self.rowHeight = 30;
    
}

-(void)setBFooterRefreshing:(BOOL)bFooterRefreshing{
    _bFooterRefreshing = bFooterRefreshing;
}

-(void)setBHeaderRefreshing:(BOOL)bHeaderRefreshing{
    _bHeaderRefreshing = bHeaderRefreshing;
}

-(UITableView *)GetTableView{
    return (UITableView *)contentSC;
}

-(void)initContent{
    
    if (bInit)
        return;
    bInit = YES;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.leftTotal = 0;//左边长度，因固定列不同而改变
    leftWidth = 0;
    if (self.leftIsOrder && !self.leftType) {
        self.leftType = YES;
        Model *m = [[Model alloc] initWithTitle:@"排行" width:50 countColumn:0];
        [self.titles insertObject:m atIndex:0];
//        DataSourceModel *dm = [[DataSourceModel alloc] init];
//        NSArray *keys = [dm getProperties];
//        NSDictionary *dic = dm.mj_keyValues;
//        NSMutableArray *keyvalues = [NSMutableArray array];
//        for (int i = 0; i < keys.count; i ++) {
//            [dic setValue:[NSString stringWithFormat:@"%d",i + 1] forKey:[keys objectAtIndex:i]];
//            [keyvalues addObject:dic];
//        }
    }
    for (int i = 0 ; i < self.fixColumn ; i ++){
        Model *m = [self.titles objectAtIndex:i];
        leftWidth += m.width;
    }
    for (Model *m in self.titles){
        self.leftTotal += m.width;
    }
    
    if (self.leftTotal < self.frame.size.width)
        self.leftTotal = self.frame.size.width;
    self.leftTotal -= leftWidth;
    
    self.headerColor = [UIColor colorWithRed:216.0/255 green:227.0/255 blue:247.0/255 alpha:1.0];
    self.leftTitleColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
    
    leftTableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, 0, leftWidth, self.frame.size.height) style:UITableViewStylePlain];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    [self addSubview:leftTableView];
    
    self.leftTitleView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, leftWidth, self.rowHeight)];
    self.leftTitleView.backgroundColor = self.headerColor;
    [self setLabel:self.leftTitleView fromIndex:0 toIndex:self.fixColumn - 1 + self.leftIsOrder];
    [self setTitle:self.leftTitleView fromIndex:0 toIndex:self.fixColumn - 1 + self.leftIsOrder];
    
    contentSC =  [[UIScrollView alloc]initWithFrame:CGRectMake(leftWidth, 0 , self.frame.size.width - leftWidth , self.frame.size.height)];
    contentSC.contentSize = CGSizeMake(self.leftTotal , 1);
    contentSC.delegate = self;
    contentSC.backgroundColor =  [UIColor clearColor];
    contentSC.showsHorizontalScrollIndicator = NO;
    contentSC.showsVerticalScrollIndicator = NO;
    contentSC.bounces = NO;
    [self addSubview:contentSC];
    
    contentTableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.leftTotal , self.frame.size.height) style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_bHeaderRefreshing)
        [self setHeaderRefresh];
    if (_bFooterRefreshing)
        [self setFooterRefresh];
    [contentSC addSubview:contentTableView];
    
    
    self.titleSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , self.frame.size.width - leftWidth, self.rowHeight)];
    self.titleSC.contentSize = CGSizeMake(self.leftTotal, 1);
    self.titleSC.delegate = self;
    self.titleSC.backgroundColor = self.headerColor;
    [self setLabel:self.titleSC fromIndex:self.fixColumn toIndex:[self.titles count] - 1];
    [self setTitle:self.titleSC fromIndex:self.fixColumn toIndex:[self.titles count] - 1];
}

-(void)reloadMyData{
    [leftTableView reloadData];
    [contentTableView reloadData];
}

-(void)reInitContent{
    bInit = NO;
    [self initContent];
}

-(void)headerEndRefreshing{
    [contentTableView.mj_header endRefreshing];
}


-(void)footerEndRefreshing{
    [contentTableView.mj_footer endRefreshing];
}

-(void)setHeaderRefresh{
    [self setHeaderRefresh:contentTableView];
}

-(void)setFooterRefresh{
    [self setFooterRefresh:contentTableView];
}

-(void)endRefreshingWithNoMoreData{
    [contentTableView.mj_footer endRefreshingWithNoMoreData];
}

-(void)headerRereshing{
    [self.rDelegate tableHeaderRefreshing];
}

-(void)footerRereshing{
    [self.rDelegate tableFooterRefreshing];
}

-(void)setHeaderRefresh:(UITableView *)tableView{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    tableView.mj_header = header;
    
}


-(void)setFooterRefresh:(UITableView *)tableView{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
        [self footerEndRefreshing];
    }];

    tableView.mj_footer = footer;
}


-(void)setBackgroundView:(NSString *)imageName forCell:(UITableViewCell *)cell{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    imageView.image = [UIImage imageNamed:imageName];
    [cell setBackgroundView:imageView];
}

-(void)setResult:(NSMutableArray *)result{
    
    self.totalColumns = nil;
    _result = result;
    [self reloadMyData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.bCountTotal){
//            self.totalColumns = [NSMutableArray array];
//            
//            if (self.totalColumns.count > 0) {
//                NSLog(@"-=-=-=-=-==%ld",(long)rowIndex);
//            }else{
//                rowIndex = -1;
//                for (int i = 0 ; i < [self.titles count] ; i ++){
//                    [self.totalColumns addObject:@""];
//                }
//            }
//            NSString *total = @"0";
//            for (int i = 0; i < self.result.count; i ++) {
//                DataSourceModel *m = [self.result objectAtIndex:i];
//                NSArray *keys = [m getProperties];
//                NSDictionary *dic = m.mj_keyValues;
//                for(NSUInteger i = self.fixColumn ; i < [self.titles count] ; i ++){
//                    Model *m = [self.titles objectAtIndex:i];
//                    //计算列，大于 0 的列要计算总数
//                    NSString *key = [keys objectAtIndex:i - self.leftIsOrder];
//                    NSString *inventory = [dic objectForKey:key];
//                    if (m.countColumn == 1 && inventory.doubleValue > 0) {
//                        total = [self decimalNumberMutiplyWithString:total with:inventory];
//                    }
//                }
//            }
//            DataSourceModel *m = [[DataSourceModel alloc] init];
//            m.name = @"合计";
//            m.inventory = total;
//            [_result addObject:m];
//        }
//        if (self.autoCounTotal) {
//            self.totalColumns = [NSMutableArray array];
//            if (!self.totalColumns.count) {
//                for (int i = 0 ; i < [self.autoCountColumns count] ; i ++){
//                    [self.totalColumns addObject:@""];
//                }
//            }
//            NSArray *obj = [self.result lastObject];
//            for(NSUInteger i = self.fixColumn ; i < [self.autoCountColumns count] ; i ++){
//                if ([[self.autoCountColumns objectAtIndex:i] floatValue] > 0) {
//                    [self.totalColumns replaceObjectAtIndex:i withObject:[obj objectAtIndex:[[self.keys objectAtIndex:i] integerValue]]];
//                }
//            }
//        }
//        [leftTableView reloadData];
//        [contentTableView reloadData];
//    });
    
    
    
}

-(void)setLabelColor:(UIColor *)color inView:(UIView *)view fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    for (NSUInteger i = from; i < to + 1;i++){
        UILabel *label = (UILabel *) [view viewWithTag:i];
        label.textColor = color;
    }
}

-(void)setLabel:(UIView *)view fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    CGFloat offset = 0 ;
    for (NSUInteger i = from; i < to + 1;i++){
        Model *m = [self.titles objectAtIndex:i];
        CGFloat width = m.width;
        CGRect newRect = CGRectMake(offset, 0, width, self.rowHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:newRect];
        label.tag = i + 1;
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.1;
        [view addSubview:label];
        offset += width;
    }
}

-(void)setTitle:(UIView *)view fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    for (NSUInteger i = from ; i < to + 1 ; i ++){
        Model *m = [self.titles objectAtIndex:i];
        UILabel *label = (UILabel *)[view viewWithTag:i + 1];
        //        label.textAlignment = NSTextAlignmentCenter;
        label.text = m.title;
    }
}
#pragma mark---------合计
//-(void)setTotalCell:(UITableViewCell *)cell withObject:(id)object fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
//    NSLog(@"=========%@",object);
//    NSArray *objInfo = (NSArray *)object;
//    for (NSUInteger i = from ; i < to + 1 ; i ++){
//        UILabel *label = (UILabel *)[cell viewWithTag:i + 1];
//        label.textColor =  [UIColor blueColor];
//        if ((self.bCountTotal || self.autoCounTotal) && i < self.fixColumn){
//            if (i == 0)
//                label.text = @"合计";
//            else
//                label.text = @"";//清空固定列第一列以后的数据
//        }else{
//            //合计-期末余额
//            if ([[objInfo objectAtIndex:i] length] > 0){
//                label.text = [objInfo objectAtIndex:i];//数量
//            }else{
//                label.text = @"";
//            }
//            
//        }
//    }
//    
//}

-(void)setCell:(UITableViewCell *)cell withObject:(id)object fromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    
    
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *objInfo = (NSArray *)object;
        for (NSUInteger i = from ; i < to + 1 ; i ++){
            UILabel *label = (UILabel *)[cell viewWithTag:i + 1];
            label.textColor =  [UIColor blackColor];
//            if (([self.result indexOfObject:object]==self.result.count-1)&&self.ishaveTotal) {//
//                label.textColor =  [UIColor blueColor];
//            }
            
            if (self.leftIsOrder && i == 0){
                label.text = [objInfo objectAtIndex:0];
            }
//            else
//                if(i == 0&&([self.result indexOfObject:object]==self.result.count-1)&&self.ishaveTotal)
//                    label.text = [[objInfo objectAtIndex:0] isEqualToString:@"总计"]?@"合计":[objInfo objectAtIndex:0];
//                else{
//                    
//                    NSString *value = [objInfo objectAtIndex:[[self.keys objectAtIndex:i] integerValue]];
//                    if ([value isEqualToString:@"总计"]&&([self.result indexOfObject:object]==self.result.count-1)) {
//                        value=@"";
//                    }
//                    label.text = value;
//                }
        }
    }else{
        DataSourceModel *m = (DataSourceModel *)object;
        NSArray *keys = [m getProperties];
        NSDictionary *dic = m.mj_keyValues;
        for (NSUInteger i = from ; i < to + 1 ; i ++){
            UILabel *label = (UILabel *)[cell viewWithTag:i + 1];
            label.text = [dic objectForKey:[keys objectAtIndex:i - self.leftIsOrder]];
        }
    }
}

-(NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue with:(NSString *)multiplicandValue
{
    NSString *value1 = multiplierValue;
    NSString *value2 = multiplicandValue;
    if ([multiplierValue length] == 0) {
        value1 = @"0";
    }
    if ([multiplicandValue length] == 0) {
        value2 = @"0";
    }
    
    if ([value2 isEqualToString:@"***"]) {
        value2=@"0";
    }   if ([value1 isEqualToString:@"***"]) {
        value1=@"0";
    }
    
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:value1];
    
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:value2];
    
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByAdding:multiplierNumber];
    
    
    return [product stringValue];
    
}

#pragma mark -
#pragma mark scroll view

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    titleSC.contentOffset = contentTableView.contentOffset;
    if (scrollView == leftTableView){
        contentTableView.contentOffset = leftTableView.contentOffset;
    }else{
        leftTableView.contentOffset = contentTableView.contentOffset;
    }
    //    if(contentSC.contentOffset.x <= 0) contentSC.contentOffset = CGPointMake(0, 0);
}

#pragma mark -
#pragma mark table view

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == leftTableView) {
        return self.leftTitleView;
    }else{
        return self.titleSC;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [contentTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    if (self.bCountTotal) {
//        //点击最后一行不触发事件
//        if (indexPath.row == [self.result count]) {
//            return;
//        }
//    }
    
    if (self.rDelegate) {
        if ([self.rDelegate respondsToSelector:@selector(tableViewClickAtIndex:withObject:)]) {
            [self.rDelegate tableViewClickAtIndex:indexPath.row withObject:[self.result objectAtIndex:indexPath.row]];
            //            if (tableView == leftTableView)
            //                [self.rDelegate leftTableClickAtIndex:indexPath.row withObject:[self.result objectAtIndex:indexPath.row]];
        }else{
            NSLog(@"%@",[self.rDelegate class]);
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.ishaveTotal) {
//        return  [self.result count];
//    }
    return [self.result count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        if (tableView == leftTableView) {
            [self setBackgroundView:@"inventory_cell_blue" forCell:cell];
            [self setLabel:cell fromIndex:0 toIndex:self.fixColumn - 1];
        }else{
            [self setBackgroundView:@"inventory_cell_white" forCell:cell];
            [self setLabel:cell fromIndex:self.fixColumn toIndex:[self.titles count] - 1];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Model *m = nil;
    if (indexPath.row < [self.result count]){
        m = [self.result objectAtIndex:indexPath.row];
    }
//    if (self.bCountTotal){
//        
//        if (indexPath.row == [self.result count]){
//            //最后一行合计
//            if (tableView == contentTableView) {
//                [self setTotalCell:cell withObject:self.totalColumns fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];
//            }
//            else{
//                //显示合计字样
//                [self setTotalCell:cell withObject:nil fromIndex:0 toIndex:self.fixColumn - 1];
//                
//                
//            }
//            return cell;
//        }
//    }
//    if (self.autoCounTotal) {
//        if (indexPath.row == self.result.count - 1) {
//            //最后一行合计
//            if (tableView == contentTableView) {
//                [self setTotalCell:cell withObject:self.totalColumns fromIndex:self.fixColumn toIndex:[self.titleWidths count] - 1];
//            }else{
//                //显示合计字样
//                [self setTotalCell:cell withObject:nil fromIndex:0 toIndex:self.fixColumn - 1];
//                
//                
//            }
//            return cell;
//        }
//    }
    if (tableView == leftTableView) {
        if (self.leftIsOrder)
            [self setCell:cell withObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]] fromIndex:0 toIndex:0];
        else
            [self setCell:cell withObject:m fromIndex:0 toIndex:self.fixColumn - 1];
        
    }else{
        [self setCell:cell withObject:m fromIndex:self.fixColumn toIndex:[self.titles count] - 1];
    }
    return cell;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.bFooterRefreshing) {
        contentTableView.mj_footer = nil;
    }
}

@end
