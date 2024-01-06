varying vec2 vUv;
varying vec4 vPosition;
varying vec3 vNormal;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

void main(){
   vec3 baseColour = vec3(0.5);
  vec3 lighting = vec3(0.0);
  vec3 normal = normalize(vNormal);

  // Ambient
  vec3 ambient = vec3(0.5);

  // Hemi light
  vec3 skyColour = vec3(0.0, 0.3, 0.6);
  vec3 groundColour = vec3(0.6, 0.3, 0.1);

  float hemiMix = remap(normal.y, -1.0, 1.0, 0.0, 1.0);
  vec3 hemi = mix(groundColour, skyColour, hemiMix);

  // Diffuse lighting
  vec3 lightDir = normalize(vec3(10., 1.0, 1.));
  vec3 lightColour = vec3(1.0, 1.0, 1.0);
  float dp = max(0.0, dot(lightDir, normal));

  vec3 diffuse = dp * lightColour;

  lighting = ambient * 0.0 + hemi * 0.2 + diffuse * 0.8;

  vec3 colour = baseColour * lighting;

  // colour = linearTosRGB(colour);
  colour = pow(colour, vec3(1.0 / 2.2));

  gl_FragColor = vec4(diffuse, 1.0);

}