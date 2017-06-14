//
//  DataSourceModel.h
//  ReportViewDemo
//
//  Created by uplus on 2017/6/13.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataSourceModel : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *barcode;
@property (copy, nonatomic) NSString *specifications;
@property (copy, nonatomic) NSString *model;
@property (copy, nonatomic) NSString *unit;
@property (copy, nonatomic) NSString *origin;
@property (copy, nonatomic) NSString *inventory;
-(NSArray *)getProperties;
@end
