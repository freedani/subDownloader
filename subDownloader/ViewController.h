//
//  ViewController.h
//  subDownloader
//
//  Created by 李达 on 2016/11/27.
//  Copyright © 2016年 李达. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class mainModel;
@class mainView;

@protocol DragDropViewDelegate <NSObject>
//设置代理方法
-(void) doGetDragDropArrayFiles:(NSArray*) fileList;

@end

@interface ViewController : NSViewController <NSDraggingDestination,DragDropViewDelegate>

@property (nonatomic,strong) mainView *MainView;
@property (nonatomic,strong) mainModel *MainModel;

@end
