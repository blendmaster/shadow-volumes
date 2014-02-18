#version 330

layout(location=0) in vec3 coord;  

uniform mat4 MV; 

out vec3 _wcoord;

void main()
{
    // transform locations and normals to world coordinates
    // and put the results into the output variables

    vec4 wcoord = MV*vec4(coord,1.0);
    _wcoord = wcoord.xyz;
} 
