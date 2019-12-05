//
//  ViewController.m
//  BlockDemo
//
//  Created by 丁玉松 on 2018/10/26.
//  Copyright © 2018 丁玉松. All rights reserved.
//

#import "ViewController.h"
#import "DYSDemo01ViewController.h"
#import "DYSDemo02ViewController.h"
#import "FourthViewController.h"

#import "DYSDog.h"

typedef NSInteger (^blockNameAdd)(NSInteger, NSInteger);

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSourceArray;

//returnType (^blockName)(parameterTypes);
@property (nonatomic, copy) NSInteger (^add)(NSInteger, NSInteger);
//变量类型 变量名;
@property (nonatomic, strong) DYSDog *dog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原型模式";
    self.dataSourceArray = @[
        @{
            @"title": @"Block的使用",
            @"page": @"DYSDemo01ViewController"
        },
        @{
            @"title": @"Block的内存管理",
            @"page": @"DYSDemo02ViewController"
        },
    ];
        self.tableView.tableFooterView = [UIView new];
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

    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *className = [dict objectForKey:@"page"];

    UIViewController *vc = [NSClassFromString(className) new];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
