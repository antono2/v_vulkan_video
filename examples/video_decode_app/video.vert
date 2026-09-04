#version 450

layout(location = 0) out vec3 outColor;
layout(location = 1) out vec2 outUV;

layout(push_constant) uniform VideoTransform {
    vec4 uvRow0;
    vec4 uvRow1;
    vec4 positionScale;
} transform;

const vec2 positions[4] = vec2[](
    vec2(-1.0,  1.0),
    vec2( 1.0,  1.0),
    vec2(-1.0, -1.0),
    vec2( 1.0, -1.0)
);

const vec3 colors[4] = vec3[](
    vec3(1.0, 0.0, 0.0),
    vec3(0.0, 1.0, 0.0),
    vec3(0.0, 0.0, 1.0),
    vec3(0.0, 0.0, 0.0)
);

const vec2 texcoords[4] = vec2[](
    vec2(0.0, 1.0),
    vec2(1.0, 1.0),
    vec2(0.0, 0.0),
    vec2(1.0, 0.0)
);

void main() {
    vec2 baseUV = texcoords[gl_VertexIndex];
    outUV = vec2(
        dot(transform.uvRow0.xy, baseUV) + transform.uvRow0.z,
        dot(transform.uvRow1.xy, baseUV) + transform.uvRow1.z
    );
    outColor = colors[gl_VertexIndex];
    gl_Position = vec4(positions[gl_VertexIndex] * transform.positionScale.xy, 0.5, 1.0);
}
