//
//  ViewController.m
//  subDownloader
//
//  Created by 李达 on 2016/11/27.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "ViewController.h"
#import "mainView.h"
#import "mainModel.h"

//@interface ViewController() <DragDropViewDelegate>
//
//@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Do any additional setup after loading the view.
}

-(void) initUI {
    _MainView = [[mainView alloc] initWithFrame:self.view.frame];
    self.MainView.delegate = self;
    [self.view addSubview:_MainView];
    _MainModel = [[mainModel alloc]init];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

-(void)doGetDragDropArrayFiles:(NSArray *)fileList{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)
        return;
    for (int n = 0 ; n < [fileList count] ; n++) {
        NSString *path = [fileList objectAtIndex:n];
        [_MainModel sentRequestWithFilePath:path];
    }

    
}

@end
