uniform float uTime;
uniform float uProgress;
uniform sampler2D uDisplace;
uniform sampler2D uTextureOne;
uniform vec2 uImageRes;
uniform vec2 uRes;

varying vec2 vUv;


vec2 CoverUV(vec2 u, vec2 s, vec2 i) {
  float rs = s.x / s.y; // Aspect screen size
  float ri = i.x / i.y; // Aspect image size
  vec2 st = rs < ri ? vec2(i.x * s.y / i.y, s.y) : vec2(s.x, i.y * s.x / i.x); // New st
  vec2 o = (rs < ri ? vec2((st.x - s.x) / 2.0, 0.0) : vec2(0.0, (st.y - s.y) / 2.0)) / st; // Offset
  return u * s / st + o;
}

void main () {

  //! ASPECT RATIO
  vec2 uv = CoverUV(vUv, uRes, uImageRes);
  vec3 Image = texture2D(uTextureOne, uv).rgb;


  //* displace texture
  vec4 displace = texture2D(uDisplace, vUv.yx);

  // //* displace the uv
  vec2 displacedUv = vUv;
  
  displacedUv.y = mix(vUv.y, displace.g - 0.1, uProgress);



  Image.r = texture2D(uTextureOne, displacedUv + vec2(0.0,5.0 
  * 0.05)* uProgress).r;
  Image.g = texture2D(uTextureOne, displacedUv + vec2(0.0, 5.0 * 0.1)* uProgress).g;
  Image.b = texture2D(uTextureOne, displacedUv + vec2(0.0, 5.0 *  0.2)* uProgress).b;


        

  gl_FragColor = vec4(Image, 1.0);
}