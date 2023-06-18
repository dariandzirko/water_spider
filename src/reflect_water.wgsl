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

// const flip_y = vec2<f32>(1.0,-1.0);
// const flip_y_part2 = vec2<f32>(0.0,1.0);
const flip_y = vec2<f32>(1.0,-2.23);
const flip_y_part2 = vec2<f32>(0.0,2.23);

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {

    let baseColor = textureSample(t_diffuse, s_diffuse, in.tex_coords);
    let waterColor = textureSample(water_t_diffuse, water_s_diffuse, in.tex_coords + offset.offset_vector);
    
    // let inverse_y = in.tex_coords.y*(-1.0) + 1.0;
    let water_offset_y = waterColor.g*0.01;
    //let reflect_y_coord = inverse_y + water_offset_y;
    
    // let offset_reflection_base = textureSample(t_diffuse, s_diffuse,(in.tex_coords*(-1.0)) + 1.0); // this works?
    // let offset_reflection_base = textureSample(t_diffuse, s_diffuse,(1.0 - in.tex_coords); // this does not work?
    // let offset_reflection_base = textureSample(t_diffuse, s_diffuse,(in.tex_coords*(1.0,-1.0) + (0.0,1.0))); //this does not work -_-
    let offset_reflection_base = textureSample(t_diffuse, s_diffuse,(in.tex_coords*flip_y + flip_y_part2)+waterColor.rg*0.01); //this works? but I need the constants defined outside the function

    if in.tex_coords.y > 0.69 {
        return vec4(offset_reflection_base);
    } else {
        return vec4(baseColor);
    }
}