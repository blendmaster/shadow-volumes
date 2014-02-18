#version 330

// Specify the input and output primitive types.
// Here, we say the shader takes a triangle as input.
// Note that if you are rendering triangle strips in the
// C code, the strip(s) will be broken into individual 
// triangles which will then be presented into this 
// shader.
// The output prmitive is triangle strip here. The shader
// can output multiple strips; they need to be separated
// with EndPrimitive(). We also need to declare the maximum
// number of vertices that the shader can output. Here, it's
// three: we'll basically output a single-triangle triangle
// strip

layout (triangles) in;
layout (triangle_strip, max_vertices = 3) out;

// We'll do world->screen transformation and illumination
// in this shader - hence these uniforms will be needed.

uniform mat4 P;
uniform vec3 lloc;
uniform vec3 kd,ka,ks;
uniform float nspec;
uniform vec3 I,Ia;
uniform int reor;

// Input variables: world coordinates of the vertices of 
// a triangle. The values are output by the vertex shader.
// They are assembled into an array of size 3 since the
// input is a triangle. Note that when using triangle with
// adjacency, the size of the array changes to 6.

in vec3 _wcoord[3];

// We'll just send the fragment color with each vertex
// of the output primitive.
// Notice the output is NOT an array. 
// Also, notice that interpolation qualifiers for the 
// output variables of the geometry shaders are what
// takes effect in the rasterization stage (since geometry
// shader is the last programmable stage before rasterization)

flat out vec3 _fragcolor;

// In the main() function:
//  (1) Write values to gl_Position and all output variables
//  (2) When done, call EmitVertex() to send a vertex out
//  (3) If you want to end a primitive (e.g. start another
//     triangle strip), call EndPrimitive()
//  (4) If not done, go to (1) 

void main()
{

    // first, do familiar illumination calculations....

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

    // Output 3 vertices; assign the value to the output variable(s) - 
    // here, gl_Position and _fragcolor. Writing to _fragcolor each time
    // may not be necessary in each iteration (is not on NVIDIA cards), 
    // but I am playing it safe here. Says the GLSL specification: 
    // "When emitting each vertex, a geometry shader should write 
    //  to all outputs..."

    for ( int i=0; i<3; i++ )
    {
      _fragcolor = color;
      gl_Position = P*vec4(_wcoord[i],1);
      EmitVertex();
    }

    // This is not absolutely necessary since we are sending only one
    //  primitive (triangle strip with exactly one triangle) out.

    EndPrimitive();

    // We could send more vertices and primitives out here... 
}
