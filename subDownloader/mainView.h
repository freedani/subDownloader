//
//  mainView.h
//  subDownloader
//
//  Created by 李达 on 2016/12/21.
//  Copyright © 2016年 李达. All rights reserved.
//

#ifndef _MAINVIEW_H
#define _MAINVIEW_H


#import <Cocoa/Cocoa.h>
//#import "ViewController.h"

@protocol DragDropViewDelegate;

@interface mainView : NSView

@property(nonatomic, assign) id<DragDropViewDelegate> delegate;

- (id) initWithFrame:(NSRect)frameRect;

@end

#endif
