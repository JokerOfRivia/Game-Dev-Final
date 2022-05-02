// Black and white fragment shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
	float brightness = (texColor.r + texColor.b + texColor.g) / 3.0;
    vec3 newColor = vec3(step(0.3, brightness));
    gl_FragColor = v_vColour * vec4(newColor, texColor.a);
}
