#version 330

// inputs are the same as in the Gouraud shader

layout(location=0) in vec3 coord;  
layout(location=1) in vec3 normal; 

// we won't be evaluating the Phong's formula here,
// so all we need is the transformation matrices
// (we still need to do transformations!) 

uniform mat4 MV; 
uniform mat4 P; 
uniform mat3 NM;

// output world coordinates and normals (also transformed to 
//  world coordinates) - we need this info on the fragment 
//  processing stage to evaluate the Phong's formula

noperspective out vec3 _wcoord;
noperspective out vec3 _wnormal;

void main()
{
    // transform locations and normals to world coordinates
    // and put the results into the output variables

    vec4 wcoord = MV*vec4(coord,1.0);
    _wcoord = wcoord.xyz;
    _wnormal = normalize(NM*normal);

    // cf vtxGouraud.glsl

    gl_Position = P*wcoord;
} 
