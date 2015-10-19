//
//  HWHomeViewController.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWHomeViewController.h"
#import "HWDropdownMenu.h"
#import "HWTitleMenuViewController.h"
#import "AFNetworking.h"
#import "HWAccountTool.h"
#import "HWTitleButton.h"
#import "UIImageView+WebCache.h"
#import "HWUser.h"
#import "HWStatus.h"
#import "MJExtension.h"
#import "HWLoadMoreFooter.h"
#import "HWStatusCell.h"
#import "HWStautsFrame.h"

@interface HWHomeViewController () <HWDropdownMenuDelegate>
/**
 *  微博数组（里面放的都是HWStatus模型，一个HWStatus对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation HWHomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    
    return _statusFrames;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获得用户信息（昵称）
    [self setupUserInfo];
    
    [self setupUpRefresh];

    //refresh
    [self setupRefresh];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void) setupUnreadCount
{
    NSLog(@"request unread...begin");
    AFHTTPRequestOperationManager * mgr
    = [AFHTTPRequestOperationManager manager];
    
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json"
  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSString * status = [responseObject[@"status"] description];
      NSLog(@"%@",status);
      self.tabBarItem.badgeValue = [status isEqualToString:@"0"]?nil:status;
//      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//      [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
      [UIApplication sharedApplication].applicationIconBadgeNumber = [status isEqualToString:@"0"]?0:status.intValue;
      
      
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     HWLog(@"请求失败-%@", error);
  }];

}

- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray * frames = [NSMutableArray array];
    for (HWStatus *status in statuses) {
        HWStautsFrame *f = [[HWStautsFrame alloc]init];
        f.status = status;
        [frames addObject:f];
    }
    
    return  frames;

}

//UP TO REFRESH
- (void)setupUpRefresh
{
    HWLoadMoreFooter * footer = [HWLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}


- (void) setupRefresh
{
    UIRefreshControl * control = [[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    [control beginRefreshing];
    [self loadNewStatus:control];
    
}

/**
*  加载最新的微博数据
*/
- (void)loadNewStatus:(UIRefreshControl *)control
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //    params[@"count"] = @10;
    HWStautsFrame  * firstStatusF  = [self.statusFrames firstObject];
    if (firstStatusF) {
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSArray * newStatuses =
        [HWStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
      
        NSArray * newFrames = [self statusFramesWithStatuses:newStatuses];
        
        
        NSRange range = NSMakeRange(0, newStatuses.count);
        
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        //refresh table
        [self.tableView reloadData];
        
        //end refresh
        [control endRefreshing];
        [self showNewStatusCount:newStatuses.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HWLog(@"请求失败-%@", error);
          [control endRefreshing];
    }];
}

- (void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //    params[@"count"] = @10;

    HWStautsFrame * lastStatusF  = [self.statusFrames lastObject];
    if (lastStatusF) {
        long long maxId = lastStatusF.status.idstr.longLongValue -1;
        params[@"max_id"] = @(maxId);
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSArray * newStatuses =
        [HWStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSArray * newFrames = [self statusFramesWithStatuses:newStatuses];
        
        
        [self.statusFrames addObjectsFromArray:newFrames];
        //refresh table
        [self.tableView reloadData];
   
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HWLog(@"请求失败-%@", error);
    }];
}

- (void)showNewStatusCount:(int)count
{
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UILabel * label = [[UILabel alloc]init];
    //set background
    label.backgroundColor = [UIColor
                             colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    //deal with count = 0
    if (count == 0) {
        label.text = @"没有新的微博数据，请稍后再试";
    }else{
        label.text = [NSString stringWithFormat:@"共有%d条新的微博数据",count];
    }
    label.textColor = 	[UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    //set textcolor
    label.y = 64 - label.height;
    
    //add to  navigationController.view
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //set animation

    //duration
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform =CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    
}


/**
 *  获得用户信息（昵称）
 */
- (void)setupUserInfo
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    HWAccount *account = [HWAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        HWUser *user = [HWUser objectWithKeyValues:responseObject];
//        NSString *name = responseObject[@"name"];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        [HWAccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HWLog(@"请求失败-%@", error);
    }];
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    /* 中间的标题按钮 */
    HWTitleButton *titleButton = [[HWTitleButton alloc] init];
    // 设置图片和文字
    NSString *name = [HWAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    // 监听标题点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}

/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    HWDropdownMenu *menu = [HWDropdownMenu menu];
    menu.delegate = self;
    
    // 2.设置内容
    HWTitleMenuViewController *vc = [[HWTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}

- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}

#pragma mark - HWDropdownMenuDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(HWDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(HWDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWStatusCell *cell = [HWStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWStautsFrame * frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.statusFrames.count==0) {
        return;
    }
    
    //see the last of cell
    CGFloat judgeOffsetY
    = scrollView.contentSize.height+scrollView.contentInset.bottom
    - scrollView.height-self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) {
        self.tableView.tableFooterView.hidden = NO;
        HWLog(@"加载更多的微博数据");
        [self loadMoreStatus];
    }
    

}

/**
 1.将字典转为模型
 2.能够下拉刷新最新的微博数据
 3.能够上拉加载更多的微博数据
 */


@end
