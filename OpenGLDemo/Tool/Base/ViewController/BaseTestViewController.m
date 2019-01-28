//
//  BaseTestViewController.m
//  OpenGLDemo
//
//  Created by 白云 on 2018/8/9.
//  Copyright © 2018年 白云. All rights reserved.
//

#import "BaseTestViewController.h"

@interface BaseTestViewController ()

@property (nonatomic, assign) GLuint fsh;
@property (nonatomic, assign) GLuint vsh;

@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置上下文
    [self setupContext];
    // 加载shader
    [self loadShader];
}

#pragma mark - Config
- (void)setupContext {
    // 初始化上下文并设定Api版本
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_context) {
        NSLog(@"Failed create context");
    }
    GLKView *view = (GLKView *)self.view;
    view.context = _context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:_context];
}

- (void)loadShader {
    NSString *itemName = [NSStringFromClass(self.class) stringByReplacingOccurrencesOfString:@"Test" withString:@""];
    NSString *indexString = [itemName stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
    _vertexShaderFileName = [NSString stringWithFormat:@"vertexShader%@.vsh",indexString];
    _fragmentShaderFileName = [NSString stringWithFormat:@"fragmentShader%@.fsh",indexString];
    
    // 如果shader已加载，先移除原有的shader
    if (_vsh) {
        glDeleteShader(_vsh);
        _vsh = 0;
    }
    
    if (_fsh) {
        glDeleteShader(_fsh);
        _fsh = 0;
    }
    
    // 加载并编译顶点着色器
    _vsh = [self loadShaderWithType:GL_VERTEX_SHADER fileName:_vertexShaderFileName bundle:nil];
    // 加载并编译片段着色器
    _fsh = [self loadShaderWithType:GL_FRAGMENT_SHADER fileName:_fragmentShaderFileName bundle:nil];
    
    // 创建程序对象
    _programObject = glCreateProgram();
    
    if (_programObject == 0) {
        NSLog(@"Failed create program");
    }
    
    // 链接着色器
    glAttachShader(_programObject, _vsh);
    glAttachShader(_programObject, _fsh);
    
    // 链接程序对象
    glLinkProgram(_programObject);
    
    // 检查链接状态
    GLint linked;
    glGetProgramiv(_programObject, GL_LINK_STATUS, &linked);
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(_programObject, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(_programObject, infoLen, NULL, infoLog);
            NSLog(@"%s",infoLog);
            free(infoLog);
        }
        glDeleteProgram(_programObject);
        return;
    }
    
    // 校验程序对象，校验结果使用GL_VALIDATE_STATUS检查，信息日志将会更新，速度比较慢，用于调试
    // glValidateProgram(_programObject)
    
    // 绑定程序对象
    glUseProgram(_programObject);
}

#pragma mark - Draw
- (void)customDraw {
    // 设置视图端口
    //    glViewport(0, 0, CGRectGetWidth(self.view.bounds)*2, CGRectGetHeight(self.view.bounds)*2);
    
    // 清理颜色缓存区
    //    glClear(GL_COLOR_BUFFER_BIT);

}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self customDraw];
}

@end
