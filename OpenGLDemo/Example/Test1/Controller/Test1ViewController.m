//
//  Test1ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)customDraw {
    // 清理颜色缓存区
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 顶点数组
    GLfloat vVertices[] = {
        0.0f,0.5f,0.0f,
        -0.5f,-0.5f,0.0f,
        0.5f,-0.5f,0.0f
    };
    
    // 加载顶点数据
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    // 链接顶点数据到vPosition(输入属性位置0)
    glEnableVertexAttribArray(0);
    // 绘制顶点数组
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
