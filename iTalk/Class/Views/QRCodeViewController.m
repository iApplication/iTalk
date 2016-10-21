//
//  QRCodeViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-5.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCodeGenerator.h"
#import "POP.h"

@interface QRCodeViewController ()

@property (strong, nonatomic)UIImageView * imageviewQR;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的二维码";
    
    self.imageviewQR = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.imageviewQR.center = CGPointMake(self.view.center.x, self.view.center.y-100) ;
    self.imageviewQR.image = [QRCodeGenerator qrImageForString:[LJUtil username] imageSize:200];
    [self.view addSubview:self.imageviewQR];
    
    [self performSelector:@selector(startSpringAnimation) withObject:nil afterDelay:0.8f];
}

- (void)startSpringAnimation
{
    //初始化springAnimation
    POPSpringAnimation * sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    sizeAnimation.springSpeed = 0.f;
    sizeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    
    //添加动画
    [self.imageviewQR pop_addAnimation:sizeAnimation forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
