//
//  ReportView.h
//  ReportViewDemo
//
//  Created by uplus on 2017/6/12.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Plus_cel = 0,
    Minus_cel = 1,
    Times_cel = 2,
    Division_cel = 3
}ComputeSign_cel;

@protocol ReportViewDelegate <NSObject>
@optional
-(void)tableViewClickAtIndex:(NSUInteger)index withObject:(id)obj;
-(void)tableHeaderRefreshing;
-(void)tableFooterRefreshing;
-(void)leftTableClickAtIndex:(NSUInteger)index withObject:(id)obj;
@end

@interface ReportView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *leftTableView;//左边列
    UITableView *contentTableView;//内容列
    UIScrollView *contentSC;
    BOOL bInit;
    CGFloat leftWidth;
}
@property(nonatomic,retain) UIColor *headerColor;
@property(nonatomic,retain) UIColor *leftTitleColor;
@property(nonatomic) NSUInteger fixColumn;//左边固定列
@property(nonatomic) CGFloat rowHeight;//行高
@property (nonatomic,assign) CGFloat leftTotal;
@property (nonatomic,assign) BOOL leftType;

@property(nonatomic,retain) UIScrollView *titleSC;
@property(nonatomic,retain) UIView *leftTitleView;//左边列
@property(nonatomic,retain) UIView *contentTitleView;


@property(nonatomic,strong) NSMutableArray *titles;//标题
//@property(nonatomic,retain) NSArray *titleWidths;//列宽
//@property(nonatomic,retain) NSArray *keys;// 显示内容对应的Key
@property(nonatomic,retain) NSMutableArray *result;//内容，跟Keys 取
@property(nonatomic,retain) NSMutableArray *totalColumns;//用于储存列数值和
//@property(nonatomic,retain) NSArray *countColumns;//需要计算的列，对应值为1 时计算
//@property(nonatomic) BOOL bCountTotal;//为Yes时 添加总数行
//@property(nonatomic,retain) NSArray *autoCountColumns;//需要显示合计的列，对应值为1
//@property(nonatomic) BOOL autoCounTotal;//接口返回总数合计数据源
@property(nonatomic) BOOL leftIsOrder;//为Yes时，最左一列显示行标
//@property(nonatomic,assign) BOOL clear;//为No时 清楚总数数组数据

@property(nonatomic) NSTextAlignment alignment;

@property(nonatomic,assign) id<ReportViewDelegate>rDelegate;

@property(nonatomic) BOOL bHeaderRefreshing;
@property(nonatomic) BOOL bFooterRefreshing;
@property(nonatomic) BOOL bInit;
-(void)reInitContent;
-(void)initContent;
-(UITableView *)GetTableView;
-(void)setHeaderRefresh;
-(void)setFooterRefresh;
-(void)headerEndRefreshing;
-(void)footerEndRefreshing;
-(void)endRefreshingWithNoMoreData;

@end
