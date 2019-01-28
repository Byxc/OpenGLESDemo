//
//  Test9ViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/7/25.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "Test9ViewController.h"

#import "NSObject+ESUtil.h"

@interface Test9ViewController ()

/// 时间变量
@property (nonatomic, assign) GLfloat elapsedTime;

@property (nonatomic, strong) UIButton *switchButton;

/// 投影矩阵
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
/// 观察矩阵
@property (nonatomic, assign) GLKMatrix4 cameraMatrix;
/// 模型矩阵
@property (nonatomic, assign) GLKMatrix4 modelMatrix;

/// 平行光方向
@property (nonatomic, assign) GLKVector3 lightDirection;

/// 纹理
@property (nonatomic, assign) GLuint diffuseTexture;

/// 顶点缓冲区对象
@property (nonatomic, assign) GLuint vbo;
/// 顶点数组对象
@property (nonatomic, assign) GLuint vao;

@end

@implementation Test9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationButton];
    
    // 配置VBO
    [self configVBO];
    // 加载矩阵
    [self loadMatrix];
    // 加载纹理
    [self loadTexture];
}

- (void)setNavigationButton {
    _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_switchButton setTitle:@"VBO" forState:UIControlStateNormal];
    [_switchButton setTitle:@"VAO" forState:UIControlStateSelected];
    [_switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _switchButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_switchButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    _elapsedTime = 0;
}

- (void)switchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _elapsedTime = 0;
    if (sender.selected) {
        [self configVBO];
        [self configVAO];
    }
    else {
        [self configVBO];
        glDeleteVertexArrays(1, &_vao);
        _vao = 0;
    }
}

- (void)configVBO {
    if (_vbo) {
        glDeleteBuffers(1, &_vbo);
        _vbo = 0;
    }
    // 生成buffer
    glGenBuffers(1, &_vbo);
    // 绑定buffer
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    // 写入数据
    glBufferData(GL_ARRAY_BUFFER, 36*8*sizeof(GLfloat), [self vertixData], GL_STATIC_DRAW);
}

- (void)configVAO {
    if (_vao) {
        glDeleteVertexArrays(1, &_vao);
        _vao = 0;
    }
    // 生成顶点数组对象
    glGenVertexArrays(1, &_vao);
    // 绑定顶点数组对象
    glBindVertexArray(_vao);
    
    // 绑定VBO
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    // 绑定数据
    [self bindVertexAttri:NULL];
    
    // 重置为默认VAO
    glBindVertexArray(0);
}

- (void)loadMatrix {
    // 宽高比
    float aspect = CGRectGetWidth(self.view.frame)/CGRectGetHeight(self.view.frame);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100.0);
    
    // 设置摄像机坐标为:0,0,2  看向 0,0,0点 Y轴正向为摄像机顶部指向的方向
    _cameraMatrix = GLKMatrix4MakeLookAt(0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    
    // 初始化模型矩阵
    _modelMatrix = GLKMatrix4Identity;
    
    // 设置平行光方向
    self.lightDirection = GLKVector3Make(0.0, -1.0, 0.0);
}

- (void)loadTexture {
    _diffuseTexture = [self loadTextureWithFileName:@"test8Texture.jpg" bundle:nil];
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
    
    bool canInvert;
    // 计算逆转矩阵
    GLKMatrix4 normalMatrix = GLKMatrix4InvertAndTranspose(_modelMatrix, &canInvert);
    if (canInvert) {
        GLuint normalMatrixLocation = glGetUniformLocation(self.programObject, "normalMatrix");
        glUniformMatrix4fv(normalMatrixLocation, 1, 0, normalMatrix.m);
    }
    
    GLuint lightDirectionLocation = glGetUniformLocation(self.programObject, "lightDirection");
    glUniform3fv(lightDirectionLocation, 1, self.lightDirection.v);
}

- (void)bindVertexAttri:(GLfloat *)vertixData {
    // 启用通用顶点属性数组
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);
    // 加载顶点数据
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, (char *)vertixData);
    // 加载顶点颜色数据
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, (char *)vertixData+3*sizeof(GLfloat));
    // 加载纹理坐标
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, (char *)vertixData+6*sizeof(GLfloat));
}

- (void)bindTexture{
    
    GLuint diffuseMapLocation = glGetUniformLocation(self.programObject, "diffuseMap");
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _diffuseTexture);
    glUniform1i(diffuseMapLocation, 0);
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
    // 绑定纹理
    [self bindTexture];
    
    if (self.switchButton.selected) {
        glBindVertexArray(_vao);
        glDrawArrays(GL_TRIANGLES, 0, 36);
        // 重置为默认VAO
        glBindVertexArray(0);
    }
    else {
        [self bindVertexAttri:NULL];
        glDrawArrays(GL_TRIANGLES, 0, 36);
    }
}

#pragma mark - Getter
- (GLfloat *)vertixData {
    // 顶点
    static GLfloat vVertices[] = {
        0.5,  -0.5,    0.5f, 1,  0,  0, 0, 0,
        0.5,  -0.5f,  -0.5f, 1,  0,  0, 0, 1,
        0.5,  0.5f,   -0.5f, 1,  0,  0, 1, 1,
        0.5,  0.5,    -0.5f, 1,  0,  0, 1, 1,
        0.5,  0.5f,    0.5f, 1,  0,  0, 1, 0,
        0.5,  -0.5f,   0.5f, 1,  0,  0, 0, 0,
        
        -0.5,  -0.5,    0.5f, -1,  0,  0, 0, 0,
        -0.5,  -0.5f,  -0.5f, -1,  0,  0, 0, 1,
        -0.5,  0.5f,   -0.5f, -1,  0,  0, 1, 1,
        -0.5,  0.5,    -0.5f, -1,  0,  0, 1, 1,
        -0.5,  0.5f,    0.5f, -1,  0,  0, 1, 0,
        -0.5,  -0.5f,   0.5f, -1,  0,  0, 0, 0,
        
        -0.5,  0.5,  0.5f, 0,  1,  0, 0, 0,
        -0.5f, 0.5, -0.5f, 0,  1,  0, 0, 1,
        0.5f, 0.5,  -0.5f, 0,  1,  0, 1, 1,
        0.5,  0.5,  -0.5f, 0,  1,  0, 1, 1,
        0.5f, 0.5,   0.5f, 0,  1,  0, 1, 0,
        -0.5f, 0.5,  0.5f, 0,  1,  0, 0, 0,
        
        -0.5, -0.5,   0.5f, 0,  -1,  0, 0, 0,
        -0.5f, -0.5, -0.5f, 0,  -1,  0, 0, 1,
        0.5f, -0.5,  -0.5f, 0,  -1,  0, 1, 1,
        0.5,  -0.5,  -0.5f, 0,  -1,  0, 1, 1,
        0.5f, -0.5,   0.5f, 0,  -1,  0, 1, 0,
        -0.5f, -0.5,  0.5f, 0,  -1,  0, 0, 0,
        
        -0.5,   0.5f,  0.5,   0,  0,  1, 0, 0,
        -0.5f,  -0.5f,  0.5,  0,  0,  1, 0, 1,
        0.5f,   -0.5f,  0.5,  0,  0,  1, 1, 1,
        0.5,    -0.5f, 0.5,   0,  0,  1, 1, 1,
        0.5f,  0.5f,  0.5,    0,  0,  1, 1, 0,
        -0.5f,   0.5f,  0.5,  0,  0,  1, 0, 0,
        
        -0.5,   0.5f,  -0.5,   0,  0,  -1, 0, 0,
        -0.5f,  -0.5f,  -0.5,  0,  0,  -1, 0, 1,
        0.5f,   -0.5f,  -0.5,  0,  0,  -1, 1, 1,
        0.5,    -0.5f, -0.5,   0,  0,  -1, 1, 1,
        0.5f,  0.5f,  -0.5,    0,  0,  -1, 1, 0,
        -0.5f,   0.5f,  -0.5,  0,  0,  -1, 0, 0,
    };
    return vVertices;
}

@end
