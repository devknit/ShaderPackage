﻿Shader "ZanLib/Unlit/Procedural/Ring"
{
	Properties
	{
		[Header(Color Blending Properties)]
		_Color( "Base Color", Color) = ( 1,1,1,1)
		
		[Header(Vertex Color Blending Properties)]
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_VERTEXCOLORBLENDSRC( "Vertex Color Blend Ratop Source", float) = 1
		_VertexColorBlendRatio( "Vertex Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Offset, Maximum)]
		_VERTEXALPHABLENDOP( "Vertex Alpha Blend Op", float) = 2
		_VertexAlphaBlendRatio( "Vertex Alpha Blend Ratio Value", float) = 1.0
		
		[Header(Ring Properties)]
		_CircleRadius( "Circle Radius", Range( 0, 4)) = 1.0
		_RingSize( "Ring Size", Range( 0, 2)) = 0.5
		_SmoothEdges( "Smooth Edges", Range( 0, 1)) = 0.02
		[Toggle] _FASTMODE( "Fast Mode (non-linear)", float) = 1
		
		/* Use Custom Datas */
		[Header(Custom Datas)]
		[Toggle] _CD_CIRCLERADIUS( "Circle Radius *= (TEXCORD0.z)", float) = 0
		[Toggle] _CD_RINGSIZE( "Ring Size *= (TEXCORD0.w)", float) = 0
		
		/* Rendering Status */
		[Header(Rendering Status)]
		[Enum( UnityEngine.Rendering.CullMode)]
		_RS_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_RS_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_RS_ZTest( "ZTest", float) = 8	/* Always */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_RS_ColorMask( "<!>Colro Mask (deprecated for mobile)", float) = 15 /* RGBA */
		[Toggle]
		_ALPHACLIP( "<!>Alpha Clip (deprecated for mobile)", float) = 0
		
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
			#pragma shader_feature _ _FASTMODE_ON
			#pragma shader_feature _ _CD_CIRCLERADIUS_ON
			#pragma shader_feature _ _CD_RINGSIZE_ON
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _VERTEXCOLORBLENDSRC_VALUE _VERTEXCOLORBLENDSRC_ALPHABLENDOP _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP _VERTEXCOLORBLENDSRC_BASEALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA _VERTEXCOLORBLENDSRC_BLENDALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA _VERTEXCOLORBLENDSRC_BASECOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _VERTEXALPHABLENDOP_NONE _VERTEXALPHABLENDOP_OVERRIDE _VERTEXALPHABLENDOP_MULTIPLY _VERTEXALPHABLENDOP_ADD _VERTEXALPHABLENDOP_SUBSTRACT _VERTEXALPHABLENDOP_REVERSESUBSTRACT _VERTEXALPHABLENDOP_OFFSET _VERTEXALPHABLENDOP_MAXIMUM
			#pragma shader_feature _ _ALPHACLIP_ON
			#pragma shader_feature _ _BLENDFACTOR_ON
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
	        #if defined(_BLENDFACTOR_ON)
	        	UNITY_DEFINE_INSTANCED_PROP( fixed4, _RS_BlendFactor)
			#endif    
            UNITY_INSTANCING_BUFFER_END( Props)
			
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
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				float vertexColorBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _VertexColorBlendRatio);
			#else
				float vertexColorBlendRatio = 0.0;
			#endif
			#if !defined(_VERTEXALPHABLENDOP_NONE)
				float vertexAlphaBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _VertexAlphaBlendRatio);
			#else
				float vertexAlphaBlendRatio = 0.0;
			#endif
				color = VertexColorBlending( color, i.vertexColor, vertexColorBlendRatio, vertexAlphaBlendRatio);
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
				clip( color.a - 1e-4);
			#endif
			#if defined(_BLENDFACTOR_ON)
				color.rgb = (color.rgb * color.a) + (UNITY_ACCESS_INSTANCED_PROP( Props, _RS_BlendFactor) * (1.0 - color.a));
			#endif
				return color;
			}
			ENDCG
		}
	}
	Fallback Off
	CustomEditor "ZanShader.InspectorGUI"
}
