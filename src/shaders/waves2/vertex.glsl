#include <fog_pars_vertex>

varying vec3 vNormal;
varying vec2 vUv;
varying vec3 vPosition;
varying float vElevation;
uniform float uTime;
uniform float uDirection;


#define M_PI 3.1415926535897932384626433832795

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float SinFunction(float x, float a, float speed, float c ){
    return exp(sin(x*a + uTime*speed) * c - 1.14) * 0.1;
}

float sat(float x){
    return clamp(x, 0., 1.);
}

float remap(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

vec3 distortionFunction(vec3 p){
    vec3 position = p;
    float a = 1.;
    float amplitudeSum = 0.;
    float b = 2.;
    float octaves = 32.;
    float speed = 1.5;
    float seed = 4.;
    for(float i = 0.; i < octaves; ++i){

        float dd = i / octaves;
        dd = remap(dd, 0., 1., -1., 1.);
        // vec2 d = vec2(cos(dd * 4.), sin(dd* 4.));
        vec2 d = vec2(cos(seed), sin(seed));
        position.z += SinFunction(dot(position.xy, d), a, speed , b);

        a *=1.18;
        b *=0.82;
        speed*= 1.07;
        amplitudeSum += b/2.;
        seed+=4.3;
    }
    position.z = position.z / amplitudeSum ;
    position.z *= 2.;

    // position.z = remap(position.z, 0., 0.2, 0., .6);

    // position.z = position.z - 0.5 ;

    return position;
}

vec3 distortionFunctionWarping(vec3 p ){
    return distortionFunction(p + distortionFunction(p + distortionFunction(p + distortionFunction(p + distortionFunction(p + distortionFunction(p + distortionFunction(p + distortionFunction(p))))) ) ));
}
vec3 orthogonal(vec3 n){
    return normalize(
        abs(n.x) > abs(n.z) ? vec3(-n.y, n.x, 0.) : vec3(0., -n.z, n.y)
    );
}
void main(){

    #include <begin_vertex>
    #include <project_vertex>
    #include <fog_vertex>
    
    vec3 displacedPosition = distortionFunctionWarping(position);
    vec4 modelPosition = modelMatrix * vec4(displacedPosition, 1.);

    vec3 tangent = orthogonal(normal);
    vec3 bitangent = normalize(cross(tangent, normal));
    vec3 neighbour1 = position + tangent *0.0001;
    vec3 neighbour2 = position + bitangent *0.0001;

    vec3 displacedN1 = distortionFunctionWarping(neighbour1);
    vec3 displacedN2 = distortionFunctionWarping(neighbour2);

    vec3 displacedTangent = displacedN1 - displacedPosition;
    vec3 displacedBitangent = displacedN2 - displacedPosition;

    vec3 displacedNormal = normalize(cross(displacedTangent, displacedBitangent));
    
    vec4 viewPosition = viewMatrix * modelPosition;

    vec4 projectionPosition = projectionMatrix * viewPosition;
    gl_Position = projectionPosition;

    vPosition = (modelMatrix * vec4(displacedPosition, 1.0)).xyz;
    // vNormal = displacedNormal;
    vNormal = (modelMatrix * vec4(displacedNormal, 0.)).xyz;;
    vUv = uv;
    vElevation =  displacedPosition.z;
    // vElevation =  remap(displacedPosition.z, 0., 0.2, 0., .6);;
    
}