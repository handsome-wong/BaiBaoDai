//
//  ExpressProcess.h
//  百宝袋
//
//  Created by admin on 15/11/11.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressProcess : NSObject

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *time;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)ExpressProcessWithDict:(NSDictionary *)dict;

@end
