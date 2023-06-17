struct OffsetVector {
    offset_vector: vec2<f32>,
};
@group(2) @binding(0)
var<uniform> offset: OffsetVector;

// Vertex shader

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) tex_coords: vec2<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) tex_coords: vec2<f32>,
}
// var<private> offset: f32 = 0.25;
// var<private> direction: bool = true;

@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.tex_coords = model.tex_coords;
    out.clip_position = vec4<f32>(model.position, 1.0);
    return out;
}

// Fragment shader

@group(0)@binding(0)
var t_diffuse: texture_2d<f32>;
@group(0)@binding(1)
var s_diffuse: sampler;

@group(1)@binding(0)
var water_t_diffuse: texture_2d<f32>;
@group(1)@binding(1)
var water_s_diffuse: sampler;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let baseColor = textureSample(t_diffuse, s_diffuse, in.tex_coords);
    let waterColor = textureSample(water_t_diffuse, water_s_diffuse, in.tex_coords + offset.offset_vector);
    
    if in.tex_coords.y > 0.5 {
        return vec4(waterColor.rgb + baseColor.rbg, 1.0);
    } else {
        return vec4(baseColor.rgb, 1.0);
    }
}