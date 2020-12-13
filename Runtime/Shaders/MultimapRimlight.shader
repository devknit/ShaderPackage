Shader "Zan/MultimapRimlight"
{
	Properties
	{
		[Caption(Base Map Properties)]
		_MainTex( "Base Map", 2D) = "black" {}
		_MultiTex( "Blend Map", 2D) = "black" {}
		[Vector2x2(Base Map, Blend Map)] _ScrollSpeed( "Scroll Speed", Vector) = (1, 1, 1, 1)
		[HDR] _Color( "Tint Color", Color) = (1, 1, 1, 1)
		
		[Caption(Rim Lighting Properties)]
		[HDR] _RimColor( "Rim Color", Color) = (1, 1, 1, 1)
		[KeywordEnum(Override, Multiply, Minimum, Maximum)]
		_RIMALPHA( "Rim Alpha", float) = 0
		_RimPower( "Fresnel Power", Range( 0.0, 5.0)) = 2.0
		
		[Caption(Depth Intersection Properties)]
		[Toggle] _DEPTHINTERSECTION( "Intersection Emissive", float) = 0.0
		_IntersectionThreshold( "Intersection Threshold", Range( 0, 5.0)) = 1.0
		
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
		[Caption(Depth Stencil Status)]
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
			#pragma shader_feature_local _RIMALPHA_OVERRIDE _RIMALPHA_MULTIPLY _RIMALPHA_MINIMUM _RIMALPHA_MAXIMUM
			#pragma shader_feature_local _ _DEPTHINTERSECTION_ON
			#pragma shader_feature_local _ _ALPHACLIP_ON
			#pragma shader_feature_local _ _PREBLEND_ON
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				fixed4 vertexColor : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOutput
			{
				float4 position : SV_POSITION;
				float4 uv0 : TEXCOORD0;
				float3 normalDirection : TEXCOORD1;
				float3 viewDirection : TEXCOORD2;
			#if defined(_DEPTHINTERSECTION_ON)
				float4 screenUV : TEXCOORD3;
			#endif
				fixed4 vertexColor : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MultiTex;
			float4 _MultiTex_ST;
		#if defined(_DEPTHINTERSECTION_ON)
			sampler2D _CameraDepthTexture;
		#endif
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _ScrollSpeed)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( fixed4, _RimColor)
				UNITY_DEFINE_INSTANCED_PROP( float,  _RimPower)
			#if defined(_DEPTHINTERSECTION_ON)
				UNITY_DEFINE_INSTANCED_PROP( float,  _IntersectionThreshold)
			#endif
			#if defined(_ALPHACLIP_ON)
				UNITY_DEFINE_INSTANCED_PROP( float,  _AlphaClipThreshold)
			#endif
			#if _PREBLEND_ON
	        	UNITY_DEFINE_INSTANCED_PROP( fixed4, _PreBlendColor)
	        #endif
			UNITY_INSTANCING_BUFFER_END( Props)

			void vert( VertexInput v, out VertexOutput o)
			{
				o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v);
                UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.position = UnityObjectToClipPos( v.vertex);
				o.normalDirection = normalize( UnityObjectToWorldNormal( v.normal));
				o.viewDirection = normalize( _WorldSpaceCameraPos.xyz - mul( unity_ObjectToWorld, v.vertex).xyz);
				o.uv0.xy = TRANSFORM_TEX( v.texcoord0, _MainTex);
				o.uv0.zw = TRANSFORM_TEX( v.texcoord0, _MultiTex);
			#if defined(_DEPTHINTERSECTION_ON)
				o.screenUV = ComputeScreenPos( o.position);
				COMPUTE_EYEDEPTH( o.screenUV.z);
			#endif
				o.vertexColor = v.vertexColor;
			}
			fixed4 frag( VertexOutput i, fixed facing : VFACE) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( i);
				
			#if defined(_DEPTHINTERSECTION_ON)
				fixed depth = LinearEyeDepth( tex2Dproj( _CameraDepthTexture, i.screenUV).r);
				half threshold = 1e-4 + UNITY_ACCESS_INSTANCED_PROP( Props, _IntersectionThreshold);
				fixed intersect = 1.0 - saturate( (abs( depth - i.screenUV.z)) / threshold);
			#else
				fixed intersect = 0.0;
			#endif
				i.uv0 += _Time.y * UNITY_ACCESS_INSTANCED_PROP( Props, _ScrollSpeed);
				fixed4 color = max( tex2D( _MainTex, i.uv0.xy), tex2D( _MultiTex, i.uv0.zw)) * UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				
				fixed4 rimColor = UNITY_ACCESS_INSTANCED_PROP( Props, _RimColor);
				half rimPower = UNITY_ACCESS_INSTANCED_PROP( Props, _RimPower);
				
				half VdotN = saturate( dot( i.viewDirection, i.normalDirection * (facing >= 0 ? 1.0 : -1.0)));
				half volume = max( 1.0 - VdotN, intersect);
				fixed emissive = pow( volume, rimPower) * rimColor.a;
				color.rgb += rimColor * emissive;
			#if defined(_RIMALPHA_OVERRIDE)
				color.a = emissive;
			#elif defined(_RIMALPHA_MULTIPLY)
				color.a = ( color.a * emissive);
			#elif defined(_RIMALPHA_MINIMUM)
				color.a = min( color.a, emissive);
			#elif defined(_RIMALPHA_MAXIMUM)
				color.a = max( color.a, emissive);
			#endif
				color = max( 0, color) * i.vertexColor;
				
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
	CustomEditor "ZanShader.Editor.InspectorGUI"
}
