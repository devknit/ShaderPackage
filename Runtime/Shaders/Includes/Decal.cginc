
#ifndef __DECAL_CGINC__
#define __DECAL_CGINC__

uniform sampler2D_float _CameraDepthTexture;

inline float3 ViewSpaceRay( float4 vertex)
{
	return UnityObjectToViewPos( vertex).xyz * float3( -1, -1, 1);
}
inline float3 DecalObjectPosition( float4 screenUV, float3 ray)
{
	ray *= _ProjectionParams.z / ray.z;
	float depth = Linear01Depth( SAMPLE_DEPTH_TEXTURE( 
		_CameraDepthTexture, screenUV.xy / screenUV.w));
	float4 vpos = float4( ray * depth, 1);
	float3 wpos = mul( unity_CameraToWorld, vpos).xyz;
	float3 opos = mul( unity_WorldToObject, float4( wpos, 1)).xyz;
	return opos;
}

#endif /* __DECAL_CGINC__ */
