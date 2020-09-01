//
//  DYSDemo02ViewController.m
//  BlockDemo
//
//  Created by 丁玉松 on 2018/10/26.
//  Copyright © 2018 丁玉松. All rights reserved.
//

#import "DYSDemo02ViewController.h"
#import "DYSDog.h"

NSInteger globalInt = 1000;

@interface DYSDemo02ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSourceArray;

@property (nonatomic, strong) DYSDog *dog;

@property (nonatomic, copy) NSString *tmpString;

@property (nonatomic, copy) playBlock tmpBlock;

@end

@implementation DYSDemo02ViewController

- (void)dealloc {
    NSLog(@"DYSDemo02ViewController 释放了");
}

/**
 “如果 block 没有在其他地方被保持，那么它会随着栈生存并且当栈帧（stack frame）返回的时候消失。仅存在于栈上时，block对对象访问的内存管理和生命周期没有任何影响。”
 
 摘录来自: Yourtion. “禅与 Objective-C 编程艺术。” Apple Books.

 
 “被复制到堆上，这样，block 会像其他 Cocoa 对象一样增加引用计数。当它们被复制的时候，它会带着它们的捕获作用域一起，retain 他们所有引用的对象。”
 
 “如果一个 block引用了一个栈变量或指针，那么这个block初始化的时候会拥有这个变量或指针的const副本，所以(被捕获之后再在栈中改变这个变量或指针的值)是不起作用的。”
 如下：blockInt虽然在栈中++了，但是因为tmpBlock对象因为被copy到了堆上，则blockInt被被复制一份到堆里，且为const类型，复制完成之后无论是栈上的block还是刚刚产生在堆上的block，都会引用该变量在堆上的副本。
 
 
 
 “你应该把这两行代码作为 snippet 加到 Xcode 里面并且总是这样使用它们。
 
 __weak __typeof(self)weakSelf = self;
 __strong __typeof(weakSelf)strongSelf = weakSelf;”
 
 摘录来自: Yourtion. “禅与 Objective-C 编程艺术。” Apple Books.
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Block的内存管理";

    self.dataSourceArray = @[
        @"Block创建的内存区域",
        @"Block捕获外部局部变量默认行为",
        @"Block修改外部局部变量",
        @"Block和Self双向强引用-内存泄漏",

        @"Block 对 self 弱引用",
        @"Block 对 self 单向强引用",
        @"Block外弱引用，Block内强引用-最佳实践",
        @"Block和Self双向强引用-Block执行完,self持有的Block指针置为nil-最佳实践",

        @"Block捕获外部全局变量",
        @"__block修饰也会增加引用计数，强引用",
        
        @"全局block",
        @"栈Block",
        @"堆Block",
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
    
    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"dys_test%02tu",indexPath.row+1])];
    
//    switch (indexPath.row) {
//        case 0: {
//            [self dys_test01];
//        } break;
//        case 1: {
//            [self dys_test02];
//        } break;
//        case 2: {
//            [self dys_test03];
//        } break;
//        case 3: {
//            [self dys_test04];
//        } break;
//        case 4: {
//            [self dys_test05];
//        } break;
//        case 5: {
//            [self dys_test06];
//        } break;
//        case 6: {
//            [self dys_test07];
//        } break;
//        case 7: {
//            [self dys_test08];
//        } break;
//        case 8: {
//            [self dys_test09];
//        } break;
//        case 9: {
//            [self dys_test10];
//        } break;
//
//        default:
//            break;
//    }
}

/*
 情景1-如果 block 没有在其他地方被保持，那么它会随着栈生存并且当栈帧（stack frame）返回的时候消失。仅存在于栈上时，block对对象访问的内存管理和生命周期没有任何影响。playblock一直在栈中
 
 1. block 是在栈上创建的。例如：dys_test01
 
 1. Block 可以捕获来自外部作用域的变量。例如：dys_test02
 2. 默认情况下，Block 中捕获的到变量是不能修改的(变量和指针都不能修改)。例如：dys_test02
 “Block会捕获栈上的变量(或指针)，将其复制为自己私有的const(变量)。
 (如果在Block中修改Block块外的)栈上的变量和指针，那么这些变量和指针必须用__block关键字申明(译者注：否则就会跟上面的情况一样只是捕获他们的瞬时值)。”

 
 */
- (void)dys_test01 {
    //1. block 是在栈上创建的
    NSInteger (^add)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b) {
        return a + b;
    };
    DYSDog *aDog = [DYSDog new];
    DYSDog *bDog = [DYSDog new];

    NSLog(@"addBlock: %p", add);  // addBlock: 0x108aef200
    NSLog(@"aDog: %p", aDog);     //aDog: 0x600003bb4650
    NSLog(@"bDog: %p", bDog);     //bDog: 0x600003bb4670

    //2.block捕获指针，block被分配到堆上
    NSInteger (^add2)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b) {
        [aDog dys_run];
        NSLog(@"aDogBlock: %p", aDog);  //aDog: 0x60000219a5f0
        return a + b;
    };

    add2(3, 5);
    NSLog(@"add2Block: %p", add2);  // add2Block: 0x600003c2c840
    NSLog(@"aDog: %p", aDog);       //aDog: 0x600003bb4650

    //3.block捕获变量，block被分配到堆上
    NSInteger blockInt = 5;
    NSInteger (^add3)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b) {
        return a + b + blockInt;
    };

    NSLog(@"add3Block: %p", add3);  // add3Block: 0x6000034a1380

    //4. block赋值给属性Block的地址不会变化。在栈中的还在栈中，在堆中的还在堆中。
    void (^playblock)(void) = ^{
    };
    NSLog(@"playblock: %p", playblock);  // playblock: 0x10b7d0270
    self.tmpBlock = playblock;
    NSLog(@"playblock: %p", playblock);          // playblock: 0x10b7d0270
    NSLog(@"self.tmpBlock: %p", self.tmpBlock);  // self.tmpBlock: 0x10b7d0270

    void (^playblock2)(void) = ^{
        [aDog dys_run];
    };
    NSLog(@"playblock2: %p", playblock2);  // playblock2: 0x600001eec0c0
    self.tmpBlock = playblock2;
    NSLog(@"playblock2: %p", playblock2);        // playblock2: 0x600001eec0c0
    NSLog(@"self.tmpBlock: %p", self.tmpBlock);  // self.tmpBlock: 0x600001eec0c0

    //block捕获全局变量则还在栈中。可以改变全局变量。
    void (^playblock3)(void) = ^{
        globalInt++;
        NSLog(@"globalIntB:%td", globalInt);  //globalIntB:1001
    };
    playblock3();
    globalInt++;
    NSLog(@"globalInt:%td", globalInt);  //globalInt:1002

    NSLog(@"playblock3: %p", playblock3);  // playblock3: 0x100c302d0
    self.tmpBlock = playblock3;
    NSLog(@"playblock3: %p", playblock3);        // playblock3: 0x100c302d0
    NSLog(@"self.tmpBlock: %p", self.tmpBlock);  // self.tmpBlock: 0x100c302d0
}

- (void)dys_test02 {

    CGFloat blockInt = 10;

    DYSDog *aDog = [DYSDog new];
    aDog.name = @"aaa";
    NSLog(@"aDog: %p", aDog);            //aDog: 0x60000141a350
    NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x7ffee4e8e8a0
    NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x7ffeeb4e08a8

    NSLog(@"aDogRetainCountBefore:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountBefore:1

    void (^playblock)(void) = ^{
        //1. Block 可以捕获来自外部作用域的变量。注意捕获二字。但是不能修改外部变量。相当于拿到了外部变量的const版本。
        //2. 默认情况下，Block 中捕获的到变量是不能修改的.
        //blockInt ++;//Variable is not assignable (missing __block type specifier)
        //aDog = [DYSDog new];//Variable is not assignable (missing __block type specifier)

        aDog.name = @"bbb";  //注意是指针不能变化，也就是所指向的对象的地址不能变，但是对象的内容可以变化。

        NSLog(@"aDog: %p", aDog);            //aDog: 0x60000141a350
        NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x600001adefc0
        NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x6000018633e8

        //引用计数并不是简单的+1,而是加2,这是由于block在创建的时候在栈上,而在赋值给全局变量的时候,被拷贝到了堆上
        NSLog(@"aDogRetainCountBlock:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountBlock:3
    };
    playblock();

    NSLog(@"堆%@", [playblock class]);
    NSLog(@"栈%@", [^() {
              NSLog(@"aDog对象地址:%@", aDog);
          } class]);
    /*
     2019-12-06 17:03:39.738443+0800 BlockDemo[94302:11678459] 堆__NSMallocBlock__
     2019-12-06 17:03:39.738748+0800 BlockDemo[94302:11678459] 栈__NSStackBlock__
     */

    NSLog(@"aDog: %p", aDog);            //aDog: 0x60000141a350
    NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x7ffee4e8e8a0
    NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x7ffeeb4e08a8

    NSLog(@"aDogRetainCountAfter:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountAfter:3

    NSLog(@"playblock:%p", playblock);  //playblock:0x60000068c120

    playblock = nil;

    NSLog(@"aDogRetainCountAfter:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountAfter:2

    /*
     综上观察得到：
     1.blockInt的地址 和 aDog指针的地址，被Block捕获后变化了。
     2.aDog的RetainCount加1。
     3.Block捕获的变量和指针，修改后，外部变量不变，（指针的地址和变量的地址）。
     */
}

- (void)dys_test03 {

    __block CGFloat blockInt = 10;

    __block DYSDog *aDog = [DYSDog new];
    aDog.name = @"aaa";
    NSLog(@"aDog: %p", aDog);            //aDog: 0x6000002987a0
    NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x7ffee36ed888
    NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x7ffee36ed8a8

    NSLog(@"aDogRetainCountBefore:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountBefore:1

    void (^playblock)(void) = ^{
        NSLog(@"aDog: %p", aDog);            //aDog: 0x6000002987a0
        NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x600000ee4d78
        NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x6000000c5ad8

        blockInt++;
        aDog = [DYSDog new];

        NSLog(@"aDog: %p", aDog);            //aDog: 0x600000294eb0
        NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x600000ee4d78
        NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x6000000c5ad8

        NSLog(@"aDogRetainCountBlock:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountBlock:1
    };
    playblock();

    NSLog(@"aDog: %p", aDog);            //aDog: 0x600000294eb0
    NSLog(@"&aDog: %p", &aDog);          //&aDog: 0x600000ee4d78
    NSLog(@"&blockInt: %p", &blockInt);  //&blockInt: 0x6000000c5ad8

    NSLog(@"aDogRetainCountAfter:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountAfter:1

    NSLog(@"playblock:%p", playblock);  //playblock:0x600000ee4fc0

    playblock = nil;

    NSLog(@"aDogRetainCountAfter:%td", CFGetRetainCount((__bridge CFTypeRef)(aDog)));  //aDogRetainCountAfter:1

    /*
         综上观察得到：
         1.blockInt的地址 和 aDog指针的地址，被Block捕获后变化了。
         2.aDog的RetainCount未增加说明是week引用。
         3.Block捕获的变量和指针，修改后，外部变量同时跟着变化（指针的地址和变量的地址）。
         */
}
- (void)dys_test04 {
    self.dog = [DYSDog new];
    void (^playblock)(void) = ^{
        [self.dog dys_run];
    };
    self.tmpBlock = playblock;
    /*
     双向强引用，内存泄漏
     */
}

- (void)dys_test05 {

    self.dog = [DYSDog new];
    __weak typeof(self) weakSelf = self;

    void (^playblock)(void) = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!weakSelf) {
                NSLog(@"weakSelf已经释放");
            }
            else {
                [weakSelf.dog dys_run];
            }
        });
    };

    //    self.tmpBlock = playblock;

    playblock();

    /*
     Block 在堆上，是一个对象，有自己完整的生命周期。
     
     2019-12-06 15:19:24.054381+0800 BlockDemo[92920:11511478] DYSDemo02ViewController 释放了
     2019-12-06 15:19:32.573323+0800 BlockDemo[92920:11511478] weakSelf已经释放

     Block 对 self 单向弱引用，self先释放，block执行的时候self已经为nil。
     
     Block 和 self 循环引用，但是block对self是弱引用，self先释放，block执行的时候self已经为nil。
     */
}

- (void)dys_test06 {
    self.dog = [DYSDog new];

    void (^playblock)(void) = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self) {
                NSLog(@"weakSelf已经释放");
            }
            else {
                [self.dog dys_run];
            }
        });
    };

    //    self.tmpBlock = playblock;

    playblock();

    /*
     Block 对 self 单向强引用，Block释放后self也释放了
     
     2019-12-06 15:17:57.072201+0800 BlockDemo[92920:11511478] dog run
     2019-12-06 15:17:57.072412+0800 BlockDemo[92920:11511478] DYSDemo02ViewController 释放了

     */
}

- (void)dys_test07 {

    self.dog = [DYSDog new];
    __weak typeof(self) weakSelf = self;

    void (^playblock)(void) = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.dog dys_run];
    };
    self.tmpBlock = playblock;
    /*
 在Block外部使用弱引用，是为了打破强引用循环。
 在Block内部使用强引用是为了抢占执行的鲁棒性，防止执行过程中self变成nil。
 */
}

- (void)dys_test08 {

    self.dog = [DYSDog new];
    void (^playblock)(void) = ^{
        [self.dog dys_run];
    };
    self.tmpBlock = playblock;
    self.tmpBlock();

    //主动打破引用循环
    self.tmpBlock = nil;
}

- (void)dys_test09 {

    void (^playblock)(void) = ^{
        globalInt++;
    };
    self.tmpBlock = playblock;
    self.tmpBlock();

    //主动打破引用循环
    self.tmpBlock = nil;
}

- (void)dys_test10 {
    /*
     __strong： 赋值给这个变量的对象会自动被retain一次，如果在block中引用它，block也会retain它一次。
     __unsafe_unretained： 赋值给这个变量不会被retain，也就是说被他修饰的变量的存在不能保证持有对象的可靠性，它可能已经被释放了，而且留下了一个不安全的指针。不会被block retain。
     __week：类似于__unsafe_unretained，只是如果所持有的对象被释放后，变量会自动被设置为nil，这样更安全些，不过只在IOS5.0以上的系统支持，同样不会被block retain。
      __block 关键字修饰一个变量，表示这个变量能在block中被修改（值修改，而不是修改对象中的某一个属性，可以理解为修改指针的指向）。会被自动retain。
     
     */

    self.dog = [DYSDog new];
    __block typeof(self) weakSelf = self;

    void (^playblock)(void) = ^{
        [weakSelf.dog dys_run];
    };
    self.tmpBlock = playblock;
    //形成了强应用循环。
}

#pragma mark - Block的几种形式
/*
 全局Block，存储在已初始化数据区（data），不使用外部变量的block是全局block。对全局block进行copy操作仍旧是全局block。
 栈Block，存储在栈区（stack），使用外部变量但是未进行copy操作的block是栈block。
 堆Block，存储在堆区（heap）,对栈block进行copy操作就是堆block。
 
 copy操作：
 
 即如果对栈Block进行copy,将会copy到堆区,对堆Block进行copy,将会增加引用计数，对全局Block进行copy,因为是已经初始化的，所以什么也不做。
 */

/*
 全局Block，存储在已初始化数据区（data），不使用外部变量的block是全局block。对全局block进行copy操作仍旧是全局block。
 */
-(void)dys_test11 {
    NSLog(@"%@",^(){
        NSLog(@"block");
    });
    
    /*
     2020-09-01 22:38:34.088100+0800 BlockDemo[6750:430352] <__NSGlobalBlock__: 0x10572d3d8>
     */
    
    
    void(^globalBlock)(void) = ^(){
        NSLog(@"block");
    };
    NSLog(@"globalBlock:%@",globalBlock);
 
    /*
     2020-09-01 22:52:07.945318+0800 BlockDemo[6972:439034] <__NSGlobalBlock__: 0x10f56a3d8>
     2020-09-01 22:52:07.945531+0800 BlockDemo[6972:439034] globalBlock:<__NSGlobalBlock__: 0x10f56a3f8>
     */
    
}


/*
 栈Block，存储在栈区（stack），使用外部变量但是未进行copy操作的block是栈block。
 */
-(void)dys_test12 {
    
    NSInteger num = 100;
    
    NSLog(@"%@",^(){
        NSLog(@"%tu",num);
    });
    
    /*
     2020-09-01 22:41:12.600623+0800 BlockDemo[6812:432439] <__NSStackBlock__: 0x7ffee22cc880>
     */
    [self dys_testWithBlock:^{
        NSLog(@"self.tmpString:%@",self.tmpString);
    }];
}
 

-(void)dys_testWithBlock:(dispatch_block_t)block {
    block();
    
    NSLog(@"%@",block);
    
    /*
     2020-09-01 22:43:52.770562+0800 BlockDemo[6854:434346] <__NSStackBlock__: 0x7ffee1d8d858>
     */
    
    dispatch_block_t tempBlock = block;
    NSLog(@"tempBlock:%@,block:%@",tempBlock,block);
    /*
     2020-09-01 22:57:30.102614+0800 BlockDemo[7060:442743] tempBlock:<__NSMallocBlock__: 0x600000afcc30>,block:<__NSStackBlock__: 0x7ffee0456858>

     */
    
}

/*
 堆Block，存储在堆区（heap）,对栈block进行copy操作就是堆block。参见上面的 dys_testWithBlock
 */
-(void)dys_test13 {
    
    NSInteger num = 100;
    
    NSLog(@"%@",^(){
        NSLog(@"%tu",num);
    });
    void (^heapBlock)(void) = ^(){
        NSLog(@"%tu",num);
    };
    NSLog(@"heapBlock:%@",heapBlock);
    /*
     2020-09-01 22:52:48.284757+0800 BlockDemo[6972:439034] <__NSStackBlock__: 0x7ffee069b880>
     2020-09-01 22:52:48.285028+0800 BlockDemo[6972:439034] heapBlock:<__NSMallocBlock__: 0x600002bd7e10>
     */
    
    
    
}





@end
