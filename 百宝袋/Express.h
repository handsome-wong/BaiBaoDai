//
//  Express.h
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Express : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic,copy) NSString *expressId;

@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)expressWithDict:(NSDictionary *)dict;

@end
