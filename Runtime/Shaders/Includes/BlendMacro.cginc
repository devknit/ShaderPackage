
#ifndef __BLENDMACRO_CGINC__
#define __BLENDMACRO_CGINC__

#include "Blend.cginc"

#if !defined(_VERTEXCOLORBLENDOP_NONE) || !defined(_VERTEXALPHABLENDOP_NONE)	
	inline fixed4 VertexColorBlending( fixed4 baseColor, fixed4 vertexColor)
	{
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
		return VertexColorBlending( baseColor, vertexColor, vertexColorBlendRatio, vertexAlphaBlendRatio);
	}
#endif

#endif /* __BLENDMACRO_CGINC__ */
