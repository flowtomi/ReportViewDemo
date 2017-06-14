//
//  NSObject+propertyCode.h
//  ReportViewDemo
//
//  Created by uplus on 2017/6/14.
//  Copyright © 2017年 uplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (propertyCode)
/**
 *  自动生成属性申明Code
 *
 *  @param dict 传入的字典
 */
+ (void)propertyCodeWithDictionary:(NSDictionary *)dict;
@end
