varying vec2 vUv;
uniform float uTime;
void main(){
    vec4 modelPosition = modelMatrix * vec4(position, 1.);
    modelPosition.y += sin(modelPosition.z * 10. + uTime ) *0.05 + sin(modelPosition.x * 10. + uTime ) *0.0125 ;
    modelPosition.y += sin(modelPosition.z * 20. + uTime ) *.025 + sin(modelPosition.x * 20. + uTime ) *.05 ;
    modelPosition.y += sin(modelPosition.z * 30. + uTime ) *.0125 + sin(modelPosition.x * 30. + uTime ) *.025 ;
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectionPosition = projectionMatrix * viewPosition;
    gl_Position = projectionPosition;

    vUv = uv;
}