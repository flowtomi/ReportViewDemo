//
//  DataSourceModel.m
//  ReportViewDemo
//
//  Created by uplus on 2017/6/13.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import "DataSourceModel.h"
#import "NSArray+Extension.h"
@implementation DataSourceModel

-(NSArray *)getProperties{    
    return [NSArray getProperties:[self class]];
}
@end
