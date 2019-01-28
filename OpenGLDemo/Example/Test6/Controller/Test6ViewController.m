//
//  Test6ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test6ViewController.h"

#import "NSObject+ESUtil.h"

@interface Test6ViewController ()

/// 时间变量
@property (nonatomic, assign) GLfloat elapsedTime;

/// 投影矩阵
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
/// 观察矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;
/// 模型矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix;

@end

@implementation Test6ViewController

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
    _modelMatrix = GLKMatrix4Identity;
}

- (void)updateMatrix {
    // 计算矩阵变换
    float varyingFactor = (sin(_elapsedTime) + 1)*0.5; // 0 ~ 1
    
    _cameraMatrix = GLKMatrix4MakeLookAt(0.0, 0.0, 2.0*(varyingFactor + 1.0), 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    GLKMatrix4 roateMatrix = GLKMatrix4MakeRotation(varyingFactor * M_PI *2 , 1.0, 1.0, 1.0);
    _modelMatrix = roateMatrix;
    
    // 赋值
    GLuint projectionMatrixLocation = glGetUniformLocation(self.programObject, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixLocation, 1, 0, _projectionMatrix.m);
    
    GLuint cameraMatrixLocation = glGetUniformLocation(self.programObject, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixLocation, 1, 0, _cameraMatrix.m);
    
    GLuint modelMatrixLotion = glGetUniformLocation(self.programObject, "modelMatrix");
    glUniformMatrix4fv(modelMatrixLotion, 1, 0, _modelMatrix.m);
}

- (void)drawsquare {
    // 顶点
    GLfloat vVertices[] = {
        0.5,  -0.5,    0.5f, 1,  0,  0, 1,
        0.5,  -0.5f,  -0.5f, 1,  0,  0, 1,
        0.5,  0.5f,   -0.5f, 1,  0,  0, 1,
        0.5,  0.5,    -0.5f, 1,  0,  0, 1,
        0.5,  0.5f,    0.5f, 1,  0,  0, 1,
        0.5,  -0.5f,   0.5f, 1,  0,  0, 1,
        -0.5,  -0.5,    0.5f, 1,  0,  0, 1,
        -0.5,  -0.5f,  -0.5f, 1,  0,  0, 1,
        -0.5,  0.5f,   -0.5f, 1,  0,  0, 1,
        -0.5,  0.5,    -0.5f, 1,  0,  0, 1,
        -0.5,  0.5f,    0.5f, 1,  0,  0, 1,
        -0.5,  -0.5f,   0.5f, 1,  0,  0, 1,
        
        -0.5,  0.5,  0.5f, 0,  1,  0, 1,
        -0.5f, 0.5, -0.5f, 0,  1,  0, 1,
        0.5f, 0.5,  -0.5f, 0,  1,  0, 1,
        0.5,  0.5,  -0.5f, 0,  1,  0, 1,
        0.5f, 0.5,   0.5f, 0,  1,  0, 1,
        -0.5f, 0.5,  0.5f, 0,  1,  0, 1,
        -0.5, -0.5,   0.5f, 0,  1,  0, 1,
        -0.5f, -0.5, -0.5f, 0,  1,  0, 1,
        0.5f, -0.5,  -0.5f, 0,  1,  0, 1,
        0.5,  -0.5,  -0.5f, 0,  1,  0, 1,
        0.5f, -0.5,   0.5f, 0,  1,  0, 1,
        -0.5f, -0.5,  0.5f, 0,  1,  0, 1,
        
        -0.5,   0.5f,  0.5,   0,  0,  1, 1,
        -0.5f,  -0.5f,  0.5,  0,  0,  1, 1,
        0.5f,   -0.5f,  0.5,  0,  0,  1, 1,
        0.5,    -0.5f, 0.5,   0,  0,  1, 1,
        0.5f,  0.5f,  0.5,    0,  0,  1, 1,
        -0.5f,   0.5f,  0.5,  0,  0,  1, 1,
        -0.5,   0.5f,  -0.5,   0,  0,  1, 1,
        -0.5f,  -0.5f,  -0.5,  0,  0,  1, 1,
        0.5f,   -0.5f,  -0.5,  0,  0,  1, 1,
        0.5,    -0.5f, -0.5,   0,  0,  1, 1,
        0.5f,  0.5f,  -0.5,    0,  0,  1, 1,
        -0.5f,   0.5f,  -0.5,  0,  0,  1, 1,
    };
    
    // 启用通用顶点属性数组
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
//    // 加载顶点数据
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, (char *)vVertices);
    // 加载顶点颜色数据
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, (char *)vVertices+3*sizeof(GLfloat));
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
}

- (void)customDraw {
    // 启用深度测试
    glEnable(GL_DEPTH_TEST);
    
    // 清理颜色缓存区
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    // 设置elapsedTime
    _elapsedTime += 0.01;
    
    // 更新矩阵
    [self updateMatrix];
    // 绘制正方体
    [self drawsquare];
}

@end
