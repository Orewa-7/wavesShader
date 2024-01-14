import * as THREE from "three";
import { Sky, shaderMaterial } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import waveVertex from "./shaders/waves/vertex.glsl";
import waveFragment from "./shaders/waves/fragment.glsl";
import waveVertex2 from "./shaders/waves2/vertex.glsl";
import waveFragment2 from "./shaders/waves2/fragment.glsl";
import sphereVertex from "./shaders/sphere/vertex.glsl";
import sphereFragment from "./shaders/sphere/fragment.glsl";
import { useRef } from "react";

const WaveMaterial = shaderMaterial(
  {
    uTime: 0,
  },
  waveVertex,
  waveFragment
);
const WaveMaterial2 = shaderMaterial(
  THREE.UniformsUtils.merge([
    THREE.UniformsLib["fog"],
    {
      uTime: { value: 0 },
    },
  ]),
  waveVertex2,
  waveFragment2
);
const SphereMaterial = shaderMaterial(
  {
    uTime: 0,
  },
  sphereVertex,
  sphereFragment
);

extend({ WaveMaterial, SphereMaterial, WaveMaterial2 });
export function Model({ color }) {
  const waveRef = useRef();
  const sphereRef = useRef();

  const material = new THREE.ShaderMaterial({
    side: THREE.DoubleSide,
    fog: true,
    uniforms: THREE.UniformsUtils.merge([
      THREE.UniformsLib["fog"],
      {
        uTime: { value: 0 },
      },
    ]),
    vertexShader: waveVertex2,
    fragmentShader: waveFragment2,
  });

  useFrame((state) => {
    if (waveRef) {
      waveRef.current.material.uniforms.uTime.value = state.clock.elapsedTime;
      sphereRef.current.material.uniforms.uTime.value = state.clock.elapsedTime;
    }
  });

  return (
    <>
      {/* <Sky /> */}
      {/* <color args={["#151626"]} attach={"background"} /> */}
      <color args={["#c8d3d8"]} attach={"background"} />
      <fog attach="fog" args={["#c8d3d8", 5, 20]} />
      <mesh
        ref={waveRef}
        rotation-x={-Math.PI * 0.5}
        position={[0, -0.25, 0]}
        material={material}
      >
        <planeGeometry args={[20, 20, 526, 526]} />
        {/* <waveMaterial /> */}
        {/* <waveMaterial2 fog /> */}
      </mesh>

      <mesh ref={sphereRef} position={[50, 3, 50]}>
        <sphereGeometry args={[0.5, 64, 64]} />
        <sphereMaterial />
      </mesh>
    </>
  );
}
