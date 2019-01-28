#version 300 es

layout(location = 0) in vec4 a_color;
layout(location = 1) in vec4 a_position;
layout(location = 2) in float elapsedTime; // 时间输入

out vec4 v_color;
out float v_time;

void main() {
    v_color = a_color;
    v_time = elapsedTime;
//    gl_Position = a_position;
    // 位置计算
    float angle = elapsedTime*1.0;
    float xPos = a_position.x*cos(angle) - a_position.y*sin(angle);
    float yPos = a_position.x*sin(angle) + a_position.y*cos(angle);
    gl_Position = vec4(xPos,yPos,a_position.z,1.0);
}


