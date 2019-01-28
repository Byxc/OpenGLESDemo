//
//  HomeViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/8/8.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *dataSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo";
    
    [self setNavigationButton];
    [self loadListData];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
}

- (void)setNavigationButton {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - Data
- (void)loadListData {
    _dataSource = @[
                    @{@"cls":@"Test1ViewController",@"title":@"三角形"},
                    @{@"cls":@"Test2ViewController",@"title":@"移动的三角形"},
                    @{@"cls":@"Test3ViewController",@"title":@"变换矩阵"},
                    @{@"cls":@"Test4ViewController",@"title":@"透视投影和正交投影"},
                    @{@"cls":@"Test5ViewController",@"title":@"摄像机"},
                    @{@"cls":@"Test6ViewController",@"title":@"正方体"},
                    @{@"cls":@"Test7ViewController",@"title":@"基本光照"},
                    @{@"cls":@"Test8ViewController",@"title":@"基本纹理"},
                    @{@"cls":@"Test9ViewController",@"title":@"顶点缓冲区(VBO&VAO)"},
                    ];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *dict = _dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd. %@",indexPath.row+1,dict[@"title"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _dataSource[indexPath.row];
    NSString *clsName = dict[@"cls"];
    Class cls = NSClassFromString(clsName);
    UIViewController *viewController = [[cls alloc] init];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        viewController.title = dict[@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
