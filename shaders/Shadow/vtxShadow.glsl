#version 330

layout(location=0) in vec3 coord;  
layout(location=1) in vec3 normal; 

uniform mat4 MV; 
uniform mat4 P; 
uniform mat3 NM;

out vec3 _wcoord;
out vec3 _wnormal;

void main()
{
    vec4 wcoord = MV*vec4(coord,1.0);
    _wcoord = wcoord.xyz;
    _wnormal = normalize(NM*normal);
} 
