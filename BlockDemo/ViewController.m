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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)itemClick:(id)sender {
    NSInteger viewTag = 0;
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
        viewTag = tap.view.tag;
    }
    else{
        UIView *view = (UIView *)sender;
        viewTag = view.tag;
    }
    
    
    switch (viewTag) {
        case 0:{//
            SecondViewController *vc = [[SecondViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];            
        }
            break;
        case 1:{
            ThirdViewController *vc = [[ThirdViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}




@end
