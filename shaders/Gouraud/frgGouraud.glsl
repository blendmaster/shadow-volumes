#version 330

// this is the only output variable, so it will be 
//  interpreted as the final color of the fragment 

out vec3 fragcolor;

// interpolated value of the vertex shader output 
// with the same name

noperspective in vec3 _fragcolor;

// all we need to do here is just copy... 

void main() { 

    fragcolor = _fragcolor;
} 
