//
//  DYSCat.m
//  BlockDemo
//
//  Created by DingYusong on 2020/8/27.
//  Copyright © 2020 丁玉松. All rights reserved.
//

#import "DYSCat.h"

@implementation DYSCat

-(void)dys_run {
    NSInteger (^add)(NSInteger,NSInteger) = ^(NSInteger a,NSInteger b){
        return a+b;
    };
    add(1,3);
}

@end
