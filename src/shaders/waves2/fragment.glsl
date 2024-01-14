#include <fog_pars_fragment>

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;
varying float vElevation;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

void main(){
   vec3 baseColourLight = vec3(0.,0.208,0.31);
   vec3 baseColourDark = vec3(0.0000, 0.0331, 0.1329);
   float elevation = remap(vElevation, 0., 0.35, 0., 1.) ;
   vec3 baseColour = mix(baseColourDark, baseColourLight, elevation);
  vec3 lighting = vec3(0.0);
  vec3 normal = normalize(vNormal);
   vec3 viewDir = normalize(cameraPosition - vPosition);

  // Ambient
  vec3 ambient = vec3(0.5);

  // Hemi light
  vec3 skyColour = vec3(0.0, 0.6, 0.8);
  vec3 groundColour = vec3(0.6, 0.3, 0.1);

  float hemiMix = remap(normal.y, -1.0, 1.0, 0.0, 1.0);
  vec3 hemi = mix(groundColour, skyColour, hemiMix);

  // Diffuse lighting
  vec3 lightDir = normalize(vec3(1.0, 1., 1.0));
  vec3 lightColour = vec3(1.0, 1.0, 1.0);
  float dp = max(0.0, dot(-lightDir, normal));

  vec3 diffuse = dp * lightColour;

  // Phong specular
  vec3 r = normalize(reflect(-lightDir, normal));
  float phongValue = max(0.0, dot(viewDir, r));
  phongValue = pow(phongValue, 36.0);

  vec3 specular = vec3(phongValue)*vec3(1.,1.,0.9);

  // Fresnel
  float fresnel = 1.0 - max(0.0, dot(viewDir, normal));
  fresnel = pow(fresnel, 2.0);

  specular *= fresnel;

  lighting = ambient * 0.0 + hemi * 0.2 + diffuse * 0.8;

  vec3 colour = baseColour * lighting + specular * 0.1;
  colour = pow(colour, vec3(1.0 / 2.2));

  // colour = vec3(vPosition.y+0.5);

  gl_FragColor = vec4(vec3(colour), 1.0);
  #include <fog_fragment>
}