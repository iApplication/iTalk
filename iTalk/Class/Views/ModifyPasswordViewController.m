//
//  ModifyPasswordViewController.m
//  iTalk
//
//  Created by locky1218 on 15-4-4.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)backTap:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)modifyTap:(UIButton *)sender {
    NSString * oldpwd = self.oldPwd.text;
    NSString * changepwd = self.changePwd.text;
    NSString * confirmpwd = self.confirmPwd.text;
    
    oldpwd = [LJUtil trim:oldpwd];
    changepwd = [LJUtil trim:changepwd];
    confirmpwd = [LJUtil trim:confirmpwd];
    
    if([oldpwd isEqualToString:@""])
    {
        [LJUtil alert:@"旧密码不能为空"];
        self.oldPwd.text = @"";
        [self.oldPwd becomeFirstResponder];
        return;
    }
    if([changepwd isEqualToString:@""])
    {
        [LJUtil alert:@"新密码不能为空"];
        self.changePwd.text = @"";
        [self.changePwd becomeFirstResponder];
        return;
    }
    if([confirmpwd isEqualToString:@""])
    {
        [LJUtil alert:@"确认密码不能为空"];
        self.confirmPwd.text = @"";
        [self.confirmPwd becomeFirstResponder];
        return;
    }
    
    //旧密码是否正确
    if([oldpwd isEqualToString:[LJUtil userpwd]])//旧密码正确
    {
        //新密码是否相同
        if([changepwd isEqualToString:oldpwd])
        {
            [LJUtil alert:@"新密码不能与旧密码相同"];
            [self.changePwd becomeFirstResponder];
            return;
        }
        //修改密码是否与新密码相同
        if(![confirmpwd isEqualToString:changepwd])
        {
            [LJUtil alert:@"两次密码不相同"];
            [self.confirmPwd becomeFirstResponder];
            return;
        }
    }
    else//旧密码错误
    {
        [LJUtil alert:@"旧密码错误，无法修改"];
        self.oldPwd.text = @"";
        [self.oldPwd becomeFirstResponder];
        return;
    }
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:9090/plugins/userService/userservice?type=update&secret=55w7L08t&username=%@&password=%@", DOMAIN_NAME, [LJUtil username], changepwd]];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:url];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data)
    {
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSRange range = [str rangeOfString:@"<result>ok</result>"];
        if(range.location != NSNotFound)
        {
            [LJUtil alert:@"密码修改成功"];
        }
        else
        {
            [LJUtil alert:@"密码修改失败，请稍后再试"];
        }
    }
    else
    {
        [LJUtil alert:@"修改密码失败，请稍后再试"];
    }
}

- (IBAction)closeKeyboard:(id)sender {
}
@end
