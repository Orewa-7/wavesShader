import * as THREE from "three";
import { shaderMaterial } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import waveVertex from "./shaders/waves/vertex.glsl";
import waveFragment from "./shaders/waves/fragment.glsl";
import { useRef } from "react";

const WaveMaterial = shaderMaterial(
  {
    uTime: 0,
  },
  waveVertex,
  waveFragment
);

extend({ WaveMaterial });
export function Model({ color }) {
  const waveRef = useRef();
  useFrame((state) => {
    if (waveRef) {
      waveRef.current.material.uniforms.uTime.value = state.clock.elapsedTime;
      console.log();
    }
  });
  return (
    <>
      <color args={["#000000"]} attach="background" />

      <mesh ref={waveRef} rotation-x={-Math.PI * 0.5}>
        <planeGeometry args={[1, 1, 64, 64]} />
        <waveMaterial />
      </mesh>
    </>
  );
}
