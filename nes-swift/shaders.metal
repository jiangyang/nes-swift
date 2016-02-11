#include <metal_stdlib>

using namespace metal;

struct Vertex {
  float4 position [[position]];
  float2 texcoord;
};

vertex Vertex vertex_shader(constant Vertex *vertices [[buffer(0)]], uint vid [[vertex_id]]) {
  return vertices[vid];
}

fragment float4 fragment_shader(Vertex vert [[stage_in]],
                              texture2d<float> texture [[texture(0)]],
                              sampler samplr [[sampler(0)]]) {
  return  texture.sample(samplr, vert.texcoord);
}