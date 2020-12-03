Shader "Zan/Hidden/Shape"
{
	Properties
	{
		[Enum( UnityEngine.Rendering.CullMode)]
		_RS_Cull( "Cull", float) = 2 /* Back */
		[Enum(Off, 0, On, 1)]
		_RS_ZWrite( "ZWrite", float) = 1 /* On */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_RS_ZTest( "ZTest", float) = 2	/* Less */
		
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
			"Queue" = "AlphaTest+50"
		}
		Pass
		{
			Lighting Off
			Cull [_RS_Cull]
			ZWrite [_RS_ZWrite]
			ZTest [_RS_ZTest]
			BlendOp Add
			Blend Zero One
			
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
