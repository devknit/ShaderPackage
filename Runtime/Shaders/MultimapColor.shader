﻿Shader "Zan/Unlit/MultimapColor"
{
	Properties
	{
		[Caption(Base Map Properties)]
		_MainTex( "Base Map", 2D) = "white" {}
		
		[Caption(Multi Map Blending Properties)]
		_MultiTex( "Blend Map", 2D) = "white" {}
		[Vector2x2(Input, Output, Min, Max)]
		_MultiTexAlphaRemap( "Blend Map Alpha Remap Param", Vector) = (0.0, 1.0, 0.0, 1.0)
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP1( "Multi Map Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC1( "Multi Map Color Blend Ratop Source", float) = 0
		_ColorBlendRatio1( "Multi Map Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_ALPHABLENDOP1( "Multi Map Alpha Blend Op", float) = 2
		_AlphaBlendRatio1( "Multi Map Alpha Blend Ratio Value", float) = 1.0
		
		[Caption(Color Blending Properties)]
		[HDR] _Color( "Blend Color", Color) = ( 1,1,1,1)
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_VERTEXCOLORBLENDSRC( "Color Blend Ratop Source", float) = 1
		_VertexColorBlendRatio( "Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_VERTEXALPHABLENDOP( "Alpha Blend Op", float) = 2
		_VertexAlphaBlendRatio( "Alpha Blend Ratio Value", float) = 1.0
		
		[Caption(Blending Process)]
		[KeywordEnum(Default, Inverse)]
		_BLENDORDER( "Blend Order", float) = 0
		
		/* Use Custom Data */
		[Caption(Use Custom Data)]
		[Toggle] _CD_COLORBLENDRATIO1( "Multi Map Color Blend Ratio Value *= (TEXCORD0.z)", float) = 0
		[Toggle] _CD_ALPHABLENDRATIO1( "Multi Map Alpha Blend Ratio Value *= (TEXCORD0.w)", float) = 0
		[Toggle] _CD_COLORBLENDRATIO2( "Color Blend Ratio Value *= (TEXCORD1.x)", float) = 0
		[Toggle] _CD_ALPHABLENDRATIO2( "Alpha Blend Ratio Value *= (TEXCORD1.y)", float) = 0
		
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
			#pragma shader_feature_local _BLENDORDER_DEFAULT _BLENDORDER_INVERSE
			#pragma shader_feature_local _COLORBLENDOP1_NONE _COLORBLENDOP1_OVERRIDE _COLORBLENDOP1_MULTIPLY _COLORBLENDOP1_DARKEN _COLORBLENDOP1_COLORBURN _COLORBLENDOP1_LINEARBURN _COLORBLENDOP1_LIGHTEN _COLORBLENDOP1_SCREEN _COLORBLENDOP1_COLORDODGE _COLORBLENDOP1_LINEARDODGE _COLORBLENDOP1_OVERLAY _COLORBLENDOP1_HARDLIGHT _COLORBLENDOP1_VIVIDLIGHT _COLORBLENDOP1_LINEARLIGHT _COLORBLENDOP1_PINLIGHT _COLORBLENDOP1_HARDMIX _COLORBLENDOP1_DIFFERENCE _COLORBLENDOP1_EXCLUSION _COLORBLENDOP1_SUBSTRACT _COLORBLENDOP1_DIVISION
			#pragma shader_feature_local _COLORBLENDSRC1_VALUE _COLORBLENDSRC1_ALPHABLENDOP _COLORBLENDSRC1_ONEMINUSALPHABLENDOP _COLORBLENDSRC1_BASEALPHA _COLORBLENDSRC1_ONEMINUSBASEALPHA _COLORBLENDSRC1_BLENDALPHA _COLORBLENDSRC1_ONEMINUSBLENDALPHA _COLORBLENDSRC1_BASECOLORVALUE _COLORBLENDSRC1_ONEMINUSBASECOLORVALUE _COLORBLENDSRC1_BLENDCOLORVALUE _COLORBLENDSRC1_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature_local _ALPHABLENDOP1_NONE _ALPHABLENDOP1_OVERRIDE _ALPHABLENDOP1_MULTIPLY _ALPHABLENDOP1_ADD _ALPHABLENDOP1_SUBSTRACT _ALPHABLENDOP1_REVERSESUBSTRACT _ALPHABLENDOP1_MAXIMUM
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _VERTEXCOLORBLENDSRC_VALUE _VERTEXCOLORBLENDSRC_ALPHABLENDOP _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP _VERTEXCOLORBLENDSRC_BASEALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA _VERTEXCOLORBLENDSRC_BLENDALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA _VERTEXCOLORBLENDSRC_BASECOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _VERTEXALPHABLENDOP_NONE _VERTEXALPHABLENDOP_OVERRIDE _VERTEXALPHABLENDOP_MULTIPLY _VERTEXALPHABLENDOP_ADD _VERTEXALPHABLENDOP_SUBSTRACT _VERTEXALPHABLENDOP_REVERSESUBSTRACT _VERTEXALPHABLENDOP_MAXIMUM
			#pragma shader_feature_local _ _CD_COLORBLENDRATIO1_ON
			#pragma shader_feature_local _ _CD_ALPHABLENDRATIO1_ON
			#pragma shader_feature_local _ _CD_COLORBLENDRATIO2_ON
			#pragma shader_feature_local _ _CD_ALPHABLENDRATIO2_ON
			#pragma shader_feature_local _ _ALPHACLIP_ON
			#pragma shader_feature_local _ _PREBLEND_ON
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Includes/Macro.cginc"
			#include "Includes/Blend.cginc"
			
			uniform sampler2D _MainTex;
			uniform sampler2D _MultiTex;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _MainTex_ST)
				UNITY_DEFINE_INSTANCED_PROP( float4, _MultiTex_ST)
				UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( float4, _MultiTexAlphaRemap)
				UNITY_DEFINE_INSTANCED_PROP( float,  _ColorBlendRatio1)
				UNITY_DEFINE_INSTANCED_PROP( float,  _AlphaBlendRatio1)
				UNITY_DEFINE_INSTANCED_PROP( float,  _VertexColorBlendRatio)
				UNITY_DEFINE_INSTANCED_PROP( float,  _VertexAlphaBlendRatio)
			#if defined(_ALPHACLIP_ON)
				UNITY_DEFINE_INSTANCED_PROP( float,  _AlphaClipThreshold)
			#endif
			#if _PREBLEND_ON
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _PreBlendColor)
			#endif
			UNITY_INSTANCING_BUFFER_END( Props)
			
			struct VertexInput
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 uv0 : TEXCOORD0;
			#if defined(_CD_COLORBLENDRATIO2_ON) || defined(_CD_ALPHABLENDRATIO2_ON)
				float4 uv1 : TEXCOORD1;
			#endif
			};
			struct VertexOutput
			{
				float4 position : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 uv0 : TEXCOORD0;
			#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON) || defined(_CD_COLORBLENDRATIO2_ON) || defined(_CD_ALPHABLENDRATIO2_ON)
				float4 uv1 : TEXCOORD1;
			#endif
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.position = UnityObjectToClipPos( v.vertex);
				o.uv0.xy = TRANSFORM_TEX_INSTANCED_PROP( v.uv0.xy, _MainTex);
				o.uv0.zw = TRANSFORM_TEX_INSTANCED_PROP( v.uv0.xy, _MultiTex);
			#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON)
				o.uv1.xy = v.uv0.zw;
			#endif
			#if defined(_CD_COLORBLENDRATIO2_ON) || defined(_CD_ALPHABLENDRATIO2_ON)
				o.uv1.zw = v.uv1.xy;
			#endif
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				fixed4 color = tex2D( _MainTex, i.uv0.xy);
				fixed4 blendColor1 = tex2D( _MultiTex, i.uv0.zw);
				fixed4 blendColor2 = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				blendColor1.a = remap( blendColor1.a, UNITY_ACCESS_INSTANCED_PROP( Props, _MultiTexAlphaRemap));
				float colorBlendRatio1 = UNITY_ACCESS_INSTANCED_PROP( Props, _ColorBlendRatio1);
				float alphaBlendRatio1 = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaBlendRatio1);
				float colorBlendRatio2 = UNITY_ACCESS_INSTANCED_PROP( Props, _VertexColorBlendRatio);
				float alphaBlendRatio2 = UNITY_ACCESS_INSTANCED_PROP( Props, _VertexAlphaBlendRatio);
			#if defined(_CD_COLORBLENDRATIO1_ON)
				colorBlendRatio1 *= i.uv1.x;
			#endif
			#if defined(_CD_ALPHABLENDRATIO1_ON)
				alphaBlendRatio1 *= i.uv1.y;
			#endif
			#if defined(_CD_COLORBLENDRATIO1_ON)
				colorBlendRatio2 *= i.uv1.z;
			#endif
			#if defined(_CD_ALPHABLENDRATIO2_ON)
				alphaBlendRatio2 *= i.uv1.w;
			#endif
				
		#if defined(_BLENDORDER_INVERSE)
				blendColor1 = VertexColorBlending( blendColor1, blendColor2, colorBlendRatio2, alphaBlendRatio2);
		#endif
				color = Blending1( color, blendColor1, colorBlendRatio1, alphaBlendRatio1);
		#if defined(_BLENDORDER_DEFAULT)
				color = VertexColorBlending( color, blendColor2, colorBlendRatio2, alphaBlendRatio2);
		#endif	
			#if defined(_ALPHACLIP_ON)
				clip( color.a - UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaClipThreshold) - 1e-4);
			#endif
			#if _PREBLEND_ON
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
