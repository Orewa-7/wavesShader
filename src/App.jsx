import { OrbitControls } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { useState } from "react";
import { Model } from "./Model";
import * as THREE from "three";

export default function App() {
  const cameraPosition = [0, 0, 1];

  return (
    <>
      <Canvas
        gl={{
          outputColorSpace: THREE.LinearSRGBColorSpace,
          toneMapping: THREE.ACESFilmicToneMapping,
          alpha: true,
        }}
        camera={{
          fov: 30,
          near: 0.1,
          far: 200,
          position: cameraPosition,
        }}
      >
        <OrbitControls />
        <Model />
      </Canvas>
    </>
  );
}
