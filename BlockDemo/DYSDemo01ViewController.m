//
//  DYSDemo01ViewController.m
//  BlockDemo
//
//  Created by 丁玉松 on 2018/10/26.
//  Copyright © 2018 丁玉松. All rights reserved.
//

#import "DYSDemo01ViewController.h"
#import "DYSDog.h"

typedef NSInteger (^blockNameAdd)(NSInteger, NSInteger);

@interface DYSDemo01ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSourceArray;

//returnType (^blockName)(parameterTypes);
@property (nonatomic, copy) NSInteger (^add)(NSInteger, NSInteger);
//变量类型 变量名;
@property (nonatomic, strong) DYSDog *dog;

@end

/**
 Block的语法
 returnType (^blockName)(parameterTypes) 相当于 变量类型 变量名;//也就是变量的声明
 returnType (^)(parameterTypes) = 变量类型;//也就是类
 blockName = 变量名;
 ^returnType (parameters) {...} = 变量值；
 
 
 
 举例：
 NSInteger (^add)(NSInteger, NSInteger) = DYSDog *dog;
 
 变量类型： NSInteger (^)(NSInteger, NSInteger) = DYSDog *;
      
 变量名： add = dog;
 
 变量值： ^NSInteger(NSInteger a, NSInteger b) {return a+b;} = [DYSDog new];

 typedef NSInteger(^blockNameAdd)(NSInteger, NSInteger);
 
 blockNameAdd 这个类型相当于 NSInteger (^)(NSInteger, NSInteger)。
 
 blockNameAdd 类比于 DYSDog *。

 */

@implementation DYSDemo01ViewController

- (void)dealloc {
    NSLog(@"DYSDemo01ViewController 释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Block的语法";

    self.dataSourceArray = @[
        @"Block作为局部变量",
        @"Block作为属性",
        @"Block作为函数形参",
        @"Block作为函数实参",
        @"Block的typedef",
    ];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }

    cell.textLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self dys_test01];
        } break;
        case 1: {
            [self dys_test02];
        } break;
        case 2: {
            [self dys_test04];
        } break;
        case 3: {
            [self dys_test04];
        } break;
        case 4: {
            [self dys_test05];
        } break;

        default:
            break;
    }
}

/// Block作为局部变量 (local variable)
- (void)dys_test01 {

    //1. 声明

    //returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};

    //Block
    NSInteger (^add)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b) {
        return a + b;
    };

    
    NSInteger (^blockName2)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b){
        return a+b;
    };
    
    //OC对象声明 变量类型 变量名 = 变量值;

    //DYSDog
    DYSDog *dog = [DYSDog new];

    //2.方法执行

    //变量也是对象，对象有属性也有方法，下面看局部变量的方法执行。

    //Block
    if (!add) {  //Block执行前一定要判空，如果block对象为nil，执行会crash。而向普通OC的nil对象发消息，则不会crash。
        add(3, 5);
    }

    //DYSDog
    [dog dys_run];
}

/// Block作为属性 （property）
- (void)dys_test02 {
    //执行
    //[self.dog dys_run];
    //self.add(3, 4);
    

    //属性赋值
    self.add = ^NSInteger(NSInteger a, NSInteger b) {
        return a + b;
    };
    self.dog = [DYSDog new];

    //执行
    self.add(3, 4);
    [self.dog dys_run];
}

/// block 作为形参
- (void)dys_test03WithBlockHandler:(NSInteger (^)(NSInteger, NSInteger))add {
    add(3, 4);
}
- (void)dys_test03WithObjectHandler:(DYSDog *)dog {
    [dog dys_run];
}

/// block 作为实参
- (void)dys_test04 {

    NSInteger (^bbb)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b) {
        return a + b;
    };
    //注意：bbb和dog一样 只是一个变量名。 真正的类型是有 返回值和参数类型决定的 returnType (^)(parameterTypes) 就是这个。类似类：DYSDog *。
    DYSDog *dog = [DYSDog new];

    [self dys_test03WithBlockHandler:bbb];
    [self dys_test03WithBlockHandler:^NSInteger(NSInteger a, NSInteger b) {
        return a + b;
    }];

    [self dys_test03WithObjectHandler:dog];
    [self dys_test03WithObjectHandler:[DYSDog new]];

    /*
     returnType (^blockName)(parameterTypes) 相当于 变量类型 变量名;
     
     returnType (^)(parameterTypes) = 变量类型;
     blockName = 变量名;
     ^returnType (parameters) {...} = 变量值；
     
     举例：
     NSInteger (^add)(NSInteger, NSInteger) = DYSDog *dog;
     
     变量类型： NSInteger (^)(NSInteger, NSInteger) = DYSDog *;
          
     变量名： add = dog;
     
     变量值： ^NSInteger(NSInteger a, NSInteger b) {return a+b;} = [DYSDog new];
     */
}

/// Block 使用类型定义。
- (void)dys_test05 {
    /*
     typedef NSInteger(^blockNameAdd)(NSInteger, NSInteger);
     
     blockNameAdd 这个类型相当于 NSInteger (^)(NSInteger, NSInteger)。
     
     blockNameAdd 类比于 DYSDog *。
     */

    blockNameAdd bbb = ^NSInteger(NSInteger a, NSInteger b) {
        return a + b;
    };

    [self dys_test03WithBlockHandler:bbb];

    DYSDog *dog = [DYSDog new];
    [self dys_test03WithObjectHandler:dog];
}

@end
