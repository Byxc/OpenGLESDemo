//
//  NSObject+ESUtil.h
//  test2
//
//  Created by fuyoufang on 2017/9/5.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>

@interface NSObject (ESUtil)

#pragma mark - Shader
/**
 Create a shader object, load the shader source with file, and compile the shader

 @param type Type
 @param fileName FileName
 @param bundle Bundle
 @return Shader
 */
- (GLuint)loadShaderWithType:(GLenum)type fileName:(NSString *)fileName bundle:(NSBundle *)bundle;

/**
 Create a shader object, load the shader source, and compile the shader
 
 @param type Type
 @param shaderSrc Shader Source
 @return Shader
 */
- (GLuint)loadShaderWithType:(GLenum)type source:(const char *)shaderSrc;

#pragma mark - Texture
/**
 Create texture

 @param name texture file name
 @param bundle Bundle
 @return texture
 */
- (GLuint)loadTextureWithFileName:(NSString *)name bundle:(NSBundle *)bundle;

@end
