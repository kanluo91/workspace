//
//  YYWeiboFeedListController.m
//  YYKitExample
//
//  Created by ibireme on 15/9/4.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBStatusTimelineViewController.h"
#import "WBModel.h"
#import "WBStatusCell.h"
#import "WBStatusComposeViewController.h"
#import "WBStatusLayout.h"
#import "YYFPSLabel.h"
#import "YYKit.h"
#import "YYPhotoGroupView.h"
#import "YYSimpleWebViewController.h"
#import "YYTableView.h"


@interface WBStatusTimelineViewController () <UITableViewDelegate, UITableViewDataSource, WBStatusCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *feedsView;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation WBStatusTimelineViewController

- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _feedsView = _tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[WBStatusHelper imageNamed:@"toolbar_compose_highlighted"] style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    rightItem.tintColor = UIColorHex(fd8224);
    self.navigationItem.rightBarButtonItem = rightItem;

    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kWBCellBackgroundColor;

    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - kWBCellPadding;
    _fpsLabel.left = kWBCellPadding;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];

    if (kSystemVersion < 7) {
        _fpsLabel.top -= 44;
        _tableView.top -= 64;
        _tableView.height += 20;
    }


    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i <= 7; i++) {
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"weibo_%d.json", i]];
            WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
            for (WBStatus *status in item.statuses) {
                WBStatusLayout *layout = [[WBStatusLayout alloc] initWithStatus:status style:WBLayoutStyleTimeline];
                //                [layout layout];
                [_layouts addObject:layout];
            }
        }

        // ??????????????????????????????????????????????????????????????????
        [_layouts addObjectsFromArray:_layouts];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Weibo (loaded:%d)", (int)_layouts.count];
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [_tableView reloadData];
        });
    });
}

- (void)sendStatus {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeStatus;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _fpsLabel.alpha = 1;
                         }
                         completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1
                                  delay:2
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 _fpsLabel.alpha = 0;
                             }
                             completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1
                              delay:2
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _fpsLabel.alpha = 0;
                         }
                         completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             _fpsLabel.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((WBStatusLayout *)_layouts[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (id)tableView:(UITableView *)tableView modelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"cell: %d, %d", indexPath.section, indexPath.row];
}

#pragma mark - WBStatusCellDelegate
// ??????????????? Router ???????????????????????????????????????Demo???????????????????????????

/// ????????? Cell
- (void)cellDidClick:(WBStatusCell *)cell {
}

/// ????????? Card
- (void)cellDidClickCard:(WBStatusCell *)cell {
    WBPageInfo *pageInfo = cell.statusView.layout.status.pageInfo;
    NSString *url = pageInfo.pageURL; // sinaweibo://... ????????? Weibo.app ?????????
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.title = pageInfo.pageTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

/// ?????????????????????
- (void)cellDidClickRetweet:(WBStatusCell *)cell {
}

/// ????????? Cell ??????
- (void)cellDidClickMenu:(WBStatusCell *)cell {
}

/// ??????????????? Tag
- (void)cellDidClickTag:(WBStatusCell *)cell {
    WBTag *tag = cell.statusView.layout.status.tagStruct.firstObject;
    NSString *url = tag.tagScheme; // sinaweibo://... ????????? Weibo.app ?????????
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    vc.title = tag.tagName;
    [self.navigationController pushViewController:vc animated:YES];
}

/// ???????????????
- (void)cellDidClickFollow:(WBStatusCell *)cell {
}

/// ???????????????
- (void)cellDidClickRepost:(WBStatusCell *)cell {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeRetweet;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// ???????????????
- (void)cellDidClickComment:(WBStatusCell *)cell {
    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    vc.type = WBStatusComposeViewTypeComment;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    @weakify(nav);
    vc.dismiss = ^{
        @strongify(nav);
        [nav dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:nav animated:YES completion:NULL];
}

/// ????????????
- (void)cellDidClickLike:(WBStatusCell *)cell {
    WBStatus *status = cell.statusView.layout.status;
    [cell.statusView.toolbarView setLiked:!status.attitudesStatus withAnimation:YES];
}

/// ???????????????
- (void)cell:(WBStatusCell *)cell didClickUser:(WBUser *)user {
    if (user.userID == 0)
        return;
    NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/u/%lld", user.userID];
    YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:vc animated:YES];
}

/// ???????????????
- (void)cell:(WBStatusCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    WBStatus *status = cell.statusView.layout.status;
    NSArray<WBPicture *> *pics = status.retweetedStatus ? status.retweetedStatus.pics : status.pics;

    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        WBPicture *pic = pics[i];
        WBPictureMetadata *meta = pic.largest.badgeType == WBPictureBadgeTypeGIF ? pic.largest : pic.large;
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = meta.url;
        item.largeImageSize = CGSizeMake(meta.width, meta.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }

    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// ????????? Label ?????????
- (void)cell:(WBStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length)
        return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0)
        return;

    if (info[kWBLinkHrefName]) {
        NSString *url = info[kWBLinkHrefName];
        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    if (info[kWBLinkURLName]) {
        WBURL *url = info[kWBLinkURLName];
        WBPicture *pic = url.pics.firstObject;
        if (pic) {
            // ????????????????????? "????????????"
            YYTextAttachment *attachment = [label.textLayout.text attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
            if ([attachment.content isKindOfClass:[UIView class]]) {
                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
                info.largeImageURL = pic.large.url;
                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);

                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
            }

        } else if (url.oriURL.length) {
            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url.oriURL]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }

    if (info[kWBLinkTagName]) {
        WBTag *tag = info[kWBLinkTagName];
        NSLog(@"tag:%@", tag.tagScheme);
        return;
    }

    if (info[kWBLinkTopicName]) {
        WBTopic *topic = info[kWBLinkTopicName];
        NSString *topicStr = topic.topicTitle;
        topicStr = [topicStr stringByURLEncode];
        if (topicStr.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@", topicStr];
            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }

    if (info[kWBLinkAtName]) {
        NSString *name = info[kWBLinkAtName];
        name = [name stringByURLEncode];
        if (name.length) {
            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@", name];
            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
}

@end
