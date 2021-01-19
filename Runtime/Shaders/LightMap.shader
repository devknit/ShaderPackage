Shader "Zan/Unlit/LightMap"
{
	Properties
	{
		[Caption(Base Map Properties)]
		_MainTex( "Base Map", 2D) = "white" {}
		
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
		[Toggle] _DITHERING( "Use Dithering", float) = 0
		
		/* Blending Status */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_ColorBlendOp( "Color Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_ColorSrcFactor( "Color Src Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_ColorDstFactor( "Color Dst Factor", float) = 0 /* Zero */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_AlphaBlendOp( "Alpha Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_AlphaSrcFactor( "Alpha Src Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_AlphaDstFactor( "Alpha Dst Factor", float) = 0 /* Zero */
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
			"Queue" = "Geometry"
			"RenderType"="Opaque"
		}
		Pass
		{
			Name "VertexLM"
			Tags
			{
				"LightMode" = "VertexLM"
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
			#pragma shader_feature_local _ _ALPHACLIP_ON
			#pragma shader_feature_local _ _DITHERING_ON
			#pragma shader_feature_local _ _PREBLEND_ON
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
		#if defined(_DITHERING_ON)
			uniform sampler3D _DitherMaskLOD;
		#endif
		#if defined(_ALPHACLIP_ON)
			uniform half _AlphaClipThreshold;
		#endif
		#if defined(_PREBLEND_ON)
			uniform fixed4 _PreBlendColor;
		#endif
			
			struct VertexInput
			{
				float4 vertex : POSITION;
				fixed4 vertexColor : COLOR;
				float2 texcoord0 : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct VertexOutput
			{
				float4 position : SV_POSITION;
				fixed4 vertexColor : COLOR;
				float2 texcoord0 : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			#if defined(_DITHERING_ON)
				float4 screenPosition : TEXCOORD2;
				UNITY_FOG_COORDS( 3)
			#else
				UNITY_FOG_COORDS( 2)
			#endif
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				o.position = UnityObjectToClipPos( v.vertex);
				o.texcoord0 = TRANSFORM_TEX( v.texcoord0, _MainTex);
				o.texcoord1 = v.texcoord1 * unity_LightmapST.xy + unity_LightmapST.zw;
			#if defined(_DITHERING_ON) || defined(_ALPHACLIP_ON)
				o.vertexColor.rgb = v.vertexColor.rgb;
				o.vertexColor.a = (v.vertexColor.a > 0.0)? v.vertexColor.a + 1e-4 : v.vertexColor.a;
			#else
				o.vertexColor = v.vertexColor;
			#endif
			#if defined(_DITHERING_ON)
				o.screenPosition = ComputeScreenPos( o.position);
			#endif
				UNITY_TRANSFER_FOG( o, o.position);
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				fixed4 color = saturate( tex2D( _MainTex, i.texcoord0) * i.vertexColor);
			#if defined(_DITHERING_ON)
				color.a = tex3D( _DitherMaskLOD, float3( 
					i.screenPosition.xy / i.screenPosition.w * _ScreenParams.xy * 0.25, color.a * 0.9375)).a;
			#endif
			#if defined(_ALPHACLIP_ON)
				clip( color.a - _AlphaClipThreshold - 1e-4);
			#endif
				color.rgb *= DecodeLightmap( UNITY_SAMPLE_TEX2D( unity_Lightmap, i.texcoord1));
				UNITY_APPLY_FOG( i.fogCoord, color);
			#if defined(_PREBLEND_ON)
				color.rgb = (color.rgb * color.a) + (_PreBlendColor * (1.0 - color.a));
			#endif
				return color;
			}
			ENDCG
		}
	}
	Fallback Off
	CustomEditor "Shaders.Editor.InspectorGUI"
}
