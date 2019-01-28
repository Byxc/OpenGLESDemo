#version 300 es
precision mediump float;

in vec4 v_color;
in float v_time;

out vec4 o_fragColor;

void main() {
    o_fragColor = v_color;
    // 颜色计算
    //    float uvs = mod(v_color.s*10.0+cos(v_time),2.0);
    //    float uvt = mod(v_color.t*10.0+sin(v_time),2.0);
    //    o_fragColor = vec4(uvs,uvt,0.6,1.0);
}

