//
//  MyInfoViewController.m
//  MySchool
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyInfoViewController.h"

#define USERNAME @"username"
#define ID @"id"
#define PREOFESSION @"profession"
#define SCHOOL @"school"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,retain)UITableView *infoTableView;
@property(nonatomic,retain)UITextField *username;
@property(nonatomic,retain)UITextField *studentId;
@property(nonatomic,retain)UITextField *profession;
@property(nonatomic,retain)UITextField *school;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的信息";
    
    _infoTableView                  = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 300)];
    _infoTableView.backgroundColor  =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];;

    _infoTableView.delegate     = self;
    _infoTableView.dataSource   = self;
    
    [self.view addSubview:_infoTableView];
    [self setExtraCellLineHidden:_infoTableView];
    
    self.view.backgroundColor   = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    //添加手势
    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnKeyBoard)];
    recongnizer.numberOfTapsRequired    = 1; // 单击
    [_infoTableView addGestureRecognizer:recongnizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view         = [UIView new];
    view.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];;
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"infocell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSString *studentUsername       = [userDefaults objectForKey:USERNAME];
    NSString *studentID             = [userDefaults objectForKey:ID];
    NSString *studentProfession     = [userDefaults objectForKey:PREOFESSION];
    NSString *studentSchool         = [userDefaults objectForKey:SCHOOL];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text     = @"姓名";
        cell.textLabel.font     = [UIFont systemFontOfSize:14.0];
         _username              = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _username.textAlignment = NSTextAlignmentRight;
        _username.font          = [UIFont systemFontOfSize:14.0];
        _username.placeholder   = @"填写";
        _username.text          = studentUsername;
        _username.tag           = 100;
        _username.delegate      = self;
        _username.returnKeyType = UIReturnKeyDone;
        cell.accessoryView      = _username;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text         = @"学号";
        cell.textLabel.font         = [UIFont systemFontOfSize:14.0];
        _studentId                  = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _studentId.textAlignment    = NSTextAlignmentRight;
        _studentId.font             = [UIFont systemFontOfSize:14.0];
        _studentId.placeholder      = @"填写";
        _studentId.text             = studentID;
        _studentId.tag              = 101;
        _studentId.delegate         = self;
        _studentId.returnKeyType    = UIReturnKeyDone;
        cell.accessoryView          = _studentId;

    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text         = @"专业";
        cell.textLabel.font         = [UIFont systemFontOfSize:14.0];
        _profession                 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _profession.textAlignment   = NSTextAlignmentRight;
        _profession.font            = [UIFont systemFontOfSize:14.0];
        _profession.placeholder     = @"填写";
        _profession.text            = studentProfession;
        _profession.tag             = 102;
        _profession.delegate        = self;
        _profession.returnKeyType   = UIReturnKeyDone;
        cell.accessoryView          = _profession;

    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text         = @"所在学校";
        cell.textLabel.font         = [UIFont systemFontOfSize:14.0];
        _school                     = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _school.textAlignment       = NSTextAlignmentRight;
        _school.font                = [UIFont systemFontOfSize:14.0];
        _school.placeholder         = @"填写";
        _school.text                = studentSchool;
        _school.tag                 = 103;
        _school.delegate            = self;
        _school.returnKeyType       = UIReturnKeyDone;
        cell.accessoryView          = _school;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)returnKeyBoard
{
    [_username resignFirstResponder];
    [_studentId resignFirstResponder];
    [_profession resignFirstResponder];
    [_school resignFirstResponder];

}


- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (textField.tag       == 100)
    {
        [userDefaults setObject:textField.text forKey:USERNAME];
    }
    else if (textField.tag  == 101)
    {
        [userDefaults setObject:textField.text forKey:ID];
    }
    else if (textField.tag  == 102)
    {
        [userDefaults setObject:textField.text forKey:PREOFESSION];
    }
    else if (textField.tag  == 103)
    {
        [userDefaults setObject:textField.text forKey:SCHOOL];
    }

}



@end
