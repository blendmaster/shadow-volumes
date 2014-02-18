#version 330

// we are ignoring the normal vector here: it will be computed in
// the geometry shader

layout(location=0) in vec3 coord;  

// the only uniform needed is the modelview matrix

uniform mat4 MV; 

// .. and the only output is location in the world coordinates.

out vec3 _wcoord;

void main()
{
    // transform locations to world coordinates
    // and put the results into the output variables

    vec4 wcoord = MV*vec4(coord,1.0);
    _wcoord = wcoord.xyz;

    // since we have geometry shader before rasterization, we can
    // let it write into gl_Position - no need to do this here
} 
