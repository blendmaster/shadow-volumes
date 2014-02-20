#version 330

layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;

uniform mat4 P;
in vec3 _wcoord[3];
in vec3 _wnormal[3];

noperspective out vec3 _wcoord2;
noperspective out vec3 _wnormal2;

void main()
{
    // passthrough
    for ( int i=0; i<3; i++ )
    {
      _wnormal2 = _wnormal[i];
      _wcoord2 = _wcoord[i];
      gl_Position = P*vec4(_wcoord[i],1);
      EmitVertex();
    }

    EndPrimitive();
}
