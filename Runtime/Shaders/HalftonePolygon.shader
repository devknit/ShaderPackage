Shader "ZanLib/Unlit/HalftonePolygon"
{
	Properties
	{
		/* Shader Properties */
		[Header(Shader Properties)]
		_MainTex( "Base Map", 2D) = "white" {}
		
		[Header(Color Blending Properties)]
		_Color( "Blend Color", Color) = ( 1,1,1,1)
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP2( "Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorSquare, OneMinusBaseColorSquare, BlendColorSquare, OneMinusBlendColorSquare)]
		_COLORBLENDSRC2( "Color Blend Ratop Source", float) = 0
		_ColorBlendRatio2( "Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Offset, Maximum)]
		_ALPHABLENDOP2( "Alpha Blend Op", float) = 2
		_AlphaBlendRatio2( "Alpha Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		
		[Header(Halftone Properties)]
		_HalftoneThreshold( "Halftone Threshold", Range( 0.0, 1.0)) = 0.5
		_HalftoneRotation( "Halftone UV Rotation", Range(0.0, 90.0)) = 0.0
		_HalftoneScale( "Halftone UV Scale", float) = 8.0
		_HalftoneScaleOffset( "Halftone UV Axis Scale(xy) Offset(zw)", Vector) = (1.0, 1.0, 0.0, 0.0)
		[IntRange]
		_HalftonePolygon("Halftone Polygon", Range(3,10)) = 3
		
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
			#pragma shader_feature _COLORBLENDOP2_NONE _COLORBLENDOP2_OVERRIDE _COLORBLENDOP2_MULTIPLY _COLORBLENDOP2_DARKEN _COLORBLENDOP2_COLORBURN _COLORBLENDOP2_LINEARBURN _COLORBLENDOP2_LIGHTEN _COLORBLENDOP2_SCREEN _COLORBLENDOP2_COLORDODGE _COLORBLENDOP2_LINEARDODGE _COLORBLENDOP2_OVERLAY _COLORBLENDOP2_HARDLIGHT _COLORBLENDOP2_VIVIDLIGHT _COLORBLENDOP2_LINEARLIGHT _COLORBLENDOP2_PINLIGHT _COLORBLENDOP2_HARDMIX _COLORBLENDOP2_DIFFERENCE _COLORBLENDOP2_EXCLUSION _COLORBLENDOP2_SUBSTRACT _COLORBLENDOP2_DIVISION
			#pragma shader_feature _COLORBLENDSRC2_VALUE _COLORBLENDSRC2_ALPHABLENDOP _COLORBLENDSRC2_ONEMINUSALPHABLENDOP _COLORBLENDSRC2_BASEALPHA _COLORBLENDSRC2_ONEMINUSBASEALPHA _COLORBLENDSRC2_BLENDALPHA _COLORBLENDSRC2_ONEMINUSBLENDALPHA _COLORBLENDSRC2_BASECOLORSQUARE _COLORBLENDSRC2_ONEMINUSBASECOLORSQUARE _COLORBLENDSRC2_BLENDCOLORSQUARE _COLORBLENDSRC2_ONEMINUSBLENDCOLORSQUARE
			#pragma shader_feature _ALPHABLENDOP2_NONE _ALPHABLENDOP2_OVERRIDE _ALPHABLENDOP2_MULTIPLY _ALPHABLENDOP2_ADD _ALPHABLENDOP2_SUBSTRACT _ALPHABLENDOP2_REVERSESUBSTRACT _ALPHABLENDOP2_OFFSET _ALPHABLENDOP2_MAXIMUM
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _ _BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Includes/Blend.cginc"
			#include "Includes/Procedural.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler3D _DitherMaskLOD;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( float, _ColorBlendRatio2)
				UNITY_DEFINE_INSTANCED_PROP( float, _AlphaBlendRatio2)
				UNITY_DEFINE_INSTANCED_PROP( float, _HalftoneThreshold)
				UNITY_DEFINE_INSTANCED_PROP( float, _HalftoneRotation);
				UNITY_DEFINE_INSTANCED_PROP( float, _HalftoneScale)
				UNITY_DEFINE_INSTANCED_PROP( float4, _HalftoneScaleOffset)
				UNITY_DEFINE_INSTANCED_PROP( int, _HalftonePolygon)
			#if defined(_BLENDFACTOR_ON)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _RS_BlendFactor)
			#endif
			UNITY_INSTANCING_BUFFER_END( Props)
			
			struct VertexInput
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float2 uv0 : TEXCOORD0;
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				fixed4 vertexColor : COLOR;
			#endif
			};
			struct VertexOutput
			{
				float4 position : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 uv0 : TEXCOORD0;
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				fixed4 vertexColor : COLOR;
			#endif
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.position = UnityObjectToClipPos( v.vertex);
				o.uv0.xy = TRANSFORM_TEX( v.uv0, _MainTex);
				o.uv0.zw = sincos( radians( UNITY_ACCESS_INSTANCED_PROP( Props, _HalftoneRotation)));
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				o.vertexColor = v.vertexColor;
			#endif
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				fixed4 color = tex2D( _MainTex, i.uv0);
				fixed4 value = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float colorBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _ColorBlendRatio2);
				float alphaBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaBlendRatio2);
				color = Blending2( color, value, colorBlendRatio, alphaBlendRatio);
				
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				color.a *= i.vertexColor.a;
				color.rgb = VertexColorBlending( color.rgb, i.vertexColor.rgb, 1.0);
			#endif
				float halftoneThreshold = UNITY_ACCESS_INSTANCED_PROP( Props, _HalftoneThreshold);
				float halftoneScale = UNITY_ACCESS_INSTANCED_PROP( Props, _HalftoneScale);
				float4 halftoneScaleOffset = UNITY_ACCESS_INSTANCED_PROP( Props, _HalftoneScaleOffset);
				float halftonePolygon = UNITY_ACCESS_INSTANCED_PROP( Props, _HalftonePolygon);

				float2 uv = ((i.position.xy / _ScreenParams.xy) - 0.5) * halftoneScale;
				uv.x *= _ScreenParams.x / _ScreenParams.y;
				uv = rotation( uv, i.uv0.zw) * halftoneScaleOffset.xy + halftoneScaleOffset.zw;
				uv = frac( uv) - 0.5;

				float a = atan2(uv.x,uv.y) + 3.141592;
				float r = 6.283185 / _HalftonePolygon;
				color.a = 1.0 - step( halftoneThreshold, pow( cos( floor(0.5 + a / r) * r - a) * length(uv), color.a));
			#if defined(_BLENDFACTOR_ON)
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
