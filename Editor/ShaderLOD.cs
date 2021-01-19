
using System;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace Shaders.Editor
{
	static class ShaderLOD
	{
		[MenuItem( "Tools/Shader LOD/Default")]
		static void LODDefault()
		{
			Shader.globalMaximumLOD = int.MaxValue;
		}
		[MenuItem( "Tools/Shader LOD/600")]
		static void LOD600()
		{
			Shader.globalMaximumLOD = 600;
		}
		[MenuItem( "Tools/Shader LOD/500")]
		static void LOD500()
		{
			Shader.globalMaximumLOD = 500;
		}
		[MenuItem( "Tools/Shader LOD/400")]
		static void LOD400()
		{
			Shader.globalMaximumLOD = 400;
		}
		[MenuItem( "Tools/Shader LOD/300")]
		static void LOD300()
		{
			Shader.globalMaximumLOD = 300;
		}
		[MenuItem( "Tools/Shader LOD/250")]
		static void LOD250()
		{
			Shader.globalMaximumLOD = 250;
		}
		[MenuItem( "Tools/Shader LOD/200")]
		static void LOD200()
		{
			Shader.globalMaximumLOD = 200;
		}
		[MenuItem( "Tools/Shader LOD/150")]
		static void LOD150()
		{
			Shader.globalMaximumLOD = 150;
		}
		[MenuItem( "Tools/Shader LOD/100")]
		static void LOD100()
		{
			Shader.globalMaximumLOD = 100;
		}
	}
}
