﻿Shader "Zan/Unlit/Procedural/Ring"
{
	Properties
	{
		[Caption(Color Blending Properties)]
		[HDR] _Color( "Base Color", Color) = ( 1,1,1,1)
		
		[Caption(Vertex Color Blending Properties)]
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_VERTEXCOLORBLENDSRC( "Vertex Color Blend Ratop Source", float) = 1
		_VertexColorBlendRatio( "Vertex Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_VERTEXALPHABLENDOP( "Vertex Alpha Blend Op", float) = 2
		_VertexAlphaBlendRatio( "Vertex Alpha Blend Ratio Value", float) = 1.0
		
		[Caption(Ring Properties)]
		_CircleRadius( "Circle Radius", Range( 0, 4)) = 1.0
		_RingSize( "Ring Size", Range( 0, 2)) = 0.5
		_SmoothEdges( "Smooth Edges", Range( 0, 1)) = 0.02
		[Toggle] _FASTMODE( "Fast Mode (non-linear)", float) = 1
		
		/* Use Custom Datas */
		[Caption(Custom Datas)]
		[Toggle] _CD_CIRCLERADIUS( "Circle Radius *= (TEXCORD0.z)", float) = 0
		[Toggle] _CD_RINGSIZE( "Ring Size *= (TEXCORD0.w)", float) = 0
		
		/* Rendering Status */
		[Enum( UnityEngine.Rendering.CullMode)]
		_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_ZTest( "ZTest", float) = 8	/* Always */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_ColorMask( "Color Mask", float) = 15 /* RGBA */
		
		[Toggle] _ALPHACLIP( "Use Alpha Clip", float) = 0
		_AlphaClipThreshold( "Alpha Clip Threshold", Range( 0.0, 1.0)) = 0
		
		/* Blending Status */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_ColorBlendOp( "Color Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_ColorSrcFactor( "Color Src Factor", float) = 5 /* SrcAlpha */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_ColorDstFactor( "Color Dst Factor", float) = 10 /* OneMinusSrcAlpha */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_AlphaBlendOp( "Alpha Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_AlphaSrcFactor( "Alpha Src Factor", float) = 5 /* SrcAlpha */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_AlphaDstFactor( "Alpha Dst Factor", float) = 10 /* OneMinusSrcAlpha */
		[Toggle] _PREBLEND( "Use Pre Blending", float) = 0
		_PreBlendColor( "Pre Blend Color", Color) = ( 0, 0, 0, 0)
		
		/* Depth Stencil Status */
		_Stencil( "Stencil ID", Range( 0, 255)) = 0
		_StencilReadMask( "Stencil Read Mask", Range( 0, 255)) = 255
		_StencilWriteMask( "Stencil Write Mask", Range( 0, 255)) = 255
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_StencilComp( "Stencil Compare Function", float) = 8	/* Always */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilOp( "Stencil Pass Operation", float) = 0 /* Keep */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilFail( "Stencil Fail Operation", float) = 0 /* Keep */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilZFail( "Stencil ZFail Operation", float) = 0 /* Keep */
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		Pass
		{
			Name "NORMAL"
			Tags
			{
				"LightMode" = "Always"
			}
			Lighting Off
			Cull [_Cull]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			ColorMask [_ColorMask]
			BlendOp [_ColorBlendOp], [_AlphaBlendOp]
			Blend [_ColorSrcFactor] [_ColorDstFactor], [_AlphaSrcFactor] [_AlphaDstFactor]
			
			Stencil
			{
				Ref [_Stencil]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilComp]
				Pass [_StencilOp]
				Fail [_StencilFail]
				ZFail [_StencilZFail]
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature_local _ _FASTMODE_ON
			#pragma shader_feature_local _ _CD_CIRCLERADIUS_ON
			#pragma shader_feature_local _ _CD_RINGSIZE_ON
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _VERTEXCOLORBLENDSRC_VALUE _VERTEXCOLORBLENDSRC_ALPHABLENDOP _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP _VERTEXCOLORBLENDSRC_BASEALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA _VERTEXCOLORBLENDSRC_BLENDALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA _VERTEXCOLORBLENDSRC_BASECOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _VERTEXALPHABLENDOP_NONE _VERTEXALPHABLENDOP_OVERRIDE _VERTEXALPHABLENDOP_MULTIPLY _VERTEXALPHABLENDOP_ADD _VERTEXALPHABLENDOP_SUBSTRACT _VERTEXALPHABLENDOP_REVERSESUBSTRACT _VERTEXALPHABLENDOP_MAXIMUM
			#pragma shader_feature_local _ _ALPHACLIP_ON
			#pragma shader_feature_local _ _PREBLEND_ON
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "../Includes/Blend.cginc"
			
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( float, _CircleRadius)
				UNITY_DEFINE_INSTANCED_PROP( float, _RingSize)
				UNITY_DEFINE_INSTANCED_PROP( float, _SmoothEdges)
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				UNITY_DEFINE_INSTANCED_PROP( float,  _VertexColorBlendRatio)
			#endif
			#if !defined(_VERTEXALPHABLENDOP_NONE)
				UNITY_DEFINE_INSTANCED_PROP( float,  _VertexAlphaBlendRatio)
			#endif
			#if defined(_ALPHACLIP_ON)
				UNITY_DEFINE_INSTANCED_PROP( float,  _AlphaClipThreshold)
			#endif
			#if defined(_PREBLEND_ON)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _PreBlendColor)
			#endif    
			UNITY_INSTANCING_BUFFER_END( Props)
			#include "../Includes/BlendMacro.cginc"
			
			struct VertexInput
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 uv0 : TEXCOORD0;
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				fixed4 vertexColor : COLOR;
			#endif
			};
			struct VertexOutput
			{
				float4 position : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 uv0 : TEXCOORD0;
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				fixed4 vertexColor : COLOR;
			#endif
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.position = UnityObjectToClipPos( v.vertex);
				o.uv0 = v.uv0;
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				o.vertexColor = v.vertexColor;
			#endif
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				fixed4 color = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				color = VertexColorBlending( color, i.vertexColor);
			#endif
				float circleRadius = UNITY_ACCESS_INSTANCED_PROP( Props, _CircleRadius);
				float ringSize = UNITY_ACCESS_INSTANCED_PROP( Props, _RingSize);
				float smoothEdges = UNITY_ACCESS_INSTANCED_PROP( Props, _SmoothEdges);
			#if defined(_CD_CIRCLERADIUS_ON)
				circleRadius *= i.uv0.z;
			#endif
			#if defined(_CD_RINGSIZE_ON)
				ringSize *= i.uv0.w;
			#endif
				ringSize = circleRadius - ringSize;
				
				float2 uv = frac( i.uv0.xy) - 0.5;
			#if defined(_FASTMODE_ON)
				float value = dot( uv, uv) * 4.0;
			#else
				float value = length( uv * 2.0);
			#endif
				float circle1 = smoothstep( circleRadius - smoothEdges, circleRadius, value);
				float circle2 = smoothstep( ringSize - smoothEdges, ringSize, value);
				color.a = saturate( color.a * (circle2 - circle1));
			#if defined(_ALPHACLIP_ON)
				clip( color.a - UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaClipThreshold) - 1e-4);
			#endif
			#if defined(_PREBLEND_ON)
				color.rgb = (color.rgb * color.a) + (UNITY_ACCESS_INSTANCED_PROP( Props, _PreBlendColor) * (1.0 - color.a));
			#endif
				return color;
			}
			ENDCG
		}
	}
	Fallback Off
	CustomEditor "Shaders.Editor.InspectorGUI"
}
