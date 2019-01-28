//
//  Test4ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test4ViewController.h"

#import "NSObject+ESUtil.h"

@interface Test4ViewController ()

@property (nonatomic, assign) GLfloat elapsedTime;

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, assign) BOOL isPerspective;

@end

@implementation Test4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航按钮
    [self setNavigationButton];
}

- (void)setNavigationButton {
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchButton setTitle:@"正交投影" forState:UIControlStateNormal];
    [_switchButton setTitle:@"透视投影" forState:UIControlStateSelected];
    [_switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _switchButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_switchButton addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_switchButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    _elapsedTime = 0;
}

- (void)switchAction {
    _isPerspective = !_isPerspective;
    _switchButton.selected = _isPerspective;
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
    float varyingFactor = _elapsedTime;
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor, 0.0, 1.0, 0.0);
    
    // transformMatrix = translateMatrix * rotateMatrix * scaleMatrix
    // 缩放->旋转->平移
    GLKMatrix4 transformMatrix;
    if (_isPerspective) {
        // 透视投影
        float aspect = CGRectGetWidth(self.view.frame)/CGRectGetHeight(self.view.frame);
        /* 参数
         float fovyRadians 视角
         float aspect 屏幕宽高比
         float nearZ 可视范围在z轴的起点到原点(0,0,0)的距离 (正数)
         float farZ 可视范围在z轴的终点到原点(0,0,0)的距离 (正数)
         */
        GLKMatrix4 perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 10.0);
        GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(0, 0, -1.6);
        
        transformMatrix = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
        transformMatrix = GLKMatrix4Multiply(perspectiveMatrix, transformMatrix);
    }
    else {
        // 正交投影
        float viewWidth = CGRectGetWidth(self.view.frame);
        float viewHeight = CGRectGetHeight(self.view.frame);
        
        GLKMatrix4 orthMatrix = GLKMatrix4MakeOrtho(-viewWidth*0.5,viewWidth*0.5,-viewHeight*0.5,viewHeight*0.5,-10.0,10.0);
        
        GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(200.0, 200.0, 200.0);
        
        transformMatrix = GLKMatrix4Multiply(rotateMatrix, scaleMatrix);
        transformMatrix = GLKMatrix4Multiply(orthMatrix, transformMatrix);
    }
    
    GLuint transformUniformLocation = glGetUniformLocation(self.programObject, "transform");
    glUniformMatrix4fv(transformUniformLocation, 1, 0, transformMatrix.m);
    
    // 绘制顶点数组
    glDrawArrays(GL_TRIANGLES, 0, 6);
    // 禁用通用顶点属性数组
    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
}

@end
