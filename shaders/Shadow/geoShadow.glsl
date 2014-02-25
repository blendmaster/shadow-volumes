#version 330

layout (triangles_adjacency) in;
layout (triangle_strip, max_vertices = 12) out;

uniform mat4 P;
uniform vec3 lloc;
in vec3 _wcoord[6];
in vec3 _wnormal[6];

void EmitEdge(vec3 a, vec3 b)
{
    vec3 l = lloc;
    // terminology from project description
    vec4 a4 = vec4(a, 1);
    vec4 b4 = vec4(b, 1);
    vec4 ap = vec4(a - l, 0);
    vec4 bp = vec4(b - l, 0);

    gl_Position = P * b4; EmitVertex();
    gl_Position = P * a4; EmitVertex();
    gl_Position = P * bp; EmitVertex();
    gl_Position = P * ap; EmitVertex();

    EndPrimitive();
}

bool front_facing(vec3 a, vec3 b, vec3 c) {
    vec3 ldir = c - lloc;
    vec3 n = cross(a-b, a-c);
    return dot(ldir, n) < 0;
}

// a --- b
//  \ 0 / \
//   \ / 1 \
//    c-----d
bool silhouette(vec3 a, vec3 b, vec3 c, vec3 d) {
  return front_facing(a, b, c) ^^ front_facing(d, c, b);
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
        if (silhouette(v1, v0, v2, v4)) EmitEdge(v0, v2);
        if (silhouette(v3, v2, v4, v0)) EmitEdge(v2, v4);
        if (silhouette(v5, v4, v0, v2)) EmitEdge(v4, v0);
    }
}
