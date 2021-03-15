
#ifndef __GRAB_GAUSSIAN_BLUR_CGINC__
#define __GRAB_GAUSSIAN_BLUR_CGINC__

sampler2D _GaussianTex;
sampler2D _MainTex;
float4 _MainTex_ST;
float4 _ClipRect;
fixed4 _Color;
fixed4 _TextureSampleAdd;

float _AlphaClipThreshold;
float4 _MainTexAlphaRemap;
float _ColorBlendRatio1;
float _AlphaBlendRatio1;
float _VertexColorBlendRatio;
float _VertexAlphaBlendRatio;

sampler2D _GrabTexture;
float4 _GrabTexture_TexelSize;
int _SampleCount;
int _SampleInterval;

#include "UnityCG.cginc"
#include "UnityUI.cginc"
#include "../Includes/Blend.cginc"
#include "../Includes/BlendMacro.cginc"

struct VertexInput
{
	float4 vertex : POSITION;
	fixed4 color : COLOR;
	float2 texcoord : TEXCOORD0;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};
struct VertexOutput
{
	float4 vertex : SV_POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD0; 
	float4 screenPosition : TEXCOORD1;
	UNITY_VERTEX_OUTPUT_STEREO
};
void vert( VertexInput v, out VertexOutput o)
{
	UNITY_SETUP_INSTANCE_ID( v);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o);
	o.vertex = UnityObjectToClipPos( v.vertex);
	o.color = v.color;
	o.texcoord.xy = TRANSFORM_TEX( v.texcoord, _MainTex);
	o.texcoord.zw = v.vertex;
	o.screenPosition = ComputeGrabScreenPos( o.vertex);
}
half3 horizontal( float4 screenPosition)
{
	half3 color = tex2Dproj( _GrabTexture, screenPosition).rgb;
	float totalWeight = 1.0;
	
	[loop]
	for( float i0 = _SampleCount; i0 > 0; i0 -= 1)
	{
		float weight = tex2D( _GaussianTex, float2( i0 / _SampleCount, 0)).r;
		float texcoord = i0 * _SampleInterval * _GrabTexture_TexelSize.x;
		totalWeight += weight * 2.0;
		color += tex2Dproj( _GrabTexture, screenPosition + float4( texcoord, 0, 0, 0)).rgb * weight;
		color += tex2Dproj( _GrabTexture, screenPosition + float4( -texcoord, 0, 0, 0)).rgb * weight;
	}
	return color / totalWeight;
}
half4 fragHorizontal( VertexOutput i) : COLOR
{
	half4 blendColor = (tex2D( _MainTex, i.texcoord) + _TextureSampleAdd);
	half4 color = 1;
	
#if defined(_BLENDORDER_INVERSE)
	#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
//	blendColor.a = VertexAlphaBlending( blendColor, i.color);
	#endif
#endif
	color.a = BlendingAlpha1( color, blendColor, _AlphaBlendRatio1);
#if !defined(_BLENDORDER_INVERSE)
	#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
//	color.a = VertexAlphaBlending( color, i.color);
	#endif
#endif
#if defined(UNITY_UI_CLIP_RECT)
	color.a *= UnityGet2DClipping( i.texcoord.zw, _ClipRect);
#endif
#if defined(_ALPHACLIP_ON) || defined(UNITY_UI_ALPHACLIP)
	half alpha = color.a;
	#if defined(_ALPHACLIP_ON)
	alpha -= _AlphaClipThreshold;
	#endif
	clip( alpha - 1e-4);
#endif
	return half4( horizontal( i.screenPosition), color.a);
}
half3 vertical( float4 screenPosition)
{
	half3 color = tex2Dproj( _GrabTexture, screenPosition).rgb;
	float totalWeight = 1.0;
	
	[loop]
	for( float i0 = _SampleCount; i0 > 0; i0 -= 1)
	{
		float weight = tex2D( _GaussianTex, float2( i0 / _SampleCount, 0)).r;
		float texcoord = i0 * _SampleInterval * _GrabTexture_TexelSize.y;
		totalWeight += weight * 2.0;
		color += tex2Dproj( _GrabTexture, screenPosition + float4( 0, texcoord, 0, 0)).rgb * weight;
		color += tex2Dproj( _GrabTexture, screenPosition + float4( 0, -texcoord, 0, 0)).rgb * weight;
	}
	return color / totalWeight;
}
half4 fragVertical( VertexOutput i) : COLOR
{
	half4 blendColor = (tex2D( _MainTex, i.texcoord) + _TextureSampleAdd);
	
	blendColor.a = remap( blendColor.a, _MainTexAlphaRemap);
#if defined(UNITY_UI_CLIP_RECT)
	blendColor.a *= UnityGet2DClipping( i.texcoord.zw, _ClipRect);
#endif
	half4 color = half4( vertical( i.screenPosition), 1);
#if defined(_BLENDORDER_INVERSE)
	#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	blendColor = VertexColorBlending( blendColor, i.color);
	#endif
#endif
	color = Blending1( color, blendColor, _ColorBlendRatio1, _AlphaBlendRatio1);
#if defined(_BLENDORDER_DEFAULT)
	#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
	color = VertexColorBlending( color, i.color);
	#endif
#endif
#if defined(_ALPHACLIP_ON) || defined(UNITY_UI_ALPHACLIP)
	half alpha = color.a;
	#if defined(_ALPHACLIP_ON)
	alpha -= _AlphaClipThreshold;
	#endif
	clip( alpha - 1e-4);
#endif
	return color;
}
#endif /* __GRAB_GAUSSIAN_BLUR_CGINC__ */
