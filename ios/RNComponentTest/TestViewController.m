//
//  TestViewController.m
//  RNComponentTest
//
//  Created by mo shanping on 2017/10/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "TestViewController.h"
#import "RNViewController.h"

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  CGSize size = [[UIScreen mainScreen] bounds].size;
  UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
  tableView.delegate = self;
  tableView.dataSource = self;
  [self.view addSubview:tableView];
  
  NSString * path = @"/assets/comAResource/deer.png";
  UIImage * image = [UIImage imageWithContentsOfFile:path];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
  
  if(cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
  }

  cell.textLabel.text = [NSString stringWithFormat:@"显示第%ld个RN模块",indexPath.row];
  
  return cell;
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RNViewController * vc = [[RNViewController alloc] init];
    vc.moduleName = @"DeviceInfoScreen";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
