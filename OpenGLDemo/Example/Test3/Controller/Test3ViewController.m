//
//  Test3ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test3ViewController.h"

#import "NSObject+ESUtil.h"

@interface Test3ViewController ()

@property (nonatomic, assign) GLfloat elapsedTime;

@end

@implementation Test3ViewController

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
    _elapsedTime += 0.01;
    
    // 计算矩阵变换
    float varyingFactor = sin(_elapsedTime);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(varyingFactor, varyingFactor, 1.0);
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor, 0.0, 0.0, 1.0);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(varyingFactor, 0.0, 0.0);
    // transformMatrix = translateMatrix * rotateMatrix * scaleMatrix
    // 缩放->旋转->平移
    GLKMatrix4 transformMatrix = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
    transformMatrix = GLKMatrix4Multiply(transformMatrix, scaleMatrix);
    GLuint transformUniformLocation = glGetUniformLocation(self.programObject, "transform");
    glUniformMatrix4fv(transformUniformLocation, 1, 0, transformMatrix.m);
    
    // 绘制顶点数组
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
    // 禁用通用顶点属性数组
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
}

@end
