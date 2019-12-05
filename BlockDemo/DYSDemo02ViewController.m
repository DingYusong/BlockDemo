//
//  DYSDemo02ViewController.m
//  BlockDemo
//
//  Created by 丁玉松 on 2018/10/26.
//  Copyright © 2018 丁玉松. All rights reserved.
//

#import "DYSDemo02ViewController.h"
#import "FourthViewController.h"

@interface DYSDemo02ViewController ()
@property (nonatomic ,copy) NSString *tmpString;

@property (nonatomic ,copy) playBlock tmpBlock;

@end

@implementation DYSDemo02ViewController

- (void)dealloc{
    NSLog(@"ThirdViewController 释放了");
}

/**
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //情景1-如果 block 没有在其他地方被保持，那么它会随着栈生存并且当栈帧（stack frame）返回的时候消失。仅存在于栈上时，block对对象访问的内存管理和生命周期没有任何影响。playblock一直在栈中
//    self.tmpString = @"asdfasdf";
//    CGFloat blockInt = 10;
//    void (^playblock)(void) = ^{
//        NSLog(@"blockInt = %f", blockInt);
//        NSLog(@"tmpString：%@",self.tmpString);
//    };
//    blockInt ++;
//    NSLog(@"blockInt In stack = %f", blockInt);
//    playblock();

    
    
    //情景2-不会释放因为copy到堆上的block对象，持有self，self的引用计数加一，即使导航控制器退栈引用计数也不为0，所以不会释放。
    
//    self.tmpString = @"asdfasdf";
//    CGFloat blockInt = 10;
//    self.tmpBlock = ^{
//        NSLog(@"blockInt = %f", blockInt);
//        NSLog(@"tmpString：%@",self.tmpString);
//    };
//    blockInt ++;
//    NSLog(@"blockInt In stack = %f", blockInt);
//    self.tmpBlock();
    
    
    
    //情景3-会释放因为copy到堆上的block对象，被置为nil，他持有的self的引用计数减一，导航控制器退栈之后引用计数为0，会释放。
//    self.tmpString = @"asdfasdf";
//    CGFloat blockInt = 10;
//    self.tmpBlock = ^{
//        NSLog(@"blockInt = %f", blockInt);
//        NSLog(@"tmpString：%@",self.tmpString);
//    };
//    blockInt ++;
//    NSLog(@"blockInt In stack = %f", blockInt);
//    self.tmpBlock();
//    self.tmpBlock = nil;

    
    //情景4-会释放因为copy到堆上的block对象，使用过week引用self，不会使self的引用计数加1，导航控制器退栈之后引用计数为0，会释放。
    self.tmpString = @"asdfasdf";
    CGFloat blockInt = 10;
    __weak __typeof(self)weakSelf = self;
    self.tmpBlock = ^{
        __strong DYSDemo02ViewController *strongSelf = weakSelf;//此时strongSelf是一个局部变量，block执行完成后，strongSelf释放，self的引用基数为0，self释放，self释放后block的引用计数为减为0，block释放。
        NSLog(@"blockInt = %f", blockInt);
        NSLog(@"tmpString：%@",strongSelf.tmpString);
    };
    blockInt ++;
    NSLog(@"blockInt In stack = %f", blockInt);
    self.tmpBlock();

    
    //数值逻辑
    
    //情景5-“__block 变量不会在 block 中被持有”,“这个指针或者原始的类型依赖它们在的栈”从打印结果可以看出tmpBlock中的blockInt没有被拷贝到堆上，任然引用的是栈中的blockInt。
//        self.tmpString = @"asdfasdf";
//        __block CGFloat blockInt = 10;
//        __weak __typeof(self)weakSelf = self;
//        self.tmpBlock = ^{
//            NSLog(@"blockInt = %f", blockInt);
//            NSLog(@"tmpString：%@",weakSelf.tmpString);
//        };
//        blockInt ++;
//        NSLog(@"blockInt In stack = %f", blockInt);
//        self.tmpBlock();

    
    
    //情景6 - block传递
//    self.tmpString = @"asdfasdf";
//    __block CGFloat blockInt = 10;
//    __weak __typeof(self)weakSelf = self;
//    self.tmpBlock = ^{
//        NSLog(@"blockInt = %f", blockInt);
//        NSLog(@"tmpString：%@",weakSelf.tmpString);
//        [weakSelf helloWorld1];
//        [weakSelf helloWorld2];
//    };
//    blockInt ++;
//    NSLog(@"blockInt In stack = %f", blockInt);
//    self.tmpBlock();
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 100, 30);
//    btn.center = self.view.center;
//    [btn setTitle:@"跳转" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    
    //情景7-
//    self.tmpString = @"asdfasdf";
//    CGFloat blockInt = 10;
//    __weak NSString *stackString = @"stackString";
//    
//    void (^playblock)(void) = ^{
//        NSLog(@"blockInt = %f", blockInt);
//        NSLog(@"tmpString：%@",self.tmpString);
//        
//        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
//            
//            for (int i = 0; i < 10; i++) {
//                // 模拟一个耗时的任务
//                [NSThread sleepForTimeInterval:1];
//            }
//            
//            NSLog(@"耗时的任务 结束 blockInt = %f", blockInt);
//            NSLog(@"stackString:%@",stackString);
//        });
//        
//    };
//    blockInt ++;
//    NSLog(@"blockInt In stack = %f", blockInt);
//    playblock();

    
    
    //情景8 -
//    self.tmpString = @"asdfasdf";
//    __block CGFloat blockInt = 10;
//    __weak __typeof(self)weakSelf = self;
//    self.tmpBlock = ^{
//        NSLog(@"blockInt = %f", blockInt);
//        NSLog(@"tmpString：%@",weakSelf.tmpString);
//        [weakSelf helloWorld1];
//        [weakSelf helloWorld2];
//    };
//    blockInt ++;
//    NSLog(@"blockInt In stack = %f", blockInt);
//    self.tmpBlock();
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 100, 30);
//    btn.center = self.view.center;
//    [btn setTitle:@"跳转" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];

    
    //情景9 -
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 100, 30);
//    btn.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
//    [btn setTitle:@"情景9-跳转2" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

//情景8
-(void)btnClick:(UIButton *)btn{
    FourthViewController *vc = [[FourthViewController alloc] init];
    vc.myblock = self.tmpBlock;
    [self.navigationController pushViewController:vc animated:YES];
}

//情景9
-(void)btn2Click:(UIButton *)btn{
    FourthViewController *vc = [[FourthViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    __weak FourthViewController* weakvc = vc;
    self.tmpString = @"asdfasdf";
    CGFloat blockInt = 10;
    __weak NSString *stackString = @"stackString";
    
    void (^playblock)(void) = ^{
        __strong FourthViewController *stongVC = weakvc;
        NSLog(@"blockInt = %f", blockInt);
        NSLog(@"tmpString：%@",self.tmpString);
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
            for (int i = 0; i < 5; i++) {
                // 模拟一个耗时的任务
                [NSThread sleepForTimeInterval:1];
            }
            NSLog(@"耗时的任务 结束 blockInt = %f", blockInt);
            NSLog(@"stackString:%@",stackString);
            [stongVC helloFourth];
        });
    };
    blockInt ++;
    NSLog(@"blockInt In stack = %f", blockInt);
    playblock();
    
    void (^blockName)(void) = ^void{
        NSLog(@"block running");
    };
    [self executeBlock:blockName];
    
    
    [self executeBlock:^ void {
        NSLog(@"haha");
    }];
}


-(void)executeBlock:(void(^)(void))completion{
    
    self.tmpBlock = completion;
    self.tmpBlock();
}

- (void)helloWorld1{
    NSLog(@"HelloWorld1");
}

- (void)helloWorld2{
    NSLog(@"HelloWorld2");
}



@end
