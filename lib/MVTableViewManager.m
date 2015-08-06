//
//  MVTableViewManager.m
//  ReactNativeMVTableView
//
//  Created by Manny Vergel on 8/5/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "MVTableViewManager.h"
#import "MVTableView.h"
#import "RCTEventDispatcher.h"
#import "UIView+React.h"
#import "RCTBridge.h"
#import "RCTUIManager.h"
#import "RCTSparseArray.h"

@interface MVTableViewManager()
@end

@implementation MVTableViewManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[MVTableView alloc] initWithBridge:self.bridge];
}

RCT_EXPORT_VIEW_PROPERTY(rowHeight, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(numberOfRowsPerSection, NSArray)

RCT_EXPORT_METHOD(updateRowWithOptions:(NSDictionary *)opts callback:(RCTResponseSenderBlock)callback) {
  NSDictionary *sectionRow = [opts objectForKey:@"sectionRow"];
  //NSDictionary *viewToAdd = [opts objectForKey:@"viewToAdd"];
  NSNumber *reactTag = [opts objectForKey:@"reactTag"];
  NSDictionary *data = [opts objectForKey:@"data"];
  NSString *cellId = [opts objectForKey:@"cellId"];
  [self.bridge.uiManager addUIBlock:
   ^(__unused RCTUIManager *uiManager, RCTSparseArray *viewRegistry){
     MVTableView *mvTableView = viewRegistry[reactTag];
     if ([mvTableView isKindOfClass:[MVTableView class]]) {
       [mvTableView updateRow:sectionRow data:data cellId:cellId];
       callback(@[]);
     } else {
       RCTLogError(@"Cannot set lock: %@ (tag #%@) is not an MVTableView", mvTableView, reactTag);
     }
   }];
}


- (NSDictionary *)customDirectEventTypes
{
  return @{
           @"renderTableRow":  @{ @"registrationName": @"onRenderTableRow" }
           };
}


@end
