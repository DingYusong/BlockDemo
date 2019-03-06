//
//  ViewController.m
//  BlockDemo
//
//  Created by 丁玉松 on 2018/10/26.
//  Copyright © 2018 丁玉松. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原型模式";
    self.dataSourceArray = @[
                             @{
                                 @"title": @"block作为匿名函数",
                                 @"page": @"DYSDemo01ViewController"
                                 },
                             @{
                                 @"title": @"block作为对象",
                                 @"page": @"DYSDemo02ViewController"
                                 },
                             @{
                                 @"title": @"iOS中的原型模式",
                                 @"page": @"DYSDemo03ViewController"
                                 },
                             ];
    self.tableView.rowHeight = 50;
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
    
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:(self.dataSourceArray.count - indexPath.row - 1)];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:(self.dataSourceArray.count - indexPath.row - 1)];
    NSString *classString = [dict objectForKey:@"page"];
    UIViewController *vc = [NSClassFromString(classString) new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
