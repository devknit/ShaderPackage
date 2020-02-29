Shader "Zan/Unlit/GrabMapDistortionNormal"
{
	Properties
	{
		[Caption(Distortion Map Properties)]
		_DistortionTex( "Distortion (Normal.xy)", 2D) = "bump" {}
		_DistortionVolume( "Distortion Volume", float) = 1
		
		[Caption(Multi Map Blending Properties)]
		_MainTex( "Blend Map", 2D) = "white" {}
		[Vector2x2(Input, Output, Min, Max)]
		_MainTexAlphaRemap( "Blend Map Alpha Remap Param", Vector) = (0.0, 1.0, 0.0, 1.0)
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP1( "Multi Map Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC1( "Multi Map Color Blend Ratop Source", float) = 0
		_ColorBlendRatio1( "Multi Map Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Offset, Maximum)]
		_ALPHABLENDOP1( "Multi Map Alpha Blend Op", float) = 2
		_AlphaBlendRatio1( "Multi Map Alpha Blend Ratio Value", float) = 1.0
		[EdgeToggle] _MULTIMAPDISTORTION( "Multi Map Distortion", float) = 0
		
		[Caption(Vertex Color Blending Properties)]
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_VERTEXCOLORBLENDSRC( "Vertex Color Blend Ratop Source", float) = 1
		_VertexColorBlendRatio( "Vertex Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Offset, Maximum)]
		_VERTEXALPHABLENDOP( "Vertex Alpha Blend Op", float) = 2
		_VertexAlphaBlendRatio( "Vertex Alpha Blend Ratio Value", float) = 1.0
		
		/* Use Custom Data */
		[Caption(Use Custom Data)]
		[EdgeToggle] _CD_COLORBLENDRATIO1( "Multi Map Color Blend Ratio Value *= (TEXCORD0.z)", float) = 0
		[EdgeToggle] _CD_ALPHABLENDRATIO1( "Multi Map Alpha Blend Ratio Value *= (TEXCORD0.w)", float) = 0
		[EdgeToggle] _CD_DISTORTIONCUSTOM( "Distortion Volume *= (TEXCORD1.x)", float) = 0
		
		/* Rendering Status */
		[Caption(Rendering Status)]
		[Enum( UnityEngine.Rendering.CullMode)]
		_RS_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_RS_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_RS_ZTest( "ZTest", float) = 8	/* Always */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_RS_ColorMask( "Color Mask", float) = 15 /* RGBA */
		[EdgeToggle] _ALPHACLIP( "Alpha Clip", float) = 0
		
		/* Blending Status */
		[Caption(Blending Status)]
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
		[EdgeToggle] _BLENDFACTOR( "Use Blend Factor", float) = 0
		
		/* Depth Stencil Status */
		[Caption(Depth Stencil Status)]
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
		GrabPass
		{
			"_GrabPassTexture"
		}
		Pass
		{
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
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature _COLORBLENDOP1_NONE _COLORBLENDOP1_OVERRIDE _COLORBLENDOP1_MULTIPLY _COLORBLENDOP1_DARKEN _COLORBLENDOP1_COLORBURN _COLORBLENDOP1_LINEARBURN _COLORBLENDOP1_LIGHTEN _COLORBLENDOP1_SCREEN _COLORBLENDOP1_COLORDODGE _COLORBLENDOP1_LINEARDODGE _COLORBLENDOP1_OVERLAY _COLORBLENDOP1_HARDLIGHT _COLORBLENDOP1_VIVIDLIGHT _COLORBLENDOP1_LINEARLIGHT _COLORBLENDOP1_PINLIGHT _COLORBLENDOP1_HARDMIX _COLORBLENDOP1_DIFFERENCE _COLORBLENDOP1_EXCLUSION _COLORBLENDOP1_SUBSTRACT _COLORBLENDOP1_DIVISION
			#pragma shader_feature _COLORBLENDSRC1_VALUE _COLORBLENDSRC1_ALPHABLENDOP _COLORBLENDSRC1_ONEMINUSALPHABLENDOP _COLORBLENDSRC1_BASEALPHA _COLORBLENDSRC1_ONEMINUSBASEALPHA _COLORBLENDSRC1_BLENDALPHA _COLORBLENDSRC1_ONEMINUSBLENDALPHA _COLORBLENDSRC1_BASECOLORVALUE _COLORBLENDSRC1_ONEMINUSBASECOLORVALUE _COLORBLENDSRC1_BLENDCOLORVALUE _COLORBLENDSRC1_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _ALPHABLENDOP1_NONE _ALPHABLENDOP1_OVERRIDE _ALPHABLENDOP1_MULTIPLY _ALPHABLENDOP1_ADD _ALPHABLENDOP1_SUBSTRACT _ALPHABLENDOP1_REVERSESUBSTRACT _ALPHABLENDOP1_OFFSET _ALPHABLENDOP1_MAXIMUM
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _VERTEXCOLORBLENDSRC_VALUE _VERTEXCOLORBLENDSRC_ALPHABLENDOP _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP _VERTEXCOLORBLENDSRC_BASEALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA _VERTEXCOLORBLENDSRC_BLENDALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA _VERTEXCOLORBLENDSRC_BASECOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _VERTEXALPHABLENDOP_NONE _VERTEXALPHABLENDOP_OVERRIDE _VERTEXALPHABLENDOP_MULTIPLY _VERTEXALPHABLENDOP_ADD _VERTEXALPHABLENDOP_SUBSTRACT _VERTEXALPHABLENDOP_REVERSESUBSTRACT _VERTEXALPHABLENDOP_OFFSET _VERTEXALPHABLENDOP_MAXIMUM
			#pragma shader_feature _ _MULTIMAPDISTORTION_ON
			#pragma shader_feature _ _CD_COLORBLENDRATIO1_ON
			#pragma shader_feature _ _CD_ALPHABLENDRATIO1_ON
			#pragma shader_feature _ _CD_DISTORTIONCUSTOM_ON
			#pragma shader_feature _ _ALPHACLIP_ON
			#pragma shader_feature _ _BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "Includes/Blend.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _DistortionTex;
			uniform float4 _DistortionTex_ST;
			uniform sampler2D _GrabPassTexture;
		
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _MainTexAlphaRemap)
				UNITY_DEFINE_INSTANCED_PROP( float,  _ColorBlendRatio1)
				UNITY_DEFINE_INSTANCED_PROP( float,  _AlphaBlendRatio1)
				UNITY_DEFINE_INSTANCED_PROP( float, _DistortionVolume)
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
			#if defined(_CD_DISTORTIONCUSTOM_ON)
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
			#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON) || defined(_CD_DISTORTIONCUSTOM_ON)
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
			#if defined(_CD_COLORBLENDRATIO1_ON) || defined(_CD_ALPHABLENDRATIO1_ON)
				o.uv2.xy = v.uv0.zw;
			#endif
			#if defined(_CD_DISTORTIONCUSTOM_ON)
				o.uv2.z = v.uv1.x;
			#endif
			#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)
				o.vertexColor = v.vertexColor;
			#endif
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				fixed3 distortion = UnpackNormal( tex2D( _DistortionTex, i.uv0.zw));
				float volume = UNITY_ACCESS_INSTANCED_PROP( Props, _DistortionVolume);
			#if defined(_CD_DISTORTIONCUSTOM_ON)
				volume *= i.uv2.z;
			#endif
				distortion.xy *= volume;
			#if _MULTIMAPDISTORTION_ON
				i.uv0.xy += distortion.xy; 
			#endif
				fixed4 value = tex2D( _MainTex, i.uv0.xy);
				float colorBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _ColorBlendRatio1);
				float alphaBlendRatio = UNITY_ACCESS_INSTANCED_PROP( Props, _AlphaBlendRatio1);
			#if defined(_CD_COLORBLENDRATIO1_ON)
				colorBlendRatio *= i.uv2.x;
			#endif
			#if defined(_CD_ALPHABLENDRATIO1_ON)
				alphaBlendRatio *= i.uv2.y;
			#endif
				value.a = remap( value.a, UNITY_ACCESS_INSTANCED_PROP( Props, _MainTexAlphaRemap));
				fixed4 color = tex2D( _GrabPassTexture, (i.uv1.xy / i.uv1.w) + distortion.xy);
				color = Blending1( color, value, colorBlendRatio, alphaBlendRatio);
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
	CustomEditor "ZanShader.Editor.InspectorGUI"
}
