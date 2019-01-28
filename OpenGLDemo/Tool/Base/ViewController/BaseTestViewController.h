//
//  BaseTestViewController.h
//  OpenGLDemo
//
//  Created by 白云 on 2018/8/9.
//  Copyright © 2018年 白云. All rights reserved.
//

#import <GLKit/GLKit.h>

#import "NSObject+ESUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTestViewController : GLKViewController

#pragma mark - Property
/// 上下文
@property (nonatomic, strong) EAGLContext *context;
/// 程序句柄
@property (nonatomic, assign) GLuint programObject;
/// 默认的顶点着色器文件名
@property (nonatomic, copy) NSString *vertexShaderFileName;
/// 默认的片段着色器文件名
@property (nonatomic, copy) NSString *fragmentShaderFileName;

#pragma mark - Method
#pragma mark - Config
/**
 初始化上下文
 */
- (void)setupContext;

/**
 加载Shader
 */
- (void)loadShader;

#pragma mark - Draw
/**
 自定义绘制
 */
- (void)customDraw;

@end

NS_ASSUME_NONNULL_END
