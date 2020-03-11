
#ifndef __ZAN_MACRO_CGINC__
#define __ZAN_MACRO_CGINC__

#define TRANSFORM_TEX_INSTANCED_PROP( tex, name) (tex.xy * UNITY_ACCESS_INSTANCED_PROP( Props, name##_ST).xy + UNITY_ACCESS_INSTANCED_PROP( Props, name##_ST).zw)

#endif /* __ZAN_MACRO_CGINC__ */
