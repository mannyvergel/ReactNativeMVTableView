//
//  MVTableView.h
//  ReactNativeTableView
//
//  Created by Manny Vergel on 8/4/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import  "RCTBridge.h"
#import "RCTView.h"
#import <UIKit/UIKit.h>

@interface MVTableView : RCTView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSNumber *rowHeight;
@property(nonatomic, retain) NSArray *numberOfRowsPerSection;


- (instancetype)initWithBridge:(RCTBridge *)bridge;

- (void)updateRow:(NSDictionary *)sectionRow data:(NSDictionary *)data cellId:(NSString *)cellId;

@end
