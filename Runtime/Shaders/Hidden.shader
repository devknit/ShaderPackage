Shader "Zan/Hidden"
{
	SubShader
	{
		Tags
		{
			"Queue" = "AlphaTest+50"
		}
		Pass
		{
			Lighting Off
			Cull Back
			ZWrite Off
			ZTest Always
			BlendOp Add
			Blend Zero One
			
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
				o.vertex = v.vertex;
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
