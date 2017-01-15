//
//  mainView.m
//  subDownloader
//
//  Created by 李达 on 2016/12/21.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "mainView.h"
#import "ViewController.h"

@interface mainView ()

@end

@implementation mainView
@synthesize delegate = _delegate;

- (id) initWithController:(ViewController*) controller {
    self = [self initWithFrame:self.frame];
    return self;
}

- (id) initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
//    NSLog(@"init");
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    return self;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    NSPasteboard *pboard = [sender draggingPasteboard];
//    NSLog(@"draggingEntered");
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
//        NSLog(@"draggingEntered accept");
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    // 1）、获取拖动数据中的粘贴板
//    NSLog(@"prepareForDragOperation");
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    // 2）、从粘贴板中提取我们想要的NSFilenamesPboardType数据，这里获取到的是一个文件链接的数组，里面保存的是所有拖动进来的文件地址，如果你只想处理一个文件，那么只需要从数组中提取一个路径就可以了。
    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    // 3）、将接受到的文件链接数组通过代理传送
    if(self.delegate && [self.delegate respondsToSelector:@selector(doGetDragDropArrayFiles:)]) {
        [self.delegate doGetDragDropArrayFiles:list];
    }
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
