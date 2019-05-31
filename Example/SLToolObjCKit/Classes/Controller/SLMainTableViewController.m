//
//  SLMainTableViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/30.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLMainTableViewController.h"

@interface SLMainTableViewController ()
/** 数据源 */
@property (strong, nonatomic) NSArray<NSString *> *items;
@end

@implementation SLMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"工具类集合";
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.确定重用标示
    static NSString *identifier = @"cell";
    // 2.从缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.items[indexPath.item];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *name = cell.textLabel.text;
    NSArray *array = [name componentsSeparatedByString:@"-"];
    id class = [[NSClassFromString(array.lastObject) alloc] init];
    if ([class isKindOfClass:[UIViewController class]]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:array.lastObject];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.navigationItem.title = array.firstObject;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - Getter
- (NSArray<NSString *> *)items {
    if (!_items) {
        _items = @[
                   @"线程保活-SLThreadViewController",
                   @"定时器-SLTimerViewController",
                   @"下载器-SLDownloadViewController",
                   @"远程音频播放-SLAudioPlayerViewController"
                   ];
    }
    
    return _items;
}


@end
