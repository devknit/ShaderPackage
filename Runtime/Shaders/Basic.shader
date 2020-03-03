
Shader "Zan/Lit/Basic"
{
	Properties
	{
		[Caption(Diffuse Properties)]
		_MainTex( "Diffuse Map", 2D) = "white" {}
		[HDR] _Color( "Diffuse Color", Color) = (1,1,1,1)
		
		[Caption(Specular Properties)]
		[KeywordEnum(BlinnPhong, Phong)]
		_REFLECTIONMODEL( "Reflection Model", float) = 0
		_Metallic( "Metallic", Range(0, 1)) = 0
		_Gloss( "Gloss", Range(0, 1)) = 0.0
		
		[Caption(Rim Lighting Properties)]
		[KeywordEnum(Off, Normal, NormalMap)]
		_RIMLIGHTTYPE( "Rim Light Type", float) = 0
		[HDR] _RimColor( "Rim Color", Color) = (1,1,1,1)
		_RimPower( "Rim Power", Range( 0, 10)) = 2.0
		
		[Caption(Normal Map Properties)]
		_NormalMap( "Normal Map", 2D) = "bump" {}
		
		[Caption(Global Illumination Properties)]
		[EdgeToggle] _GLOBALILLUMINATION( "Global Illumination", float) = 0
		
		[Caption(Shadow Properties)]
		[EdgeToggle] _SHADOWTRANSLUCENT( "Shadow Translucent", float) = 0
		
		/* Forward Base Rendering Status */
		[Caption(Rendering Status)]
		[Enum( UnityEngine.Rendering.CullMode)]
		_RS_Cull( "Cull", float) = 2 /* Back */
		[Enum(Off, 0, On, 1)]
		_RS_FB_ZWrite( "Base ZWrite", float) = 1 /* On */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_RS_FB_ZTest( "Base ZTest", float) = 2	/* Less */
		[Enum(Off, 0, On, 1)]
		_RS_FA_ZWrite( "Add ZWrite", float) = 0 /* Off */
		[Enum( UnityEngine.Rendering.CompareFunction)]
		_RS_FA_ZTest( "Add ZTest", float) = 2	/* Less */
		[Enum( Off, 0, R, 8, G, 4, B, 2, A, 1, RGB, 14, RGBA, 15)]
		_RS_ColorMask( "Color Mask", float) = 15 /* RGBA */
		[EdgeToggle] _ALPHACLIP( "Alpha Clip", float) = 0
		
		/* Forward Base Blending Status */
		[Caption(Forward Base Blending Status)]
		[Enum( UnityEngine.Rendering.BlendOp)]
		_RS_FB_ColorBlendOp( "Color Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FB_ColorSrcFactor( "Color Src Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FB_ColorDstFactor( "Color Dst Factor", float) = 0 /* Zero */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_RS_FB_AlphaBlendOp( "Alpha Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FB_AlphaSrcFactor( "Alpha Src Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FB_AlphaDstFactor( "Alpha Dst Factor", float) = 0 /* Zero */
		_RS_FB_BlendFactor( "Blend Factor", Color) = ( 0, 0, 0, 0)
		[EdgeToggle] _FB_BLENDFACTOR( "Use Blend Factor", float) = 0
		
		/* Forward Add Blending Status */
		[Caption(Forward Add Blending Status)]
		[Enum( UnityEngine.Rendering.BlendOp)]
		_RS_FA_ColorBlendOp( "Color Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FA_ColorSrcFactor( "Color Src Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FA_ColorDstFactor( "Color Dst Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendOp)]
		_RS_FA_AlphaBlendOp( "Alpha Blend Op", float) = 0 /* Add */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FA_AlphaSrcFactor( "Alpha Src Factor", float) = 1 /* One */
		[Enum( UnityEngine.Rendering.BlendMode)]
		_RS_FA_AlphaDstFactor( "Alpha Dst Factor", float) = 1 /* One */
		_RS_FA_BlendFactor( "Blend Factor", Color) = ( 0, 0, 0, 0)
		[EdgeToggle] _FA_BLENDFACTOR( "Use Blend Factor", float) = 0
	}
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}
		Pass
		{
			Name "FORWARD"
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			Cull [_RS_Cull]
			ZWrite [_RS_FB_ZWrite]
			ZTest [_RS_FB_ZTest]
			ColorMask [_RS_ColorMask]
			BlendOp [_RS_FB_ColorBlendOp], [_RS_FB_AlphaBlendOp]
			Blend [_RS_FB_ColorSrcFactor] [_RS_FB_ColorDstFactor], [_RS_FB_AlphaSrcFactor] [_RS_FB_AlphaDstFactor]
			
			CGPROGRAM
			#pragma vertex vertBase
			#pragma fragment fragBase
			#pragma multi_compile _ _GLOBALILLUMINATION_ON
			#pragma shader_feature _REFLECTIONMODEL_BLINNPHONG _REFLECTIONMODEL_PHONG
			#pragma shader_feature _RIMLIGHTTYPE_OFF _RIMLIGHTTYPE_NORMAL _RIMLIGHTTYPE_NORMALMAP
			#pragma shader_feature _ _ALPHACLIP_ON
			#pragma shader_feature _ _FB_BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( float,  _Metallic)
				UNITY_DEFINE_INSTANCED_PROP( float,  _Gloss)
			#if !defined(_RIMLIGHTTYPE_OFF)
				UNITY_DEFINE_INSTANCED_PROP( float4, _RimColor)
				UNITY_DEFINE_INSTANCED_PROP( float,  _RimPower)
			#endif
			#if defined(_BLENDFACTOR_ON)
	        	UNITY_DEFINE_INSTANCED_PROP( fixed4, _RS_FB_BlendFactor)
	        #endif
			UNITY_INSTANCING_BUFFER_END( Props)
			
			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord0 : TEXCOORD0;
			#if defined(_GLOBALILLUMINATION_ON)
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOutputBase
			{
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				float3 normalDirection : TEXCOORD2;
				float3 tangentDirection : TEXCOORD3;
				float3 bitangentDirection : TEXCOORD4;
				LIGHTING_COORDS( 5, 6)
				UNITY_FOG_COORDS( 7)
			#if defined(_GLOBALILLUMINATION_ON)
				float4 ambientOrLightmapUV : TEXCOORD10;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			inline half4 vertGI( VertexInput v, float3 posWorld, half3 normalWorld)
			{
			    half4 ambientOrLightmapUV = 0;
	    #ifdef LIGHTMAP_ON
		        ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		        ambientOrLightmapUV.zw = 0;
	    #elif UNITY_SHOULD_SAMPLE_SH
	        #ifdef VERTEXLIGHT_ON
	            ambientOrLightmapUV.rgb = Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
	                unity_LightColor[ 0].rgb, unity_LightColor[ 1].rgb, unity_LightColor[ 2].rgb, unity_LightColor[ 3].rgb,
	                unity_4LightAtten0, posWorld, normalWorld);
	        #endif
		        ambientOrLightmapUV.rgb = ShadeSHPerVertex (normalWorld, ambientOrLightmapUV.rgb);
	    #endif
		    #ifdef DYNAMICLIGHTMAP_ON
		        ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
		    #endif
			    return ambientOrLightmapUV;
			}
			float specularReflection( float3 normalDirection, float3 viewDirection, float3 lightDirection, float specularPower)
			{
			#if defined(_REFLECTIONMODEL_BLINNPHONG)
				/* Blinn-Phong */
				float3 halfDirection = normalize( viewDirection + lightDirection);
				float HdotN = saturate( dot( halfDirection, normalDirection));
				return pow( HdotN, specularPower);
			#elif defined(_REFLECTIONMODEL_PHONG)
				/* Phong */
				float3 lightReflectDirection = reflect( -lightDirection, normalDirection);
				float LdotV = saturate( dot( lightReflectDirection, viewDirection));
				return pow( LdotV, specularPower);
			#else
				return normalDirection;
			#endif
			}
			void vertBase( VertexInput v, out VertexOutputBase o)
			{
				o = (VertexOutputBase)0;
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.pos = UnityObjectToClipPos( v.vertex);
				o.uv0 = TRANSFORM_TEX( v.texcoord0.xy, _MainTex);
				o.worldPosition = mul( unity_ObjectToWorld, v.vertex);
				o.normalDirection = UnityObjectToWorldNormal( v.normal);
				o.tangentDirection = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0)).xyz);
				o.bitangentDirection = normalize( cross( o.normalDirection, o.tangentDirection) * v.tangent.w);
			#if defined(_GLOBALILLUMINATION_ON)
				o.ambientOrLightmapUV = vertGI( v, o.worldPosition, o.normalDirection);
			#endif
				UNITY_TRANSFER_FOG( o, o.pos);
				TRANSFER_VERTEX_TO_FRAGMENT( o);
				TRANSFER_SHADOW( o);
			}
			fixed4 fragBase( VertexOutputBase i, fixed facing : VFACE) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				
				float attenuation = LIGHT_ATTENUATION( i);
				float3 attenColor = attenuation * _LightColor0.rgb;
				float3 normalMap = UnpackNormal( tex2D( _NormalMap, i.uv0));
				float4 baseMap = tex2D( _MainTex, i.uv0);
				float4 baseColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float4 diffuseColor = baseMap * baseColor;
			#if defined(_ALPHACLIP_ON)
				clip( diffuseColor.a - 1e-4);
			#endif
				
				float3 preNormalDirection = normalize( i.normalDirection * (facing >= 0 ? 1.0 : -1.0));
				float3x3 tangentTransform = float3x3( i.tangentDirection, i.bitangentDirection, preNormalDirection);
				float3 normalDirection = normalize( mul( normalMap, tangentTransform));
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.worldPosition.xyz);
				float3 viewReflectDirection = reflect( -viewDirection, normalDirection);
				float3 lightDirection = normalize( _WorldSpaceLightPos0.xyz);
				
				/* gloss */
				float gloss = UNITY_ACCESS_INSTANCED_PROP( Props, _Gloss);
				float specPow = exp2( gloss * 10.0 + 1.0);
				
				/* global illumination */
		#if defined(_GLOBALILLUMINATION_ON)
				UnityLight light;
			#ifdef LIGHTMAP_OFF
				light.color = _LightColor0.rgb;
				light.dir = lightDirection;
				light.ndotl = LambertTerm( normalDirection, lightDirection);
			#else
				light.color = half3( 0.0f, 0.0f, 0.0f);
				light.ndotl = 0.0f;
				light.dir = half3( 0.0f, 0.0f, 0.0f);
			#endif
				UnityGIInput data;
				data.light = light;
				data.worldPos = i.worldPosition.xyz;
				data.worldViewDir = viewDirection;
				data.atten = attenuation;
			#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				data.ambient = 0;
				data.lightmapUV = i.ambientOrLightmapUV;
			#else
				data.ambient = i.ambientOrLightmapUV;
			#endif
			#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
				data.boxMin[ 0] = unity_SpecCube0_BoxMin;
				data.boxMin[ 1] = unity_SpecCube1_BoxMin;
			#endif
			#if UNITY_SPECCUBE_BOX_PROJECTION
				data.boxMax[ 0] = unity_SpecCube0_BoxMax;
				data.boxMax[ 1] = unity_SpecCube1_BoxMax;
				data.probePosition[ 0] = unity_SpecCube0_ProbePosition;
				data.probePosition[ 1] = unity_SpecCube1_ProbePosition;
			#endif
				data.probeHDR[ 0] = unity_SpecCube0_HDR;
				data.probeHDR[ 1] = unity_SpecCube1_HDR;
				Unity_GlossyEnvironmentData glossData;
				glossData.roughness = 1.0 - gloss;
				glossData.reflUVW = viewReflectDirection;
				UnityGI gi = UnityGlobalIllumination( data, 1, normalDirection, glossData);
				lightDirection = gi.light.dir;
				
				float3 indirectSpecular = gi.indirect.specular;
				float3 indirectDiffuse = gi.indirect.diffuse;
		#else
				float3 indirectSpecular = 0;
				float3 indirectDiffuse = UNITY_LIGHTMODEL_AMBIENT.rgb;
		#endif	
				fixed4 emissive = 0;
				
				/* rim */
		#if !defined(_RIMLIGHTTYPE_OFF)
				fixed4 rimColor = UNITY_ACCESS_INSTANCED_PROP( Props, _RimColor);
				float rimPower = UNITY_ACCESS_INSTANCED_PROP( Props, _RimPower);
			#if defined(_RIMLIGHTTYPE_NORMAL)
				float VdotN = saturate( dot( viewDirection, preNormalDirection));
			#else
				float VdotN = saturate( dot( viewDirection, normalDirection));
			#endif
				emissive += rimColor *  pow( 1.0 - VdotN, rimPower) * rimColor.a;
		#endif
				
				/* specular */
			   	float3 specularColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Metallic).xxx;
			   	float3 directSpecular = specularReflection( normalDirection, viewDirection, lightDirection, specPow) * attenColor;
			   	float3 specular = directSpecular * specularColor;
			   	
				/* diffuse */
				float NdotL = saturate( dot( normalDirection, lightDirection));
			 	float3 directDiffuse = NdotL * attenColor;
				float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor.rgb;
				
				/* final Color */
				fixed4 finalColor = fixed4( emissive + diffuse + specular, diffuseColor.a);
				UNITY_APPLY_FOG( i.fogCoord, finalColor);
			#if defined(_FB_BLENDFACTOR_ON)
				finalColor.rgb = (finalColor.rgb * finalColor.a) + (UNITY_ACCESS_INSTANCED_PROP( Props, _RS_FB_BlendFactor) * (1.0 - finalColor.a));
			#endif
				return finalColor;
			}
			ENDCG
		}
		Pass
		{
			Name "FORWARD_DELTA"
			Tags
			{
				"LightMode" = "ForwardAdd"
			}
			ZWrite [_RS_FA_ZWrite]
			ZTest [_RS_FA_ZTest]
			ColorMask [_RS_ColorMask]
			BlendOp [_RS_FA_ColorBlendOp], [_RS_FA_AlphaBlendOp]
			Blend [_RS_FA_ColorSrcFactor] [_RS_FA_ColorDstFactor], [_RS_FA_AlphaSrcFactor] [_RS_FA_AlphaDstFactor]
			
			CGPROGRAM
			#pragma vertex vertAdd
			#pragma fragment fragAdd
			#pragma shader_feature _REFLECTIONMODEL_BLINNPHONG _REFLECTIONMODEL_PHONG
			#pragma shader_feature _ _ALPHACLIP_ON
			#pragma shader_feature _ _FA_BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdadd
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( float,  _Metallic)
				UNITY_DEFINE_INSTANCED_PROP( float,  _Gloss)
			#if defined(_BLENDFACTOR_ON)
	        	UNITY_DEFINE_INSTANCED_PROP( fixed4, _RS_FA_BlendFactor)
	        #endif
			UNITY_INSTANCING_BUFFER_END( Props)

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 texcoord0 : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOutputAdd
			{
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				float3 normalDirection : TEXCOORD2;
				float3 tangentDirection : TEXCOORD3;
				float3 bitangentDirection : TEXCOORD4;
				LIGHTING_COORDS( 5, 6)
				UNITY_FOG_COORDS( 7)
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			float specularReflection( float3 normalDirection, float3 viewDirection, float3 lightDirection, float specularPower)
			{
			#if defined(_REFLECTIONMODEL_BLINNPHONG)
				/* Blinn-Phong */
				float3 halfDirection = normalize( viewDirection + lightDirection);
				float HdotN = saturate( dot( halfDirection, normalDirection));
				return pow( HdotN, specularPower);
			#elif defined(_REFLECTIONMODEL_PHONG)
				/* Phong */
				float3 lightReflectDirection = reflect( -lightDirection, normalDirection);
				float LdotV = saturate( dot( lightReflectDirection, viewDirection));
				return pow( LdotV, specularPower);
			#else
				return normalDirection;
			#endif
			}
			void vertAdd( VertexInput v, out VertexOutputAdd o)
			{
				o = (VertexOutputAdd)0;
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.pos = UnityObjectToClipPos( v.vertex);
				o.uv0 = TRANSFORM_TEX( v.texcoord0.xy, _MainTex);
				o.worldPosition = mul( unity_ObjectToWorld, v.vertex);
				o.normalDirection = UnityObjectToWorldNormal( v.normal);
				o.tangentDirection = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0)).xyz);
				o.bitangentDirection = normalize( cross( o.normalDirection, o.tangentDirection) * v.tangent.w);
				UNITY_TRANSFER_FOG( o, o.pos);
				TRANSFER_VERTEX_TO_FRAGMENT( o)
			}
			fixed4 fragAdd( VertexOutputAdd i, fixed facing : VFACE) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				
				float attenuation = LIGHT_ATTENUATION( i);
				float3 attenColor = attenuation * _LightColor0.rgb;
				float3 normalMap = UnpackNormal( tex2D( _NormalMap, i.uv0));
				float4 baseMap = tex2D( _MainTex, i.uv0);
				float4 baseColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float4 diffuseColor = baseMap * baseColor;
			#if defined(_ALPHACLIP_ON)
				clip( diffuseColor.a - 1e-4);
			#endif
				
				float3 normalDirection = normalize( i.normalDirection * (facing >= 0 ? 1.0 : -1.0));
				float3x3 tangentTransform = float3x3( i.tangentDirection, i.bitangentDirection, normalDirection);
				normalDirection = normalize( mul( normalMap, tangentTransform));
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.worldPosition.xyz);
				float3 viewReflectDirection = reflect( -viewDirection, normalDirection);
				float3 lightDirection = normalize( lerp( _WorldSpaceLightPos0.xyz, 
					_WorldSpaceLightPos0.xyz - i.worldPosition.xyz, _WorldSpaceLightPos0.w));
				
				/* gloss */
				float gloss = UNITY_ACCESS_INSTANCED_PROP( Props, _Gloss);
				float specPow = exp2( gloss * 10.0 + 1.0);
				
				/* specular */
			   	float specularIntensity = specularReflection( normalDirection, viewDirection, lightDirection, specPow);
			   	float3 specularColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Metallic).xxx;
			   	float3 directSpecular = specularIntensity * attenColor * specularColor;
			   	float3 specular = directSpecular;
			   	
				/* diffuse */
				float NdotL = saturate( dot( normalDirection, lightDirection));
			 	float3 directDiffuse = NdotL * attenColor;
				float3 diffuse = directDiffuse * diffuseColor.rgb;
				
				/* final Color */
				fixed4 finalColor = fixed4( diffuse + specular, diffuseColor.a);
				UNITY_APPLY_FOG( i.fogCoord, finalColor);
			#if defined(_FA_BLENDFACTOR_ON)
				finalColor.rgb = (finalColor.rgb * finalColor.a) + (UNITY_ACCESS_INSTANCED_PROP( Props, _RS_FA_BlendFactor) * (1.0 - finalColor.a));
			#endif
				return finalColor;
			}
			ENDCG
		}
		Pass
		{
			Name "ShadowCaster"
			Tags
			{
				"LightMode"="ShadowCaster"
			}
			Offset 1, 1
			Cull [_RS_Cull]
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature _ _SHADOWTRANSLUCENT_ON
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			
		#if defined(_SHADOWTRANSLUCENT_ON)
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler3D _DitherMaskLOD;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
			UNITY_INSTANCING_BUFFER_END( Props)
			
			struct VertexInput
			{
			    float4 vertex : POSITION;
			    float3 normal : NORMAL;
			    float2 texcoord0 : TEXCOORD0;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOutput
			{
				V2F_SHADOW_CASTER_NOPOS
				float2 uv0 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			VertexOutput vert( VertexInput v, out float4 pos : SV_POSITION)
			{
			    VertexOutput o = (VertexOutput)0;
			    UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.uv0 = TRANSFORM_TEX( v.texcoord0.xy, _MainTex);
			    TRANSFER_SHADOW_CASTER_NOPOS( o, pos);
			    return o;
			}
			float4 frag( VertexOutput i, UNITY_VPOS_TYPE vpos: VPOS) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				float4 baseMap = tex2D( _MainTex, i.uv0);
				float4 baseColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float alpha = baseMap.a * baseColor.a;
				alpha = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, alpha * 0.9375)).a;
				clip( alpha - 1e-4);
			    SHADOW_CASTER_FRAGMENT( i);
			}
		#else
			struct VertexInput
			{
			    float4 vertex : POSITION;
			    float3 normal : NORMAL;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOutput
			{
				V2F_SHADOW_CASTER;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			void vert( VertexInput v, out VertexOutput o)
			{
			    o = (VertexOutput)0;
			    UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
			    TRANSFER_SHADOW_CASTER_NORMALOFFSET( o);
			}
			float4 frag( VertexOutput i) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
			    SHADOW_CASTER_FRAGMENT( i);
			}
		#endif
			ENDCG
		}
	}
	Fallback Off
	CustomEditor "ZanShader.Editor.InspectorGUI"
}
