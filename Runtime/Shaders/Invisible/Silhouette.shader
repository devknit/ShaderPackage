Shader "Zan/Invisible/Silhouette"
{
	Properties
	{
		/* Rendering Status */
		[Enum( UnityEngine.Rendering.CullMode)]
		_Cull( "Cull", float) = 0 /* Off */
		[Enum(Off, 0, On, 1)]
		_ZWrite( "ZWrite", float) = 0 /* Off */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_ZTest( "ZTest", float) = 8	/* Always */
		
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
			"Queue" = "AlphaTest+50"
		}
		Pass
		{
			Lighting Off
			Cull [_Cull]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			BlendOp Add
			Blend Zero One
			
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
			#include "UnityCG.cginc"
			
			struct VertexInput
			{
				float4 vertex : POSITION;
			};
			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
			};
			void vert( VertexInput v, out VertexOutput o)
			{
				o.vertex = UnityObjectToClipPos( v.vertex);
			}
			fixed4 frag( VertexOutput i) : SV_Target
			{
				return fixed4( 0, 0, 0, 0);
			}
			ENDCG
		}
	}
	Fallback Off
}
