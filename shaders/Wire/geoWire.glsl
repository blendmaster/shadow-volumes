#version 330


layout (triangles) in;
layout (triangle_strip, max_vertices = 8) out;

uniform mat4 P;
uniform vec3 lloc;
uniform vec3 kd,ka,ks;
uniform float nspec;
uniform vec3 I,Ia;
uniform int reor;

in vec3 _wcoord[3];

flat out vec3 _fragcolor;

const float width = 0.25;

void main()
{
    vec3 N = reor*normalize(cross(_wcoord[1]-_wcoord[0],_wcoord[2]-_wcoord[0]));
    vec3 barycenter = (_wcoord[0]+_wcoord[1]+_wcoord[2])/3;
    vec3 L = normalize(lloc-barycenter);
    vec3 V = -normalize(barycenter);
    vec3 H = normalize(L+V);

    float NdotL = dot(N,L);
    float HdotN = dot(H,N);
    if (NdotL<0) NdotL = 0.0;
    if (HdotN<0) HdotN = 0.0;

    vec3 color = ka*Ia + (kd*NdotL + ks*pow(HdotN,nspec))*I;

    // note that 4 iterations are used here since we want to close the tri-strip
    // that follows the boundary of the triangle - to do that, we repeat the
    // first two vertices at the end

    for ( int i=0; i<4; i++ )
    {
      // vertex #(i mod 3) moved toward the center of the triangle...
      _fragcolor = color;
      gl_Position = P*vec4(_wcoord[i%3]+width*(barycenter-_wcoord[i%3]),1);
      EmitVertex();

      // ... and the original vertex 
      _fragcolor = color;
      gl_Position = P*vec4(_wcoord[i%3],1);
      EmitVertex();
    }
    EndPrimitive();
}
