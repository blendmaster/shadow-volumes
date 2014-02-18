#version 330


// See the geoFlat shader for explanation of the technicalities.

layout (triangles) in;
layout (triangle_strip, max_vertices = 6) out;

uniform mat4 P;
//uniform int reor;

in vec3 _wcoord[3];
in vec3 _wnormal[3];

noperspective out vec3 _wnormal2;
noperspective out vec3 _wcoord2;

// this will allow us to distinguish the original and the 
// symmetric copy and use a different color for each

flat out int which;

void main()
{

  // send the original triangle first...

  for ( int i=0; i<3; ++i )
  {
    which = 0;
    _wnormal2 = _wnormal[i];
    _wcoord2 = _wcoord[i];
    gl_Position = P*vec4(_wcoord[i],1);
    EmitVertex();
  }
  EndPrimitive();

  // .. and the symmetric image (about y=0)
  // note that we reverse the orientation here since a planar symmetry
  // reverses it.

  for ( int i=2; i>=0; --i )
  {
    which = 1;
    _wnormal2 = vec3(1,-1,1) * _wnormal[i];
    vec3 wcoordsym = vec3(1,-1,1) * _wcoord[i];
    _wcoord2 = wcoordsym;
    gl_Position = P*vec4(wcoordsym,1);
    EmitVertex();
  }
  EndPrimitive();

}
