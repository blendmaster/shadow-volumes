#version 330

layout (triangles_adjacency) in;
layout (triangle_strip, max_vertices = 4) out;

uniform mat4 P;
uniform vec3 lloc;
in vec3 _wcoord[6];
in vec3 _wnormal[6];

noperspective out vec3 _wcoord2;
noperspective out vec3 _wnormal2;
flat out int isShadow;

void EmitEdge(vec3 a, vec3 b)
{
    vec3 l = vec3(1,2, -5);
    // terminology from project description
    vec4 a4 = vec4(a, 1);
    vec4 b4 = vec4(b, 1);
    vec4 ap = vec4(a - l, 1);
    vec4 bp = vec4(b - l, 1);

    isShadow = 1;
    gl_Position = P * b4; EmitVertex();
    gl_Position = P * a4; EmitVertex();
    gl_Position = P * bp; EmitVertex();
    gl_Position = P * ap; EmitVertex();
    
    EndPrimitive();
}

bool front_facing(vec3 a, vec3 b, vec3 c) {
  return 0 < (a.x * b.y - b.x * a.y) + (b.x * c.y - c.x * b.y) + (c.x * a.y - a.x * c.y);
}

void Emit(int i) {
  _wnormal2 = _wnormal[i];
  _wcoord2 = _wcoord[i];
  gl_Position = P*vec4(_wcoord[i],1);
  EmitVertex();
}

void main()
{
    vec3 v0 = _wcoord[0];
    vec3 v1 = _wcoord[1];
    vec3 v2 = _wcoord[2];
    vec3 v3 = _wcoord[3];
    vec3 v4 = _wcoord[4];
    vec3 v5 = _wcoord[5];

    if (front_facing(v0, v2, v4)) {
        if (!front_facing(v0, v1, v2)) EmitEdge(v0, v2);
        if (!front_facing(v2, v3, v4)) EmitEdge(v2, v4);
        if (!front_facing(v0, v4, v5)) EmitEdge(v4, v0);
    }
}
