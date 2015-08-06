//
//  MVTableView.m
//  ReactNativeTableView
//
//  Created by Manny Vergel on 8/4/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MVTableView.h"
#import "UIView+React.h"
#import "RCTEventDispatcher.h"
#import "RCTBridge.h"
#import "RCTRootView.h"
#import "AppDelegate.h"

@interface MVTableView()
@property(nonatomic, readonly) UITableView *tableView;
@end

@implementation MVTableView {
  __weak RCTBridge *_bridge;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  self = [super initWithFrame:CGRectZero];
  if (self) {
    _bridge = bridge;
    //TODO: might want to expose the tableview style
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
 
    [self addSubview:self.tableView];
  }
  return self;
}

RCT_NOT_IMPLEMENTED(-initWithCoder:(NSCoder *)aDecoder)

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.frame = self.superview.bounds;
  _tableView.frame = self.bounds;
}

- (void)reactBridgeDidFinishTransaction
{
  if (self.rowHeight) {
    _tableView.rowHeight = [self.rowHeight floatValue];
  }
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.numberOfRowsPerSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.numberOfRowsPerSection objectAtIndex:section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    //TODO: might want to expose table view cell
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  NSDictionary *event = @{@"target": self.reactTag,
                          @"section": @(indexPath.section),
                          @"row":  @(indexPath.row)
                          };
  
  [_bridge.eventDispatcher sendInputEventWithName:@"renderTableRow" body:event];
  
  return cell;
}


- (void)updateRow:(NSDictionary *)sectionRow data:(NSDictionary *)data cellId:(NSString *)cellId {
  //NSLog(@"Rendering row %@ with data %@", sectionRow, data);
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[sectionRow objectForKey:@"row"] integerValue] inSection:[[sectionRow objectForKey:@"section"] integerValue]];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  for (UIView *v in cell.contentView.subviews) {
    [v removeFromSuperview];
  }

  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[AppDelegate getGlobalBridge] moduleName:cellId];
  
  NSMutableDictionary *props = [NSMutableDictionary dictionary];
  [props setObject:sectionRow forKey:@"sectionRow"];
  if (data) {
    [props setObject:data forKey:@"data"];
  }
  [rootView setInitialProperties:props];
  rootView.frame = cell.contentView.bounds;
  [cell.contentView addSubview:rootView];
}


@end
