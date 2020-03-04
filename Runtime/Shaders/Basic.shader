
Shader "Zan/Lit/Basic"
{
	Properties
	{
		[KeywordEnum(None, Lambert, Disney)]
		_DIFFUSEBRDF( "Diffuse BRDF", float) = 1
		[KeywordEnum(None, BlinnPhong, Phong, CookTorrance, CookTorranceGGX, TorranceSparrow, TorranceSparrowGGX)]
		_SPECULARBRDF( "Specular BRDF", float) = 1
		
		[KeywordEnum(None, Ambient, FastGI, GI, ReflectionFastGI, ReflectionGI)]
		_INDIRECTMODE( "Indirect Mode", float) = 4
		
		[Caption(Diffuse Properties)]
		_MainTex( "Diffuse Map", 2D) = "white" {}
		[HDR] _Color( "Diffuse Color", Color) = (1,1,1,1)
		
		[Caption(Specular Properties)]
		_Metallic( "Metallic", Range(0, 1)) = 0
		_Gloss( "Gloss", Range(0, 1)) = 0.0
		
		[Caption(Rim Lighting Properties)]
		[KeywordEnum(None, Normal, NormalMap)]
		_RIMLIGHTTYPE( "Rim Light Type", float) = 0
		[HDR] _RimColor( "Rim Color", Color) = (1,1,1,1)
		_RimPower( "Rim Power", Range( 0, 10)) = 2.0
		
		[Caption(Normal Map Properties)]
		_NormalMap( "Normal Map", 2D) = "bump" {}
		
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
			#pragma shader_feature _DIFFUSEBRDF_NONE _DIFFUSEBRDF_LAMBERT _DIFFUSEBRDF_DISNEY
			#pragma shader_feature _SPECULARBRDF_NONE _SPECULARBRDF_BLINNPHONG _SPECULARBRDF_PHONG _SPECULARBRDF_COOKTORRANCE _SPECULARBRDF_COOKTORRANCEGGX _SPECULARBRDF_TORRANCESPARROW _SPECULARBRDF_TORRANCESPARROWGGX
			#pragma shader_feature _INDIRECTMODE_NONE _INDIRECTMODE_AMBIENT _INDIRECTMODE_FASTGI _INDIRECTMODE_GI _INDIRECTMODE_REFLECTIONFASTGI _INDIRECTMODE_REFLECTIONGI
			#pragma shader_feature _RIMLIGHTTYPE_NONE _RIMLIGHTTYPE_NORMAL _RIMLIGHTTYPE_NORMALMAP
			#pragma shader_feature _ _ALPHACLIP_ON
			#pragma shader_feature _ _FB_BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "Includes/Lighting.cginc"
			
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;
			UNITY_INSTANCING_BUFFER_START( Props)
				UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
				UNITY_DEFINE_INSTANCED_PROP( float,  _Metallic)
				UNITY_DEFINE_INSTANCED_PROP( float,  _Gloss)
			#if !defined(_RIMLIGHTTYPE_NONE)
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
			#if defined(_INDIRECTMODE_FASTGI) || defined(_INDIRECTMODE_GI) || defined(_INDIRECTMODE_REFLECTIONFASTGI) || defined(_INDIRECTMODE_REFLECTIONGI)
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
			#if defined(_INDIRECTMODE_FASTGI) || defined(_INDIRECTMODE_GI) || defined(_INDIRECTMODE_REFLECTIONFASTGI) || defined(_INDIRECTMODE_REFLECTIONGI)
				float4 ambientOrLightmapUV : TEXCOORD10;
			#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
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
			#if defined(_INDIRECTMODE_FASTGI) || defined(_INDIRECTMODE_GI) || defined(_INDIRECTMODE_REFLECTIONFASTGI) || defined(_INDIRECTMODE_REFLECTIONGI)
				o.ambientOrLightmapUV = vertGI( v.texcoord1, v.texcoord2, o.worldPosition, o.normalDirection);
			#endif
				UNITY_TRANSFER_FOG( o, o.pos);
				TRANSFER_VERTEX_TO_FRAGMENT( o);
				TRANSFER_SHADOW( o);
			}
			fixed4 fragBase( VertexOutputBase i, fixed facing : VFACE) : COLOR
			{
				UNITY_SETUP_INSTANCE_ID( i);
				
				float4 baseMap = tex2D( _MainTex, TRANSFORM_TEX( i.uv0, _MainTex));
				float4 baseColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float4 diffuseColor = baseMap * baseColor;
			#if defined(_ALPHACLIP_ON)
				clip( diffuseColor.a - 1e-4);
			#endif
				float3 normalMap = UnpackNormal( tex2D( _NormalMap, TRANSFORM_TEX( i.uv0, _NormalMap)));
				float attenuation = LIGHT_ATTENUATION( i);
				float3 attenColor = attenuation * _LightColor0.rgb;
				
				half metallic = UNITY_ACCESS_INSTANCED_PROP( Props, _Metallic);
				float smoothness = UNITY_ACCESS_INSTANCED_PROP( Props, _Gloss);
				float perceptualRoughness = 1.0 - smoothness;
				float roughness = perceptualRoughness * perceptualRoughness;
				
				float3 specularColor = lerp( unity_ColorSpaceDielectricSpec.rgb, diffuseColor.rgb, metallic);
				half oneMinusDielectricSpec = unity_ColorSpaceDielectricSpec.a;
				half specularMonochrome = oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
				diffuseColor.rgb *= specularMonochrome;
				specularMonochrome = 1.0 - specularMonochrome;
				
				float3 preNormalDirection = normalize( i.normalDirection * (facing >= 0 ? 1.0 : -1.0));
				float3x3 tangentTransform = float3x3( i.tangentDirection, i.bitangentDirection, preNormalDirection);
				float3 normalDirection = normalize( mul( normalMap, tangentTransform));
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.worldPosition.xyz);
				float3 lightDirection = normalize( _WorldSpaceLightPos0.xyz);
				
				float3 halfDirection = normalize( viewDirection + lightDirection);
				float NdotL = saturate( dot( normalDirection, lightDirection));
				float NdotV = abs( dot( normalDirection, viewDirection));
				float NdotH = saturate( dot( normalDirection, halfDirection));
				float LdotH = saturate( dot( lightDirection, halfDirection));
				
/* global illumination */
#if defined(_INDIRECTMODE_FASTGI) || defined(_INDIRECTMODE_GI) || defined(_INDIRECTMODE_REFLECTIONFASTGI) || defined(_INDIRECTMODE_REFLECTIONGI)
				UnityGIInput data = fragGIData( i.worldPosition.xyz, 
					normalDirection, viewDirection, lightDirection, 
					i.ambientOrLightmapUV, attenuation, perceptualRoughness);
			#if defined(_INDIRECTMODE_REFLECTIONFASTGI) || defined(_INDIRECTMODE_REFLECTIONGI)
				Unity_GlossyEnvironmentData glossData;
				glossData.roughness = perceptualRoughness;
				glossData.reflUVW = reflect( -viewDirection, normalDirection);
				UnityGI gi = UnityGlobalIllumination( data, 1, normalDirection, glossData);
			#else
				UnityGI gi = UnityGlobalIllumination( data, 1, normalDirection);
			#endif
				lightDirection = gi.light.dir;
				
				float3 indirectDiffuse = gi.indirect.diffuse * diffuseColor.rgb;
				float3 indirectSpecular = gi.indirect.specular;
				
				half grazingTerm = saturate( smoothness + specularMonochrome);
		#if defined(_INDIRECTMODE_FASTGI) || defined(_INDIRECTMODE_REFLECTIONFASTGI)
			#ifdef UNITY_COLORSPACE_GAMMA
				half surfaceReduction = 0.28h;
			#else
				half surfaceReduction = (0.6h - 0.08h * perceptualRoughness);
			#endif
				surfaceReduction = 1.0h - roughness * perceptualRoughness * surfaceReduction;
				indirectSpecular *= FresnelLerpFast( specularColor, grazingTerm, NdotV) * surfaceReduction;
		#else
			#ifdef UNITY_COLORSPACE_GAMMA
				half surfaceReduction = 1.0 - 0.28 * roughness * perceptualRoughness;
			#else
				half surfaceReduction = 1.0 / (roughness * roughness + 1.0);
			#endif
				indirectSpecular *= FresnelLerp( specularColor, grazingTerm, NdotV) * surfaceReduction;
		#endif
#elif defined(_INDIRECTMODE_AMBIENT)
				float3 indirectDiffuse = UNITY_LIGHTMODEL_AMBIENT.rgb * diffuseColor.rgb;
				float3 indirectSpecular = 0;
#else
				float3 indirectDiffuse = 0;
				float3 indirectSpecular = 0;
#endif
				
/* specular */
#if defined(_SPECULARBRDF_TORRANCESPARROW) || defined(_SPECULARBRDF_TORRANCESPARROWGGX)
			#if defined(_SPECULARBRDF_TORRANCESPARROWGGX)
				roughness = max( 0.002, roughness);
				float Vis = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness);
				float D = GGXTerm( NdotH, roughness);
			#else
				half Vis =	SmithBeckmannVisibilityTerm( NdotL, NdotV, roughness);
				half D = NDFBlinnPhongNormalizedTerm( NdotH, PerceptualRoughnessToSpecPower( perceptualRoughness));
			#endif
				float specularTerm = Vis * D * UNITY_PI;
				
			#ifdef UNITY_COLORSPACE_GAMMA
				specularTerm = sqrt( max( 1e-4h, specularTerm));
			#endif
				specularTerm = max( 0, specularTerm * NdotL);
				float3 directSpecular = any( specularColor) ? FresnelTerm( specularColor, LdotH) * attenColor * specularTerm : 0.0;
#elif defined(_SPECULARBRDF_COOKTORRANCE) || defined(_SPECULARBRDF_COOKTORRANCEGGX)
		#if defined(_SPECULARBRDF_COOKTORRANCEGGX)
				roughness = max( 0.002, roughness);
				float roughness2 = roughness * roughness;
				float d = NdotH * NdotH * (roughness2 - 1.0) + 1.00001;
			#ifdef UNITY_COLORSPACE_GAMMA
			    float specularTerm = roughness / (max( 0.32, LdotH) * (1.5 + roughness) * d);
			#else
			    float specularTerm = roughness2 / (max(0.1, LdotH * LdotH) * (roughness + 0.5) * (d * d) * 4.0);
			#endif
			#if defined(SHADER_API_MOBILE)
			    specularTerm = specularTerm - 1e-4;
			#endif
		#else
				half specularPower = PerceptualRoughnessToSpecPower( perceptualRoughness);
				half invV = LdotH * LdotH * smoothness + perceptualRoughness * perceptualRoughness;
				half invF = LdotH;
				half specularTerm = ((specularPower + 1.0h) * pow( NdotH, specularPower)) / (8.0h * invV * invF + 1e-4h);
			#ifdef UNITY_COLORSPACE_GAMMA
			    specularTerm = sqrt( max( 1e-4h, specularTerm));
			#endif
		#endif
			#if defined (SHADER_API_MOBILE)
			    specularTerm = clamp( specularTerm, 0.0, 100.0);
			#endif
				float3 directSpecular = specularTerm * NdotL * specularColor;
#elif defined(_SPECULARBRDF_PHONG)
			   	float specPower = exp2( smoothness * 10.0 + 1.0);
				float3 lightReflectDirection = reflect( -lightDirection, normalDirection);
				float LdotV = max( 0, dot( lightReflectDirection, viewDirection));
				float3 directSpecular = pow( LdotV, specPower) * attenColor * specularColor;
#elif defined(_SPECULARBRDF_BLINNPHONG)
				float specPower = exp2( smoothness * 10.0 + 1.0);
				float3 directSpecular = pow( NdotH, specPower) * attenColor * specularColor;
#else
				float3 directSpecular = 0;
#endif
				float3 specular = directSpecular + indirectSpecular;
		
/* diffuse */
#if defined(_DIFFUSEBRDF_DISNEY)
			 	float3 directDiffuse = diffuseDisney( NdotV, NdotL, LdotH, perceptualRoughness, attenColor) * diffuseColor.rgb;
#elif defined(_DIFFUSEBRDF_LAMBERT)
				float3 directDiffuse = diffuseLambert( NdotL, attenColor) * diffuseColor.rgb;
#else
				float3 directDiffuse = 0;
#endif
				float3 diffuse = directDiffuse + indirectDiffuse;

/* emissive */
				fixed4 emissive = 0;
				
				/* rim */
#if !defined(_RIMLIGHTTYPE_NONE)
				fixed4 rimColor = UNITY_ACCESS_INSTANCED_PROP( Props, _RimColor);
				float rimPower = UNITY_ACCESS_INSTANCED_PROP( Props, _RimPower);
			#if defined(_RIMLIGHTTYPE_NORMAL)
				float VdotN = saturate( dot( viewDirection, preNormalDirection));
			#else
				float VdotN = saturate( dot( viewDirection, normalDirection));
			#endif
				emissive += rimColor *	pow( 1.0 - VdotN, rimPower) * rimColor.a;
#endif
				
				/* final Color */
				fixed4 finalColor = fixed4( diffuse + specular + emissive, diffuseColor.a);
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
			#pragma shader_feature _DIFFUSEBRDF_NONE _DIFFUSEBRDF_LAMBERT _DIFFUSEBRDF_DISNEY
			#pragma shader_feature _SPECULARBRDF_NONE _SPECULARBRDF_BLINNPHONG _SPECULARBRDF_PHONG _SPECULARBRDF_COOKTORRANCE _SPECULARBRDF_COOKTORRANCEGGX _SPECULARBRDF_TORRANCESPARROW _SPECULARBRDF_TORRANCESPARROWGGX
			#pragma shader_feature _ _ALPHACLIP_ON
			#pragma shader_feature _ _FA_BLENDFACTOR_ON
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdadd
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "Includes/Lighting.cginc"
			
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
			void vertAdd( VertexInput v, out VertexOutputAdd o)
			{
				o = (VertexOutputAdd)0;
				UNITY_SETUP_INSTANCE_ID( v);
				UNITY_TRANSFER_INSTANCE_ID( v, o);
				o.pos = UnityObjectToClipPos( v.vertex);
				o.uv0 = v.texcoord0.xy;
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
				
				float4 baseMap = tex2D( _MainTex, TRANSFORM_TEX( i.uv0, _MainTex));
				float4 baseColor = UNITY_ACCESS_INSTANCED_PROP( Props, _Color);
				float4 diffuseColor = baseMap * baseColor;
			#if defined(_ALPHACLIP_ON)
				clip( diffuseColor.a - 1e-4);
			#endif
				float3 normalMap = UnpackNormal( tex2D( _NormalMap, TRANSFORM_TEX( i.uv0, _NormalMap)));
				float attenuation = LIGHT_ATTENUATION( i);
				float3 attenColor = attenuation * _LightColor0.rgb;
				
				half metallic = UNITY_ACCESS_INSTANCED_PROP( Props, _Metallic);
				float smoothness = UNITY_ACCESS_INSTANCED_PROP( Props, _Gloss);
				float perceptualRoughness = 1.0 - smoothness;
				float roughness = perceptualRoughness * perceptualRoughness;
				
				float3 specularColor = lerp( unity_ColorSpaceDielectricSpec.rgb, diffuseColor.rgb, metallic);
				half oneMinusDielectricSpec = unity_ColorSpaceDielectricSpec.a;
				half specularMonochrome = oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
				diffuseColor.rgb *= specularMonochrome;
				specularMonochrome = 1.0 - specularMonochrome;
				
				float3 preNormalDirection = normalize( i.normalDirection * (facing >= 0 ? 1.0 : -1.0));
				float3x3 tangentTransform = float3x3( i.tangentDirection, i.bitangentDirection, preNormalDirection);
				float3 normalDirection = normalize( mul( normalMap, tangentTransform));
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.worldPosition.xyz);
				float3 lightDirection = normalize( lerp( _WorldSpaceLightPos0.xyz, 
					_WorldSpaceLightPos0.xyz - i.worldPosition.xyz, _WorldSpaceLightPos0.w));
				
				float3 halfDirection = normalize( viewDirection + lightDirection);
				float NdotL = saturate( dot( normalDirection, lightDirection));
				float NdotV = abs( dot( normalDirection, viewDirection));
				float NdotH = saturate( dot( normalDirection, halfDirection));
				float LdotH = saturate( dot( lightDirection, halfDirection));
				
/* specular */
#if defined(_SPECULARBRDF_TORRANCESPARROW) || defined(_SPECULARBRDF_TORRANCESPARROWGGX)
			#if defined(_SPECULARBRDF_TORRANCESPARROWGGX)
				roughness = max( 0.002, roughness);
				float Vis = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness);
				float D = GGXTerm( NdotH, roughness);
			#else
				half Vis =	SmithBeckmannVisibilityTerm( NdotL, NdotV, roughness);
				half D = NDFBlinnPhongNormalizedTerm( NdotH, PerceptualRoughnessToSpecPower( perceptualRoughness));
			#endif
				float specularTerm = Vis * D * UNITY_PI;
				
			#ifdef UNITY_COLORSPACE_GAMMA
				specularTerm = sqrt( max( 1e-4h, specularTerm));
			#endif
				specularTerm = max( 0, specularTerm * NdotL);
				float3 specular = any( specularColor) ? FresnelTerm( specularColor, LdotH) * attenColor * specularTerm : 0.0;
#elif defined(_SPECULARBRDF_COOKTORRANCE) || defined(_SPECULARBRDF_COOKTORRANCEGGX)
		#if defined(_SPECULARBRDF_COOKTORRANCEGGX)
				roughness = max( 0.002, roughness);
				float roughness2 = roughness * roughness;
				float d = NdotH * NdotH * (roughness2 - 1.0) + 1.00001;
			#ifdef UNITY_COLORSPACE_GAMMA
			    float specularTerm = roughness / (max( 0.32, LdotH) * (1.5 + roughness) * d);
			#else
			    float specularTerm = roughness2 / (max(0.1, LdotH * LdotH) * (roughness + 0.5) * (d * d) * 4.0);
			#endif
			#if defined(SHADER_API_MOBILE)
			    specularTerm = specularTerm - 1e-4;
			#endif
		#else
				half specularPower = PerceptualRoughnessToSpecPower( perceptualRoughness);
				half invV = LdotH * LdotH * smoothness + perceptualRoughness * perceptualRoughness;
				half invF = LdotH;
				half specularTerm = ((specularPower + 1.0h) * pow( NdotH, specularPower)) / (8.0h * invV * invF + 1e-4h);
			#ifdef UNITY_COLORSPACE_GAMMA
			    specularTerm = sqrt( max( 1e-4h, specularTerm));
			#endif
		#endif
			#if defined (SHADER_API_MOBILE)
			    specularTerm = clamp( specularTerm, 0.0, 100.0);
			#endif
				float3 specular = specularTerm * NdotL * specularColor;
#elif defined(_SPECULARBRDF_PHONG)
			   	float specPower = exp2( smoothness * 10.0 + 1.0);
				float3 lightReflectDirection = reflect( -lightDirection, normalDirection);
				float LdotV = max( 0, dot( lightReflectDirection, viewDirection));
				float3 specular = pow( LdotV, specPower) * attenColor * specularColor;
#elif defined(_SPECULARBRDF_BLINNPHONG)
				float specPower = exp2( smoothness * 10.0 + 1.0);
				float3 specular = pow( NdotH, specPower) * attenColor * specularColor;
#else
				float3 specular = 0;
#endif
		
/* diffuse */
#if defined(_DIFFUSEBRDF_DISNEY)
			 	float3 diffuse = diffuseDisney( NdotV, NdotL, LdotH, perceptualRoughness, attenColor) * diffuseColor.rgb;
#elif defined(_DIFFUSEBRDF_LAMBERT)
				float3 diffuse = diffuseLambert( NdotL, attenColor) * diffuseColor.rgb;
#else
				float3 diffuse = 0;
#endif
				
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
