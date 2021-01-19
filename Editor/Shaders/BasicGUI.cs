
using System;

namespace Shaders.Editor
{
	public class BasicGUI : InspectorGUI
	{
		sealed class Base : MaterialPropertyGroup
		{
			public Base() : base( "Base", kPropertyNames)
			{
			}
			protected override bool GroupFoldout
			{
				get{ return foldoutFlag; }
				set{ foldoutFlag = value; }
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_DIFFUSEBRDF",
				"_SPECULARBRDF",
				"_INDIRECTMODE",
				"_Metallic",
				"_Gloss",
				"_VERTEXCOLOR",
				"_SHADOWTRANSLUCENT",
			};
			static bool foldoutFlag = true;
		}
		sealed class AlbedoMap : MaterialPropertyGroup
		{
			public AlbedoMap() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_ALBEDOMAP",
				"_MainTex",
				"_Color",
			};
		}
		sealed class MetallicGloss : MaterialPropertyGroup
		{
			public MetallicGloss() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_METALLICGLOSSMAP",
				"_MetallicGlossTex",
			};
		}
		sealed class EmissiveMap : MaterialPropertyGroup
		{
			public EmissiveMap() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_EMISSIVEMAP",
				"_EmissiveTex",
				"_EmissiveColor",
			};
		}
		sealed class Rimlight : MaterialPropertyGroup
		{
			public Rimlight() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_RIMLIGHT",
				"_RIMLIGHTMODE",
				"_RimlightColor",
				"_RimlightStep",
				"_RimlightFeather",
			};
		}
		sealed class NormalMap : MaterialPropertyGroup
		{
			public NormalMap() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_NORMALMAP",
				"_NormalTex",
				"_NormalScale",
			};
		}
		sealed class ParallaxMap : MaterialPropertyGroup
		{
			public ParallaxMap() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_PARALLAXMAP",
				"_ParallaxTex",
				"_ParallaxScale"
			};
		}
		sealed class OcclusionMap : MaterialPropertyGroup
		{
			public OcclusionMap() : base( kPropertyNames, 0)
			{
			}
			static readonly string[] kPropertyNames = new string[]
			{
				"_OCCLUSIONMAP",
				"_OcclusionTex",
				"_OcclusionStrength",
			};
		}
		protected override Type[] MaterialGroupTypes
		{
			get{ return kStatusTypes; }
		}
		static readonly Type[] kStatusTypes = new Type[]
		{
			typeof( Base),
			typeof( AlbedoMap),
			typeof( MetallicGloss),
			typeof( EmissiveMap),
			typeof( Rimlight),
			typeof( NormalMap),
			typeof( ParallaxMap),
			typeof( OcclusionMap),
		};
	}
}
