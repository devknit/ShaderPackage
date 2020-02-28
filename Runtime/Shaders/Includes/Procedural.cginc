
#ifndef __PROCEDURAL_CGINC__
#define __PROCEDURAL_CGINC__

inline float cross( float2 v1, float2 v2)
{
	return dot( v1, float2( v2.y, -v2.x));
}
inline float2 sincos( float radian)
{
	return float2( sin( radian), cos( radian));
}
inline float2 rotation( float2 v, float2 sincos)
{
	return float2( 
		v.x * sincos.y - v.y * sincos.x,
		v.x * sincos.x + v.y * sincos.y);
}
float squarePattern( float2 v, float2 size, float smoothEdges, float intensity)
{
	v = frac( v);
	
    size = (0.5).xx - size * 0.5;
    float2 aa = (smoothEdges * 0.5).xx;
    float2 uv = smoothstep( size, size + aa, v);
    uv *= smoothstep( size, size + aa, (1.0).xx - v);
    float f = uv.x * uv.y;
    return 1.0 - smoothstep( 1.0 - smoothEdges, 1.0, 1.0 - (f * intensity));
}

#endif /* __PROCEDURAL_CGINC__ */
