import { shaderMaterial, useTexture } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import vertexShader from "../shaders/Image/distortionVertex.glsl";
import fragmentShader from "../shaders/Image/distortionFragment.glsl";
import DisplacementMap from "../assets/map1.jpg";
import img1 from "../assets/damn.jpg";
import { useRef } from "react";
import { gsap } from "gsap";

const Distortion = () => {
  const ref = useRef();

  const Displace = useTexture(DisplacementMap);
  const imageOne = useTexture(img1);

  const DistortionMaterial = shaderMaterial(
    {
      uTime: 0,
      uProgress: 0,
      uDisplace: Displace,
      uTextureOne: imageOne,
      uImageRes: [imageOne.source.data.width, imageOne.source.data.height],
      uRes: [1, 1],
    },
    vertexShader,
    fragmentShader
  );

  extend({ DistortionMaterial });

  useFrame((state, delta) => {
    ref.current.uTime += delta;
  });

  const handleMouseEnter = () => {
    gsap.fromTo(
      ref.current.uniforms.uProgress,
      { value: 0 },
      {
        value: 0.15,
        duration: 1,
        ease: "expo.easeOut",
      }
    );
  };

  const handleMouseLeave = () => {
    gsap.fromTo(
      ref.current.uniforms.uProgress,
      { value: 0.15 },
      { value: 0, duration: 1, ease: "expo.easeIn" }
    );
  };

  return (
    <mesh
   
      onPointerEnter={handleMouseEnter}
      onPointerLeave={handleMouseLeave}
    >
      <planeGeometry args={[4, 6]} />
      <distortionMaterial ref={ref} />
    </mesh>
  );
};

export default Distortion;
