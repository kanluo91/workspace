//
//  ViewController.m
//  HookDemo
//
//  Created by luokan on 2024/10/12.
//

#import "ViewController.h"
#import "fishhook.h"


/**
 替换系统 exit 函数
 */

static int(*sys_exit)(int);

void mycustomexit(int d){
    NSLog(@"调用了自己的exit------------%d",d);
}


/*
 替换系统 NSLog 函数
 */
//函数指针，用来保存原始的函数地址 (C 语言语法，函数指针类型变量)
static void(*sys_nslog)(NSString * format,...);
//定义一个新的函数
void myNslog(NSString * format,...){
    format = [format stringByAppendingString:@"勾上了！\n"];
    //调用原始的
    sys_nslog(format);
}

@interface ViewController ()

@property (nonatomic,strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self start_fishhook];
}

-(void) initUI{
    self.view.backgroundColor = UIColor.whiteColor;
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(100, 100, 100, 100);
    self.btn.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) start_fishhook{
    struct rebinding rebind1;
    rebind1.name = "NSLog"; // 函数名称
    rebind1.replacement = myNslog; // 新的函数指针
    rebind1.replaced = (void *)&sys_nslog;// 保存原始函数地址的变量的指针
    
    struct rebinding rebind2; //
    rebind2.name = "exit";  // 函数符号
    rebind2.replacement = mycustomexit; // 新函数地址
    rebind2.replaced = (void *)&sys_exit; // 原始函数地址的指针
     
//     // 创建数组
//     struct rebinding rebinds[]={rebind1,rebind2};
//     // 重绑定
//     rebind_symbols(rebinds, 2);
    
    // 创建数组
    struct rebinding rebinds[]={rebind2};
    // 重绑定
    rebind_symbols(rebinds, 1);
}

-(void)btnClick:(UIButton *)sender{
    NSLog(@"🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺🍺 btnClick\n");
    exit(0);
}

@end
