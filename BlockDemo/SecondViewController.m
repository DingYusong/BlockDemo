//
//  SecondViewController.m
//  BlockDemo
//
//  Created by 丁玉松 on 2018/10/26.
//  Copyright © 2018 丁玉松. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic ,copy) NSString *tmpString;

@end

/**
 “如果 block 没有在其他地方被保持，那么它会随着栈生存并且当栈帧（stack frame）返回的时候消失。仅存在于栈上时，block对对象访问的内存管理和生命周期没有任何影响。”
 
 摘录来自: Yourtion. “禅与 Objective-C 编程艺术。” Apple Books.
 */

@implementation SecondViewController

- (void)dealloc{
    NSLog(@"SecondViewController 释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    self.tmpString = @"asdfasdf";
    
    CGFloat blockInt = 10;
    void (^playblock)(void) = ^{
        NSLog(@"blockInt = %f", blockInt);
        NSLog(@"tmpString：%@",self.tmpString);
    };
    blockInt ++;
    playblock();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
