<div align="center">

# Water Spider
---
</div>

This a Rust plus WebGPU based 2D water animation project all compiled to Web Assembly and can be viewed here <https://dariandzirko.github.io/water_spider/>!

## Details 
---

There are 2 sides to the code of the project, Rust and WebGPU Shading Language. The Rust code is doing the set up work and then keeping track of state. Rust starts this off by initializing the window. Then leveraging the wgpu crate to create and maintain all the structs needed for communicating to the shader language (WGSL), and handling the state of those previously mentioned structs and persistently changing data for the animation. The WGSL is shader language that Web GPU uses to express the buffer data to the GPU. All of this gets compiled to WASM from the link above on github pages.

### Images Used
---

<div align="center">


<p align="center">
  <img width="460" height="300" src="/src/Left_Environment_Water.png">
</p>

#### Background

<p align="center">
  <img src="/src/water_normal.png">
</p>

#### Texture

</div>

### What is the Animation Really

The animation is a function taking this background image with this texture picture and mixing them together with changes every time step. With more detail, the ripple effect in the animation is a pixel coordinate in the flipped region (bottom 30% of the background image) and offsetting it with an rgb (r for x and g for y) value from the texture image. All of which is scaled by a constant which determines the intensity of the ripple. The exact pixel that is chosen from the texture, to manipulate the reflected texture is determined by a offset vector that is maintained in rust. That offset vector is a counter (x and y counter) where I then take the sin of that counter value and normalize between 0 and 1. This just leads to a periodic time dependent counter which will just make the animation repeat, every so often. Wrapping this all up there is a counter repeating between 0 and 1, that influences the selection of pixel value who's r and g channel will change the selected pixel value to display. It is just fancy circle that makes displaying ripples in the pixelated simple.
