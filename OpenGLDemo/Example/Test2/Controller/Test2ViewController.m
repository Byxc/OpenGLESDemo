//
//  Test2ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test2ViewController.h"

#import "NSObject+ESUtil.h"

@interface Test2ViewController ()

@property (nonatomic, assign) GLfloat elapsedTime;

@end

@implementation Test2ViewController

- (void)customDraw {    
    // 清理颜色缓存区
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 顶点颜色数据
    GLfloat color[] = {
        1.0f,0.0f,0.0f,1.0f,
        0.0f,1.0f,0.0f,1.0f,
        0.0f,0.0f,1.0f,1.0f
    };
    
    // 顶点数组
    GLfloat vVertices[] = {
        0.0f,0.5f,0.0f,
        -0.5f,-0.5f,0.0f,
        0.5f,-0.5f,0.0f
    };
    
    // 加载顶点颜色数据
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, color);
    // 加载顶点数据
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    // 启用通用顶点属性数组
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    
    // 设置elapsedTime
    GLuint elapsedTime = glGetAttribLocation(self.programObject, "elapsedTime");
    _elapsedTime += 0.01;
    glVertexAttrib1f(elapsedTime, _elapsedTime);
    
    // 绘制顶点数组
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
    // 禁用通用顶点属性数组
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
}

@end
