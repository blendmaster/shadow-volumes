#version 330

// final color

out vec3 fragcolor;

// input variables, matching the outputs of the vertex shader

noperspective in vec3 _wnormal;
noperspective in vec3 _wcoord;

// light/material data

uniform vec3 lloc;
uniform vec3 kd,ka,ks;
uniform float nspec;
uniform vec3 I,Ia;
uniform int reor;

void main() { 

    // this is basically the same as code in vtxGouraud.glsl,
    // but we use interpolated values of coordinates/normals 
    // in the world coordinates

    vec3 N = reor*normalize(_wnormal);
    vec3 L = normalize(lloc-_wcoord);
    vec3 V = -normalize(_wcoord);
    vec3 H = normalize(L+V);

    float NdotL = dot(N,L);
    float HdotN = dot(H,N);

    if (NdotL<0) NdotL = 0.0;
    if (HdotN<0) HdotN = 0.0;

    fragcolor = ka*Ia + (kd*NdotL + ks*pow(HdotN,nspec))*I;
} 
