uniform float uTime;
uniform float uProgress;
uniform sampler2D uDisplace;
uniform sampler2D uTextureOne;
uniform vec2 uImageRes;
uniform vec2 uRes;
uniform sampler2D uText;
uniform vec2 uMouse;

varying vec2 vUv;
varying vec3 vPosition;


vec2 CoverUV(vec2 u, vec2 s, vec2 i) {
  float rs = s.x / s.y; // Aspect screen size
  float ri = i.x / i.y; // Aspect image size
  vec2 st = rs < ri ? vec2(i.x * s.y / i.y, s.y) : vec2(s.x, i.y * s.x / i.x); // New st
  vec2 o = (rs < ri ? vec2((st.x - s.x) / 2.0, 0.0) : vec2(0.0, (st.y - s.y) / 2.0)) / st; // Offset
  return u * s / st + o;
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main () {

  //! ASPECT RATIO
  vec2 uv = CoverUV(vUv, uRes, uImageRes);
  vec3 Image = texture2D(uTextureOne, uv).rgb;

  //* displace texture
  vec4 displace = texture2D(uDisplace, vUv.yx);

  //* displace the uv
  vec2 displacedUv = vUv;
  displacedUv.y = mix(vUv.y, displace.g, uProgress);

  //* displace the texture
  Image.r = texture2D(uTextureOne, displacedUv + vec2(0.0, 10.0 * 0.01)* uProgress).r;
  Image.g = texture2D(uTextureOne, displacedUv + vec2(0.0, 10.0 * 0.05)* uProgress).g;
  Image.b = texture2D(uTextureOne, displacedUv + vec2(0.0, 10.0 * 0.1)* uProgress).b;

  //gl_FragColor = vec4(Image, 1.0);
  //======================================================================
  //======================================================================

  //! Text Distortion

  vec2 direction = normalize(vPosition.xy - uMouse.xy);
  float dist = length(vPosition - vec3(uMouse, 1.0));

  float prox = 1.0 - map(dist, 0.0, 0.4, 0.0, 1.0);

  prox = clamp(prox, 0.0, 1.0);

  vec2 zoomedUv = vUv + direction * prox * uProgress;

  vec2 zoomedUv1 = mix(vUv, uMouse.xy + vec2(0.5), prox * uProgress);
  vec4 textColor = texture2D(uText, zoomedUv1);

  gl_FragColor = textColor;
//   gl_FragColor = vec4(prox, prox, prox, 1.0);
//   gl_FragColor = vec4(direction, 0.0, 1.0);
// ;
}