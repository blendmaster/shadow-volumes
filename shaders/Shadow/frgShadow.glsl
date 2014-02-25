#version 330

// final color

out vec4 fragcolor;

// input variables, matching the outputs of the vertex shader

noperspective in vec3 _wnormal2;
noperspective in vec3 _wcoord2;
flat in int isShadow;
// light/material data

uniform vec3 lloc;
uniform vec3 kd,ka,ks;
uniform float nspec;
uniform vec3 I,Ia;
uniform int reor;

void main() { 
    fragcolor = vec4(0,0,0, isShadow == 1 ? 0.1 : 0.5);
} 
