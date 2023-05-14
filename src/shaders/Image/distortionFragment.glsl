uniform float uTime;
uniform float uProgress;
uniform sampler2D uDisplace;
uniform sampler2D uTextureOne;
uniform sampler2D uTextureTwo;

varying vec2 vUv;


void main () {
  vec4 displace = texture2D(uDisplace, vUv.yx);
  vec2 displacedUv = vec2(
    vUv.x,
    vUv.y
  );
  displacedUv.y = mix(vUv.y, displace.g - 0.2, 
  
  uProgress);

  vec4 Image = texture2D(uTextureOne, displacedUv);

  Image.r = texture2D(uTextureOne, displacedUv + vec2(0.0,10.0 
  * 0.05)* uProgress).r;
  Image.g = texture2D(uTextureOne, displacedUv + vec2(0.0, 10.0 * 0.01)* uProgress).g;
  Image.b = texture2D(uTextureOne, displacedUv + vec2(0.0, 10.0 *  0.02)* uProgress).b;



  gl_FragColor = Image;
}