#version 300 es

layout(location = 0) in vec4 a_color;
layout(location = 1) in vec4 a_position;
uniform mat4 transform; // 变换矩阵

out vec4 v_color;

void main() {
    v_color = a_color;
    // 矩阵变换
    gl_Position = transform*a_position;
}




