//
//  Test5ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test5ViewController.h"

#import "NSObject+ESUtil.h"

@interface Test5ViewController ()

/// 时间变量
@property (nonatomic, assign) GLfloat elapsedTime;

/// 投影矩阵
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
/// 观察矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;
/// 模型矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix1;
@property (nonatomic, assign) GLKMatrix4 modelMatrix2;

@end

@implementation Test5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载矩阵
    [self loadMatrix];
}

- (void)loadMatrix {
    // 宽高比
    float aspect = CGRectGetWidth(self.view.frame)/CGRectGetHeight(self.view.frame);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100.0);
    
    // 设置摄像机坐标为:0,0,2  看向 0,0,0点 Y轴正向为摄像机顶部指向的方向
    _cameraMatrix = GLKMatrix4MakeLookAt(0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    // 初始化模型矩阵
    _modelMatrix1 = GLKMatrix4Identity;
    _modelMatrix2 = GLKMatrix4Identity;
}

- (void)customDraw {
    
    // 清理颜色缓存区
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 顶点颜色数据
    GLfloat color[] = {
        1.0f,0.0f,0.0f,1.0f,
        0.0f,1.0f,0.0f,1.0f,
        0.0f,0.0f,1.0f,1.0f,
        0.0f,0.0f,1.0f,1.0f,
        0.0f,1.0f,0.0f,1.0f,
        1.0f,0.0f,0.0f,1.0f
    };
    
    // 顶点数组
    GLfloat vVertices[] = {
        -0.5f,0.5f,0.0f,
        -0.5f,-0.5f,0.0f,
        0.5f,-0.5f,0.0f,
        0.5f,-0.5f,0.0f,
        0.5f,0.5f,0.0f,
        -0.5f,0.5f,0.0f
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
    float varyingFactor = (sin(_elapsedTime) + 1)*0.5; // 0 ~ 1
    
    _cameraMatrix = GLKMatrix4MakeLookAt(0.0, 0.0, 2.0*(varyingFactor + 1.0), 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    GLKMatrix4 translateMatrix1 = GLKMatrix4MakeTranslation(-0.7, 0.0, 0.0);
    GLKMatrix4 roateMatrix1 = GLKMatrix4MakeRotation(varyingFactor * M_PI *2 , 0.0, 1.0, 0.0);
    _modelMatrix1 = GLKMatrix4Multiply(translateMatrix1, roateMatrix1);
    
    GLKMatrix4 translateMatrix2 = GLKMatrix4MakeTranslation(0.7, 0.0, 0.0);
    GLKMatrix4 roateMatrix2 = GLKMatrix4MakeRotation(varyingFactor * M_PI , 0.0, 0.0, 1.0);
    _modelMatrix2 = GLKMatrix4Multiply(translateMatrix2, roateMatrix2);
    
    // 赋值
    GLuint projectionMatrixLocation = glGetUniformLocation(self.programObject, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixLocation, 1, 0, _projectionMatrix.m);
    
    GLuint cameraMatrixLocation = glGetUniformLocation(self.programObject, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixLocation, 1, 0, _cameraMatrix.m);
    
    GLuint modelMatrixLotion = glGetUniformLocation(self.programObject, "modelMatrix");
    // 绘制第一个矩形
    glUniformMatrix4fv(modelMatrixLotion, 1, 0, _modelMatrix1.m);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    // 绘制第二个矩形
    glUniformMatrix4fv(modelMatrixLotion, 1, 0, _modelMatrix2.m);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    // 禁用通用顶点属性数组
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
}

@end
