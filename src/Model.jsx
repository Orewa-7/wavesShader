import * as THREE from "three";
import { shaderMaterial } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import waveVertex from "./shaders/waves/vertex.glsl";
import waveFragment from "./shaders/waves/fragment.glsl";
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
const SphereMaterial = shaderMaterial(
  {
    uTime: 0,
  },
  sphereVertex,
  sphereFragment
);

extend({ WaveMaterial, SphereMaterial });
export function Model({ color }) {
  const waveRef = useRef();
  const sphereRef = useRef();
  useFrame((state) => {
    if (waveRef) {
      waveRef.current.material.uniforms.uTime.value = state.clock.elapsedTime;
      sphereRef.current.material.uniforms.uTime.value = state.clock.elapsedTime;
    }
  });
  return (
    <>
      <color args={["#f00000"]} attach="background" />

      <mesh ref={waveRef} rotation-x={-Math.PI * 0.5} position={[0, -0.25, 0]}>
        <planeGeometry args={[10, 10, 1024, 1024]} />
        <waveMaterial />
      </mesh>

      <mesh ref={sphereRef} position={[0, 1, 0]}>
        <sphereGeometry args={[0.5, 64, 64]} />
        <sphereMaterial />
      </mesh>
    </>
  );
}
