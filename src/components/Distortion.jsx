import { shaderMaterial, useTexture } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import vertexShader from "../shaders/Image/distortionVertex.glsl";
import fragmentShader from "../shaders/Image/distortionFragment.glsl";
import DisplacementMap from "../assets/map1.jpg";
import img1 from "../assets/img1.jpg";
import img2 from "../assets/img2.jpg";
import { useRef, useState } from "react";
import { useControls } from "leva";

const Distortion = () => {
  const ref = useRef();
  const [hovered, setHovered] = useState(false);

  //   const { progress } = useControls({
  //     progress: {
  //       value: 0.0,
  //       min: 0,
  //       max: 1,
  //       step: 0.0001,
  //     },
  //   });

  const Displace = useTexture(DisplacementMap);
  const imageOne = useTexture(img1);
  const imageTwo = useTexture(img2);

  const DistortionMaterial = shaderMaterial(
    {
      uTime: 0,
      uProgress: 0,
      uDisplace: Displace,
      uTextureOne: imageOne,
      uTextureTwo: imageTwo,
    },
    vertexShader,
    fragmentShader
  );

  extend({ DistortionMaterial });

  useFrame((state, delta) => {
    ref.current.uTime += delta;
    ref.current.uProgress = hovered ? 0.1 : 0;
  });

  return (
    <mesh
      scale={4}
      onPointerOver={() => setHovered(true)}
      onPointerLeave={() => setHovered(false)}
    >
      <planeGeometry />
      <distortionMaterial ref={ref} />
    </mesh>
  );
};

export default Distortion;
