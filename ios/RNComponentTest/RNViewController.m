//
//  RNViewController.m
//  RNComponentTest
//
//  Created by mo shanping on 2017/10/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RNViewController.h"
#import <React/RCTRootView.h>
#import "DiffMatchPatch.h"

@interface RNViewController ()<RCTBridgeDelegate>

@end

@implementation RNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //new一个bridge, 设置代理 ，让它去读取bundle文件
    RCTBridge *bridge = [[RCTBridge alloc]initWithDelegate:self launchOptions:nil];
  
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:self.moduleName initialProperties:nil];
    self.view = rootView;
}

#pragma mark -  RCTBridgeDelegate
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    NSString *path = [self getNewBundle];
    NSURL *jsBundleURL = [NSURL URLWithString:path];
    return jsBundleURL;
}

//合成新的bundle文件，并返回文件路径
- (NSString *)getNewBundle {
  
    //路径
    NSString *commonBundlePath = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"jsbundle"];
    //从common.js读取NSString内容
    NSString *commonBundleJSCode = [[NSString alloc] initWithContentsOfFile:commonBundlePath encoding:NSUTF8StringEncoding error:nil];
    //patch文件路径
    NSString *patch1Path = [[NSBundle mainBundle] pathForResource:self.moduleName ofType:@"patch"];
    //patch文件中读取NSString内容
    NSString *patch1JSCode = [[NSString alloc] initWithContentsOfFile:patch1Path encoding:NSUTF8StringEncoding error:nil];
  
    //diff-match-patch
    DiffMatchPatch *diffMatchPatch = [[DiffMatchPatch alloc] init];
    NSArray *convertedPatches = [diffMatchPatch patch_fromText:patch1JSCode error:nil];
    NSArray *resultsArray = [diffMatchPatch patch_apply:convertedPatches toString:commonBundleJSCode];
    //合并后的内容
    NSString *resultJSCode = resultsArray[0];
  
    //生成新的bundle文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *newPath = [NSString stringWithFormat:@"%@/%@.jsbundle",docDir,self.moduleName];
  
    if (resultsArray.count > 1) {
      [resultJSCode writeToFile:newPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
      return newPath;
  } else {
    return nil;
  }
}

@end
