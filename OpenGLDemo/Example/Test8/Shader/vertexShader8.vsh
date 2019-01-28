#version 300 es

layout(location = 0) in vec3 normal; // 法线向量
layout(location = 1) in vec4 a_position;
layout(location = 2) in vec2 uv; // 纹理坐标

uniform mat4 projectionMatrix; // 投影矩阵
uniform mat4 cameraMatrix; // 观察矩阵
uniform mat4 modelMatrix; // 模型矩阵

out vec3 fNormal;
out vec2 f_uv;

void main() {
    fNormal = normal;
    f_uv = uv;
    // 投影 * 观察 * 模型
    mat4 mvp = projectionMatrix * cameraMatrix * modelMatrix;
    gl_Position = mvp * a_position;
}


