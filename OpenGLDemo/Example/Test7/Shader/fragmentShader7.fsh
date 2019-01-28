#version 300 es
precision mediump float;

in vec3 fNormal;

uniform vec3 lightDirection;
uniform mat4 normalMatrix;


out vec4 o_fragColor;

void main() {
    // 返回与lightDirection同向的单位向量
    vec3 normalizedLightDirection = normalize(-lightDirection);
    vec3 transformedNormal = normalize((normalMatrix * vec4(fNormal,1.0)).xyz);
    
    // 点乘
    float diffuseStrength = dot(normalizedLightDirection,transformedNormal);
    // 限值(0~1之间)
    diffuseStrength = clamp(diffuseStrength,0.0,1.0);
    // 漫反射强度
    vec3 diffuse = vec3(diffuseStrength);
    
    // 基本光照强度(防止场景太暗)
    vec3 ambient = vec3(0.3);
    
    // 最终光照强度
    vec4 finalLightStrength = vec4(ambient + diffuse,1.0);
    // 材质颜色
    vec4 materialColor = vec4(1.0, 0.5, 0.5, 1.0);
    
    o_fragColor = finalLightStrength * materialColor;
}
