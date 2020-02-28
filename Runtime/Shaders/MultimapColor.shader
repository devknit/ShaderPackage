﻿Shader "ZanLib/Unlit/MultimapColor"
{
	Properties
	{
		[Header(Base Map Properties)]
		_MainTex( "Base Map", 2D) = "white" {}
		
		[Header(Multi Map Blending Properties)]
		_MultiTex( "Blend Map", 2D) = "white" {}
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP1( "Multi Map Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC1( "Multi Map Color Blend Ratop Source", float) = 0
		_ColorBlendRatio1( "Multi Map Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Offset, Maximum)]
		_ALPHABLENDOP1( "Multi Map Alpha Blend Op", float) = 2
		_AlphaBlendRatio1( "Multi Map Alpha Blend Ratio Value", float) = 1.0
		
		[Header(Color Blending Properties)]
		_Color( "Blend Color", Color) = ( 1,1,1,1)
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP2( "Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC2( "Color Blend Ratop Source", float) = 0
		_ColorBlendRatio2( "Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Offset, Maximum)]
		_ALPHABLENDOP2( "Alpha Blend Op", float) = 2
		_AlphaBlendRatio2( "Alpha Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		
		/* Use Custom Data */
		[Header(Use Custom Data)]
		[Toggle] _CD_COLORBLENDRATIO1( "Multi Map Color Blend Ratio Value *= (TEXCORD0.z)", float) = 0
		[Toggle] _CD_ALPHABLENDRATIO1( "Multi Map Alpha Blend Ratio Value *= (TEXCORD0.w)", float) = 0
		[Toggle] _CD_COLORBLENDRATIO2( "Color Blend Ratio Value *= (TEXCORD1.x)", float) = 0
		[Toggle] _CD_ALPHABLENDRATIO2( "Alpha Blend Ratio Value *= (TEXCORD1.y)", float) = 0
		
		/* Rendering Status */
		[Header(Rendering Status)]
		[Enum( UnityEngine.Rendering.CullMode)]
		_RS_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_RS_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_RS_ZTest( "ZTest", float) = 8	/* Always */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_RS_ColorMask( "Colro Mask", float) = 15 /* RGB */
		
		/* Blending Status */
		[Header(Blending Status)]
		[Enum( UnityEngine.Rendering.BlendOp)]
		_RS_ColorBlendOp( "Color Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_ColorSrcFactor( "Color Src Factor", float) = 5 /* SrcAlpha */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_ColorDstFactor( "Color Dst Factor", float) = 10 /* OneMinusSrcAlpha */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_RS_AlphaBlendOp( "Alpha Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_AlphaSrcFactor( "Alpha Src Factor", float) = 5 /* SrcAlpha */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_AlphaDstFactor( "Alpha Dst Factor", float) = 10 /* OneMinusSrcAlpha */
		_RS_BlendFactor( "Blend Factor", Color) = ( 0, 0, 0, 0)
		[Toggle] _BLENDFACTOR( "Use Blend Factor", float) = 0
		
		/* Depth Stencil Status */
		[Header(Depth Stencil Status)]
		_StencilRef( "Stencil Reference", Range( 0, 255)) = 0
		_StencilReadMask( "Stencil Read Mask", Range( 0, 255)) = 255
		_StencilWriteMask( "Stencil Write Mask", Range( 0, 255)) = 255
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_StencilComp( "Stencil Comparison Function", float) = 8	/* Always */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilPass( "Stencil Pass Operation", float) = 0 /* Keep */
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
		Lighting Off
		Cull [_RS_Cull]
		ZWrite [_RS_ZWrite]
		ZTest [_RS_ZTest]
		BlendOp [_RS_ColorBlendOp], [_RS_AlphaBlendOp]
		Blend [_RS_ColorSrcFactor] [_RS_ColorDstFactor], [_RS_AlphaSrcFactor] [_RS_AlphaDstFactor]
		ColorMask [_RS_ColorMask]
		
		Stencil
		{
			Ref [_StencilRef]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			Comp [_StencilComp]
			Pass [_StencilPass]
			Fail [_StencilFail]
			ZFail [_StencilZFail]
		}
		Pass
		{ 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature _COLORBLENDOP1_NONE _COLORBLENDOP1_OVERRIDE _COLORBLENDOP1_MULTIPLY _COLORBLENDOP1_DARKEN _COLORBLENDOP1_COLORBURN _COLORBLENDOP1_LINEARBURN _COLORBLENDOP1_LIGHTEN _COLORBLENDOP1_SCREEN _COLORBLENDOP1_COLORDODGE _COLORBLENDOP1_LINEARDODGE _COLORBLENDOP1_OVERLAY _COLORBLENDOP1_HARDLIGHT _COLORBLENDOP1_VIVIDLIGHT _COLORBLENDOP1_LINEARLIGHT _COLORBLENDOP1_PINLIGHT _COLORBLENDOP1_HARDMIX _COLORBLENDOP1_DIFFERENCE _COLORBLENDOP1_EXCLUSION _COLORBLENDOP1_SUBSTRACT _COLORBLENDOP1_DIVISION
			#pragma shader_feature _COLORBLENDSRC1_VALUE _COLORBLENDSRC1_ALPHABLENDOP _COLORBLENDSRC1_ONEMINUSALPHABLENDOP _COLORBLENDSRC1_BASEALPHA _COLORBLENDSRC1_ONEMINUSBASEALPHA _COLORBLENDSRC1_BLENDALPHA _COLORBLENDSRC1_ONEMINUSBLENDALPHA _COLORBLENDSRC1_BASECOLORVALUE _COLORBLENDSRC1_ONEMINUSBASECOLORVALUE _COLORBLENDSRC1_BLENDCOLORVALUE _COLORBLENDSRC1_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _ALPHABLENDOP1_NONE _ALPHABLENDOP1_OVERRIDE _ALPHABLENDOP1_MULTIPLY _ALPHABLENDOP1_ADD _ALPHABLENDOP1_SUBSTRACT _ALPHABLENDOP1_REVERSESUBSTRACT _ALPHABLENDOP1_OFFSET _ALPHABLENDOP1_MAXIMUM
			#pragma shader_feature _COLORBLENDOP2_NONE _COLORBLENDOP2_OVERRIDE _COLORBLENDOP2_MULTIPLY _COLORBLENDOP2_DARKEN _COLORBLENDOP2_COLORBURN _COLORBLENDOP2_LINEARBURN _COLORBLENDOP2_LIGHTEN _COLORBLENDOP2_SCREEN _COLORBLENDOP2_COLORDODGE _COLORBLENDOP2_LINEARDODGE _COLORBLENDOP2_OVERLAY _COLORBLENDOP2_HARDLIGHT _COLORBLENDOP2_VIVIDLIGHT _COLORBLENDOP2_LINEARLIGHT _COLORBLENDOP2_PINLIGHT _COLORBLENDOP2_HARDMIX _COLORBLENDOP2_DIFFERENCE _COLORBLENDOP2_EXCLUSION _COLORBLENDOP2_SUBSTRACT _COLORBLENDOP2_DIVISION
			#pragma shader_feature _COLORBLENDSRC2_VALUE _COLORBLENDSRC2_ALPHABLENDOP _COLORBLENDSRC2_ONEMINUSALPHABLENDOP _COLORBLENDSRC2_BASEALPHA _COLORBLENDSRC2_ONEMINUSBASEALPHA _COLORBLENDSRC2_BLENDALPHA _COLORBLENDSRC2_ONEMINUSBLENDALPHA _COLORBLENDSRC2_BASECOLORVALUE _COLORBLENDSRC2_ONEMINUSBASECOLORVALUE _COLORBLENDSRC2_BLENDCOLORVALUE _COLORBLENDSRC2_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _ALPHABLENDOP2_NONE _ALPHABLENDOP2_OVERRIDE _ALPHABLENDOP2_MULTIPLY _ALPHABLENDOP2_ADD _ALPHABLENDOP2_SUBSTRACT _ALPHABLENDOP2_REVERSESUBSTRACT _ALPHABLENDOP2_OFFSET _ALPHABLENDOP2_MAXIMUM
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _ _CD_COLORBLENDRATIO1_ON
			#pragma shader_feature _ _CD_ALPHABLENDRATIO1_ON
			#pragma shader_feature _ _CD_COLORBLENDRATIO2_ON
			#pragma shader_feature _ _CD_ALPHABLENDRATIO2_ON
			#pragma shader_feature _ _BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Includes/Blend.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _MultiTex;
			uniform float4 _MultiTex_ST;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _Color);
				UNITY_DEFINE_INSTANCED_PROP( float, _ColorBlendRatio1);
				UNITY_DEFINE_INSTANCED_PROP( float, _AlphaBlendRatio1);
				UNITY_DEFINE_INSTANCED_PROP( float, _ColorBlendRatio2);
				UNITY_DEFINE_INSTANCED_PROP( float, _AlphaBlendRatio2);
			#if _BLENDFACTOR_ON
	        	UNITY_DEFINE_INSTANCED_PROP( fixed4, _RS_BlendFactor)
	        #endif
            UNITY_INSTANCING_BUFFER_END( Props)
        	
			struct VertexInput
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 uv0 : TEXCOORD0;
			#if defined(_CD_COLORBLENDRATIO2_ON) || defined(_CD_ALPHABLENDRATIO2_ON)
				float2 uv1 : TEXCOORD1;
			#endif
			#if !_VERTEXCOLORBLENDOP_NONE
				fixed4 vertexColor : COLOR;
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
			#if !_VERTEXCOLORBLENDOP_NONE
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
				o.uv0.zw = TRANSFORM_TEX( v.uv0.xy, _MultiTex);
			#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON)
				o.uv1.xy = v.uv0.zw;
			#endif
			#if defined(_CD_COLORBLENDRATIO2_ON) || defined(_CD_ALPHABLENDRATIO2_ON)
				o.uv1.zw = v.uv1.xy;
			#endif
			#if !_VERTEXCOLORBLENDOP_NONE
				o.vertexColor = v.vertexColor;
			#endif
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				fixed4 color = tex2D( _MainTex, i.uv0.xy);
				fixed4 value1 = tex2D( _MultiTex, i.uv0.zw);
				fixed4 value2 = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float colorBlendRatio1 = UNITY_ACCESS_INSTANCED_PROP( Props, _ColorBlendRatio1);
				float alphaBlendRatio1 = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaBlendRatio1);
				float colorBlendRatio2 = UNITY_ACCESS_INSTANCED_PROP( Props, _ColorBlendRatio2);
				float alphaBlendRatio2 = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaBlendRatio2);
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
				color = Blending1( color, value1, colorBlendRatio1, alphaBlendRatio1);
				color = Blending2( color, value2, colorBlendRatio2, alphaBlendRatio2);
			#if !_VERTEXCOLORBLENDOP_NONE
				color.a *= i.vertexColor.a;
				color.rgb = VertexColorBlending( color.rgb, i.vertexColor.rgb, 1.0);
			#endif
			#if _BLENDFACTOR_ON
				color.rgb = (color.rgb * color.a) + (UNITY_ACCESS_INSTANCED_PROP( Props, _RS_BlendFactor) * (1.0 - color.a));
			#endif
				return color;
			}
			ENDCG
		}
	}
	Fallback Off
	CustomEditor "ZanLibShaderBlends"
}
