//
//  ViewController.m
//  Runtime-Associated
//
//  Created by hu on 2017/11/8.
//  Copyright © 2017年 huweihong. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //给系统NSObject类动态添加属性name
    NSObject * objc = [[NSObject alloc]init];

    // 1.这个是分类不能添加属性
//    objc.name = @"123";
//    NSLog(@"%@",objc.name);

    UIButton * deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    deleteButton.center = self.view.center;
    [deleteButton setTitle:@"删除" forState:0];
    [deleteButton setTitleColor:[UIColor blueColor] forState:0];
    [deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];


}
- (void)deleteClick:(UIButton *)sender{
    //2.给对象添加关联对象
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认要删除这个宝贝" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //传递多参数
    objc_setAssociatedObject(alert, "suppliers_id", @"1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(alert, "warehouse_id", @"2", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    alert.tag = [recId intValue];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString * warehouse_id = objc_getAssociatedObject(alertView, "warehouse_id");
        NSString * suppliers_id = objc_getAssociatedObject(alertView, "suppliers_id");
        NSString *recId = [NSString stringWithFormat:@"%ld",(long)alertView.tag];
    }
}
@end

// 定义关联的key
static const char * key = "name";

@implementation NSObject (Property)

- (NSString *)name
{
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, key);
}

- (void)setName:(NSString *)name
{
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
