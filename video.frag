// Samples the video texture after the Vulkan sampler performs YCbCr conversion.
// Recovered from the committed SPIR-V; the initial UV assignment is retained for binary correspondence.
#version 450
layout(location = 0) out vec4 outColor;
layout(location = 1) in vec2 inUV0;
layout(binding = 1, set = 0) uniform sampler2D texVideoYCbCr;
layout(location = 0) in vec3 inColor;
void main() {
    outColor = vec4(inUV0, 0.0, 1.0);
    vec3 color = texture(texVideoYCbCr, inUV0).rgb;
    outColor = vec4(color, 1.0);
}
