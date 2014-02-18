#version 330

// this shader is basically identical to the Phong fragment shader.
// The only differences: input variable names changed to remove
// name conflict with the outputs of vertex shader.
// And using complementary k's if which = 1, to color the two copies
// of the model differently.

out vec3 fragcolor;

noperspective in vec3 _wnormal2;
noperspective in vec3 _wcoord2;
flat in int which;

uniform vec3 lloc;
uniform vec3 kd,ka,ks;
uniform float nspec;
uniform vec3 I,Ia;
uniform int reor;

void main() { 

    vec3 N = reor*normalize(_wnormal2);
    vec3 L = normalize(lloc-_wcoord2);
    vec3 V = -normalize(_wcoord2);
    vec3 H = normalize(L+V);

    float NdotL = dot(N,L);
    float HdotN = dot(H,N);

    if (NdotL<0) NdotL = 0.0;
    if (HdotN<0) HdotN = 0.0;

    fragcolor = which==0 ? ka*Ia + (kd*NdotL + ks*pow(HdotN,nspec))*I :
			(vec3(1)-ka)*Ia + ((vec3(1)-kd)*NdotL + (vec3(1)-ks)*pow(HdotN,nspec))*I;
} 
