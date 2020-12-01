Shader "Zan/UI/Default"
{
	Properties
	{
		[PerRendererData] _MainTex( "Sprite Texture", 2D) = "white" {}
		[HDR] _Color( "Blend Color", Color) = ( 1,1,1,1)
		
		[Enum( UnityEngine.Rendering.CullMode)]
		_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_ColorMask( "Color Mask", float) = 15 /* RGBA */
		
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
		_StencilComp( "Stencil Comparison Function", float) = 8	/* Always */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilOp( "Stencil Pass Operation", float) = 0 /* Keep */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilFailOp( "Stencil Fail Operation", float) = 0 /* Keep */
		[Enum( UnityEngine.Rendering.StencilOp)]
		_StencilZFailOp( "Stencil ZFail Operation", float) = 0 /* Keep */
		
		[Toggle(UNITY_UI_ALPHACLIP)]
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
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
		Lighting Off
		Cull [_Cull]
        ZWrite [_ZWrite]
        ZTest [unity_GUIZTestMode]
		BlendOp [_ColorBlendOp], [_AlphaBlendOp]
		Blend [_ColorSrcFactor] [_ColorDstFactor], [_AlphaSrcFactor] [_AlphaDstFactor]
		ColorMask [_ColorMask]
		
		Pass
		{
			Name "Default"
			
			CGPROGRAM
			#pragma target 2.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_local _ UNITY_UI_CLIP_RECT
			#pragma multi_compile_local _ UNITY_UI_ALPHACLIP
			#include "UnityCG.cginc"
			#include "UnityUI.cginc"
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _ClipRect;
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			
			struct VertexInput
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOutput
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_OUTPUT_STEREO
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o);
				o.worldPosition = v.vertex;
				o.vertex = UnityObjectToClipPos( o.worldPosition);
				o.texcoord = TRANSFORM_TEX( v.texcoord, _MainTex);
				o.color = v.color * _Color;
			}
			fixed4 frag( VertexOutput i) : COLOR
			{
				half4 color = (tex2D( _MainTex, i.texcoord) + _TextureSampleAdd) * i.color;
			#ifdef UNITY_UI_CLIP_RECT
				color.a *= UnityGet2DClipping( i.worldPosition.xy, _ClipRect);
			#endif
			#ifdef UNITY_UI_ALPHACLIP
				clip( color.a - 0.001);
			#endif
				return color;
			}
			ENDCG
		}
	}
	Fallback Off
}
