Shader "Hidden/Zan/UI/MapColor"
{
	Properties
	{
		[PerRendererData]
		_MainTex( "Base Map", 2D) = "white" {}
		[Vector2x2(Tiling, Offset, X, Y)]
		_MainTex_ST( "Base Map", Vector) = (1, 1, 0, 0)
		
		[HDR] _Color( "Blend Color", Color) = ( 1, 1, 1, 1)
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP1( "Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC1( "Color Blend Ratop Source", float) = 0
		_ColorBlendRatio1( "Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_ALPHABLENDOP1( "Alpha Blend Op", float) = 2
		_AlphaBlendRatio1( "Alpha Blend Ratio Value", float) = 1.0
		
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_VERTEXCOLORBLENDSRC( "Vertex Color Blend Ratop Source", float) = 0
		_VertexColorBlendRatio( "Vertex Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_VERTEXALPHABLENDOP( "Vertex Alpha Blend Op", float) = 2
		_VertexAlphaBlendRatio( "Vertex Alpha Blend Ratio Value", float) = 1.0
		
		[Enum( UnityEngine.Rendering.CullMode)]
		_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_ColorMask( "Color Mask", float) = 15 /* RGBA */
		
		[Toggle] _ALPHACLIP( "Use Alpha Clip", float) = 0
		_AlphaClipThreshold( "Alpha Clip Threshold", Range( 0.0, 1.0)) = 0
		
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
		
		_Stencil( "Stencil Reference", Range( 0, 255)) = 0
		_StencilReadMask( "Stencil Read Mask", Range( 0, 255)) = 255
		_StencilWriteMask( "Stencil Write Mask", Range( 0, 255)) = 255
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_StencilComp( "Stencil Compare Function", float) = 8	/* Always */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilOp( "Stencil Pass Operation", float) = 0 /* Keep */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilFailOp( "Stencil Fail Operation", float) = 0 /* Keep */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilZFailOp( "Stencil ZFail Operation", float) = 0 /* Keep */
		
		[Toggle(UNITY_UI_ALPHACLIP), HideInInspector]
		_UseUIAlphaClip ("Use Alpha Clip", Float) = 0
	}
	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		Pass
		{
			Name "Default"
			
			Lighting Off
			Cull [_Cull]
	        ZWrite [_ZWrite]
	        ZTest [unity_GUIZTestMode]
			BlendOp [_ColorBlendOp], [_AlphaBlendOp]
			Blend [_ColorSrcFactor] [_ColorDstFactor], [_AlphaSrcFactor] [_AlphaDstFactor]
			ColorMask [_ColorMask]
			
			Stencil
			{
				Ref [_Stencil]
				Comp [_StencilComp]
				Pass [_StencilOp]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
			}
			CGPROGRAM
			#pragma target 2.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature_local _COLORBLENDOP1_NONE _COLORBLENDOP1_OVERRIDE _COLORBLENDOP1_MULTIPLY _COLORBLENDOP1_DARKEN _COLORBLENDOP1_COLORBURN _COLORBLENDOP1_LINEARBURN _COLORBLENDOP1_LIGHTEN _COLORBLENDOP1_SCREEN _COLORBLENDOP1_COLORDODGE _COLORBLENDOP1_LINEARDODGE _COLORBLENDOP1_OVERLAY _COLORBLENDOP1_HARDLIGHT _COLORBLENDOP1_VIVIDLIGHT _COLORBLENDOP1_LINEARLIGHT _COLORBLENDOP1_PINLIGHT _COLORBLENDOP1_HARDMIX _COLORBLENDOP1_DIFFERENCE _COLORBLENDOP1_EXCLUSION _COLORBLENDOP1_SUBSTRACT _COLORBLENDOP1_DIVISION
			#pragma shader_feature_local _COLORBLENDSRC1_VALUE _COLORBLENDSRC1_ALPHABLENDOP _COLORBLENDSRC1_ONEMINUSALPHABLENDOP _COLORBLENDSRC1_BASEALPHA _COLORBLENDSRC1_ONEMINUSBASEALPHA _COLORBLENDSRC1_BLENDALPHA _COLORBLENDSRC1_ONEMINUSBLENDALPHA _COLORBLENDSRC1_BASECOLORVALUE _COLORBLENDSRC1_ONEMINUSBASECOLORVALUE _COLORBLENDSRC1_BLENDCOLORVALUE _COLORBLENDSRC1_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature_local _ALPHABLENDOP1_NONE _ALPHABLENDOP1_OVERRIDE _ALPHABLENDOP1_MULTIPLY _ALPHABLENDOP1_ADD _ALPHABLENDOP1_SUBSTRACT _ALPHABLENDOP1_REVERSESUBSTRACT _ALPHABLENDOP1_MAXIMUM
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _VERTEXCOLORBLENDSRC_VALUE _VERTEXCOLORBLENDSRC_ALPHABLENDOP _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP _VERTEXCOLORBLENDSRC_BASEALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA _VERTEXCOLORBLENDSRC_BLENDALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA _VERTEXCOLORBLENDSRC_BASECOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _VERTEXALPHABLENDOP_NONE _VERTEXALPHABLENDOP_OVERRIDE _VERTEXALPHABLENDOP_MULTIPLY _VERTEXALPHABLENDOP_ADD _VERTEXALPHABLENDOP_SUBSTRACT _VERTEXALPHABLENDOP_REVERSESUBSTRACT _VERTEXALPHABLENDOP_MAXIMUM
			#pragma multi_compile_local _ UNITY_UI_CLIP_RECT
			#pragma multi_compile_local _ UNITY_UI_ALPHACLIP
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityUI.cginc"
			
			sampler2D _MainTex;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _MainTex_ST)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _TextureSampleAdd)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( half,   _ColorBlendRatio1)
				UNITY_DEFINE_INSTANCED_PROP( half,   _AlphaBlendRatio1)
			#if !defined(_VERTEXCOLORBLENDOP_NONE)
				UNITY_DEFINE_INSTANCED_PROP( half,   _VertexColorBlendRatio)
			#endif
			#if !defined(_VERTEXALPHABLENDOP_NONE)
				UNITY_DEFINE_INSTANCED_PROP( half,   _VertexAlphaBlendRatio)
			#endif
			#if defined(_ALPHACLIP_ON)
				UNITY_DEFINE_INSTANCED_PROP( half,   _AlphaClipThreshold)
			#endif
			#if defined(UNITY_UI_CLIP_RECT)
				UNITY_DEFINE_INSTANCED_PROP( float4, _ClipRect)
			#endif
			UNITY_INSTANCING_BUFFER_END( Props)
			
			#include "../Includes/Blend.cginc"
			#include "../Includes/BlendMacro.cginc"
			
			struct VertexInput
			{
				float4 position : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float2 uv0 : TEXCOORD0;
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				float4 color : COLOR;
			#endif
			};
			struct VertexOutput
			{
				float4 position : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 worldPosition : TEXCOORD0;
				float2 uv0 : TEXCOORD1;
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				fixed4 color : COLOR;
			#endif
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o);
				o.worldPosition = v.position;
				o.position = UnityObjectToClipPos( o.worldPosition);
				float4 mainTexST = UNITY_ACCESS_INSTANCED_PROP( Props, _MainTex_ST);
				o.uv0.xy = v.uv0.xy * mainTexST.xy + mainTexST.zw;
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)	
				o.color = v.color;
			#endif
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				
				half4 color = tex2D( _MainTex, i.uv0) + UNITY_ACCESS_INSTANCED_PROP( Props, _TextureSampleAdd);
				half4 value = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				half colorBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _ColorBlendRatio1);
				half alphaBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaBlendRatio1);
				
				color = Blending1( color, value, colorBlendRatio, alphaBlendRatio);
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				color = VertexColorBlending( color, i.color);
			#endif
			#if defined(UNITY_UI_CLIP_RECT)
				color.a *= UnityGet2DClipping( i.worldPosition.xy, _ClipRect);
			#endif
		#if defined(_ALPHACLIP_ON) || defined(UNITY_UI_ALPHACLIP)
			#if defined(_ALPHACLIP_ON)
				float clipThreshold = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaClipThreshold) - 1e-4;
			#else
				float clipThreshold = 1e-4;
			#endif
				clip( color.a - clipThreshold);
		#endif
				return color;
			}
			ENDCG
		}
	}
	Fallback Off
	CustomEditor "Shaders.Editor.InspectorGUI"
}
