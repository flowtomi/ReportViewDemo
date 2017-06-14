//
//  Model.h
//  ReportViewDemo
//
//  Created by uplus on 2017/6/13.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

/**
 每列名称
 */
@property (copy,   nonatomic) NSString *title;

/**
 每列宽度
 */
@property (assign, nonatomic) double width;

/**
 需要计算合计的列1，不需要为0
 */
@property (assign, nonatomic) int countColumn;

/**
 快速实例化模型对象

 @param title 每列名称
 @param width 每列宽度
 @param countColumn 需要计算标示
 @return 模型对象
 */
-(instancetype)initWithTitle:(NSString *)title width:(double)width countColumn:(int)countColumn;

@end
