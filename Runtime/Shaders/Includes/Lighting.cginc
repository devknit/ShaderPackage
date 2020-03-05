
#ifndef __ZAN_LIGHTING_CGINC__
#define __ZAN_LIGHTING_CGINC__

#include "UnityCG.cginc"

inline half pow5( half x)
{
    return x * x * x * x * x;
}
inline half2 pow5( half2 x)
{
    return x * x * x * x * x;
}
inline half3 pow5( half3 x)
{
    return x * x * x * x * x;
}
inline half4 pow5( half4 x)
{
    return x * x * x * x * x;
}

inline half lerpOneTo( half b, half t)
{
	half oneMinusT = 1 - t;
    return oneMinusT + b * t;
}

inline half3 shadeSHPerVertex( half3 normal, half3 ambient)
{
#if defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#elif (SHADER_TARGET < 30)
	ambient += max( 0.0h, ShadeSH9( half4( normal, 1.0h)));
#else
	#ifdef UNITY_COLORSPACE_GAMMA
        ambient = GammaToLinearSpace( ambient);
    #endif
	ambient += SHEvalLinearL2( half4( normal, 1.0h));
#endif
	return ambient;
}
inline half4 vertGI( float2 texcoord1, float2 texcoord2, float3 posWorld, half3 normalWorld)
{
	half4 ambientOrLightmapUV = 0;
#if defined(LIGHTMAP_ON)
	ambientOrLightmapUV.xy = texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	ambientOrLightmapUV.zw = 0;
#elif UNITY_SHOULD_SAMPLE_SH
	#if defined(VERTEXLIGHT_ON)
		ambientOrLightmapUV.rgb = Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[ 0].rgb, unity_LightColor[ 1].rgb, unity_LightColor[ 2].rgb, unity_LightColor[ 3].rgb,
			unity_4LightAtten0, posWorld, normalWorld);
	#endif
	ambientOrLightmapUV.rgb = shadeSHPerVertex( normalWorld, ambientOrLightmapUV.rgb);
#endif
#if defined(DYNAMICLIGHTMAP_ON)
	ambientOrLightmapUV.zw = texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif
	return ambientOrLightmapUV;
}
inline UnityGIInput fragGIData( float3 worldPosition, 
	float3 normalDirection, float3 viewDirection, float3 lightDirection, 
	float4 ambientOrLightmapUV, float attenuation, float perceptualRoughness)
{
	UnityLight light;
#if defined(LIGHTMAP_OFF)
	light.color = _LightColor0.rgb;
	light.dir = lightDirection;
	light.ndotl = LambertTerm( normalDirection, lightDirection);
#else
	light.color = half3( 0.0f, 0.0f, 0.0f);
	light.ndotl = 0.0f;
	light.dir = half3( 0.0f, 0.0f, 0.0f);
#endif
	
	UnityGIInput data;
	data.light = light;
	data.worldPos = worldPosition;
	data.worldViewDir = viewDirection;
	data.atten = attenuation;
#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
	data.ambient = 0;
	data.lightmapUV = ambientOrLightmapUV;
#else
	data.ambient = ambientOrLightmapUV;
	data.lightmapUV = 0;
#endif
#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
	data.boxMin[ 0] = unity_SpecCube0_BoxMin;
	data.boxMin[ 1] = unity_SpecCube1_BoxMin;
#endif
#if UNITY_SPECCUBE_BOX_PROJECTION
	data.boxMax[ 0] = unity_SpecCube0_BoxMax;
	data.boxMax[ 1] = unity_SpecCube1_BoxMax;
	data.probePosition[ 0] = unity_SpecCube0_ProbePosition;
	data.probePosition[ 1] = unity_SpecCube1_ProbePosition;
#endif
	data.probeHDR[ 0] = unity_SpecCube0_HDR;
	data.probeHDR[ 1] = unity_SpecCube1_HDR;
	return data;
}

/**
 * diffuse
 * - 正規化Lambert
 * - Disney (Burley) diffuse BRDF
 */
inline float3 diffuseLambert( half NdotL, float3 attenColor)
{
	return NdotL * attenColor;
}
inline half schlickFresnel( half f0, half f90, half cos0)
{
	return f0 + (f90 - f0) * pow5( 1.0h - cos0);
}
inline float3 diffuseDisney( half NdotV, half NdotL, half LdotH, half perceptualRoughness, float3 attenColor)
{
    half fd90 = 0.5h + 2.0h * LdotH * LdotH * perceptualRoughness;
    half lightScatter = schlickFresnel( 1.0h, fd90, NdotL);
    half viewScatter  = schlickFresnel( 1.0h, fd90, NdotV);
    return lightScatter * viewScatter * NdotL * attenColor;
}
 
/**
 * specular
 * - Blinn-Phong
 * - Phong
 * - Cook-Torrance
 * - Torrance-Sparrow
 */


#endif /* __ZAN_LIGHTING_CGINC__ */
