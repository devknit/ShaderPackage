
#ifndef __GRAB_DISTORTION_CGINC__
#define __GRAB_DISTORTION_CGINC__

#include "UnityCG.cginc"
uniform sampler2D _MainTex;
uniform sampler2D _DistortionTex;
float4 _MainTex_ST;
float4 _DistortionTex_ST;
float4 _MainTexAlphaRemap;
float  _ColorBlendRatio1;
float  _AlphaBlendRatio1;
float  _BaseMapDistortionVolume;
float  _MultiMapDistortionVolume;
#if !defined(_VERTEXCOLORBLENDOP_NONE)
float  _VertexColorBlendRatio;
#endif
#if !defined(_VERTEXALPHABLENDOP_NONE)
float  _VertexAlphaBlendRatio;
#endif
#if defined(_ALPHACLIP_ON)
float  _AlphaClipThreshold;
#endif
#if defined(_PREBLEND_ON)
fixed4 _PreBlendColor;
#endif
#include "../Includes/Macro.cginc"
#include "../Includes/Blend.cginc"
#include "../Includes/BlendMacro.cginc"

struct VertexInput
{
	float4 vertex : POSITION;
	UNITY_VERTEX_INPUT_INSTANCE_ID
	float4 uv0 : TEXCOORD0;
#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON)
	float4 uv1 : TEXCOORD1;
#endif
#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	fixed4 vertexColor : COLOR;
#endif
};
struct VertexOutput
{
	float4 position : SV_POSITION;
	UNITY_VERTEX_INPUT_INSTANCE_ID
	float4 uv0 : TEXCOORD0;
	float4 uv1 : TEXCOORD1;
#if defined(_CD_BASEDISTORTION_ON) || defined(_CD_MULTIDISTORTION_ON) || defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON)
	float4 uv2 : TEXCOORD2;
#endif
#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	fixed4 vertexColor : COLOR;
#endif
};
void vert( VertexInput v, out VertexOutput o)
{
	o = (VertexOutput)0;
	UNITY_SETUP_INSTANCE_ID( v);
	UNITY_TRANSFER_INSTANCE_ID( v, o);
	o.position = UnityObjectToClipPos( v.vertex);
	o.uv0.xy = TRANSFORM_TEX( v.uv0.xy, _MainTex);
	o.uv0.zw = TRANSFORM_TEX( v.uv0.xy, _DistortionTex);
	o.uv1 = ComputeGrabScreenPos( o.position);
#if defined(_CD_BASEDISTORTION_ON) || defined(_CD_MULTIDISTORTION_ON)
	o.uv2.xy = v.uv0.zw;
#endif
#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON)
	o.uv2.zw = v.uv1.xy;
#endif
#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	o.vertexColor = v.vertexColor;
#endif
}
fixed4 fragDistortion( VertexOutput i, sampler2D grabTexture)
{
	UNITY_SETUP_INSTANCE_ID( i);
	fixed4 distortion = tex2D( _DistortionTex, i.uv0.zw);
	distortion.xy = (distortion.xy * 2 - 1) * distortion.w;
	distortion.xy = mul( unity_ObjectToWorld, distortion.xy);
	float baseVolume = _BaseMapDistortionVolume;
	float multiVolume = _MultiMapDistortionVolume;
#if defined(_CD_BASEDISTORTION_ON)
	baseVolume *= i.uv2.x;
#endif
#if defined(_CD_MULTIDISTORTION_ON)
	multiVolume *= i.uv2.y;
#endif
	fixed4 blendColor1 = tex2D( _MainTex, i.uv0.xy + distortion.xy * multiVolume);
	blendColor1.a = remap( blendColor1.a, _MainTexAlphaRemap);
	float colorBlendRatio = _ColorBlendRatio1;
	float alphaBlendRatio = _AlphaBlendRatio1;
#if defined(_CD_COLORBLENDRATIO1_ON)
	colorBlendRatio *= i.uv2.z;
#endif
#if defined(_CD_ALPHABLENDRATIO1_ON)
	alphaBlendRatio *= i.uv2.w;
#endif
	fixed4 color = tex2D( grabTexture, (i.uv1.xy / i.uv1.w) + (distortion.xy * baseVolume));
	
#if defined(_BLENDORDER_INVERSE)
#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	blendColor1 = VertexColorBlending( blendColor1, i.vertexColor);
#endif
#endif
	color = Blending1( color, blendColor1, colorBlendRatio, alphaBlendRatio);
#if defined(_BLENDORDER_DEFAULT)
#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	color = VertexColorBlending( color, i.vertexColor);
#endif
#endif
#if defined(_ALPHACLIP_ON)
	clip( color.a - _AlphaClipThreshold - 1e-4);
#endif
#if defined(_PREBLEND_ON)
	color.rgb = (color.rgb * color.a) + (_PreBlendColor * (1.0 - color.a));
#endif
	return color;
}
#endif /* __GRAB_DISTORTION_CGINC__ */
