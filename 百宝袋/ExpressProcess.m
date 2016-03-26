//
//  ExpressProcess.m
//  百宝袋
//
//  Created by admin on 15/11/11.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "ExpressProcess.h"

@implementation ExpressProcess

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)ExpressProcessWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
