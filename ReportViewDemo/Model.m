//
//  Model.m
//  ReportViewDemo
//
//  Created by uplus on 2017/6/13.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import "Model.h"
#import "NSArray+Extension.h"
@implementation Model

-(instancetype)initWithTitle:(NSString *)title width:(double)width countColumn:(int)countColumn{
    self = [super init];
    if (self) {
        self.title = title;
        self.width = width;
        self.countColumn = countColumn;
//        self.obj = [NSMutableArray array];
//        self.result = [NSMutableArray array];
    }
    return self;
}

-(NSArray *)obj{
    NSArray *arr = [NSArray getProperties:[self class]];
    return arr;
}



@end
