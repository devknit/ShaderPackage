
using System;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

namespace ZanShader.Editor
{
	static class ShaderLOD
	{
		[MenuItem("Tools/Shader LOD/Default")]
		static void LODDefault()
		{
			Shader.globalMaximumLOD = int.MaxValue;
		}
		[MenuItem("Tools/Shader LOD/600")]
		static void LOD600()
		{
			Shader.globalMaximumLOD = 600;
		}
		[MenuItem("Tools/Shader LOD/500")]
		static void LOD500()
		{
			Shader.globalMaximumLOD = 500;
		}
		[MenuItem("Tools/Shader LOD/400")]
		static void LOD400()
		{
			Shader.globalMaximumLOD = 400;
		}
		[MenuItem("Tools/Shader LOD/300")]
		static void LOD300()
		{
			Shader.globalMaximumLOD = 300;
		}
		[MenuItem("Tools/Shader LOD/250")]
		static void LOD250()
		{
			Shader.globalMaximumLOD = 250;
		}
		[MenuItem("Tools/Shader LOD/200")]
		static void LOD200()
		{
			Shader.globalMaximumLOD = 200;
		}
		[MenuItem("Tools/Shader LOD/150")]
		static void LOD150()
		{
			Shader.globalMaximumLOD = 150;
		}
		[MenuItem("Tools/Shader LOD/100")]
		static void LOD100()
		{
			Shader.globalMaximumLOD = 100;
		}
		[InitializeOnLoadMethod]
		static void InitializeOnLoad()
	    {
	        EditorApplication.update += OnUpdate;
	    }
    	static void OnUpdate()
	    {
	        var toolbar = kToolBarGet.GetValue( null);
	        if( toolbar != null)
	        {
				EditorApplication.update -= OnUpdate;
				AddHandler( toolbar);
			}
	    }
		static void AddHandler( object toolbar)
	    {
	        var container = kViewContainer.GetValue( toolbar, null) as IMGUIContainer;
	        var handler = kContainerHandler.GetValue( container) as Action;

	        handler += OnGUI;

	        kContainerHandler.SetValue( container, handler);
	    }
	    static void OnGUI()
	    {
			EditorGUI.LabelField( new Rect( 409, 5, 75, 22), "Shader LOD", EditorStyles.toolbarButton);
			Shader.globalMaximumLOD = EditorGUI.IntPopup( new Rect( 484, 5, 128, 22), Shader.globalMaximumLOD, kLODStrings, kLODs, EditorStyles.toolbarPopup);
	    }
	    static readonly Type kToolBarType = typeof( EditorGUI).Assembly.GetType( "UnityEditor.Toolbar");
	    static readonly FieldInfo kToolBarGet = kToolBarType.GetField( "get");
	    static readonly Type kViewType = typeof( EditorGUI).Assembly.GetType( "UnityEditor.GUIView");
	    static readonly BindingFlags kBindingAttribute = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;
	    static readonly PropertyInfo kViewContainer = kViewType.GetProperty( "imguiContainer", kBindingAttribute);
	    static readonly FieldInfo kContainerHandler = typeof( IMGUIContainer ).GetField("m_OnGUIHandler", kBindingAttribute);
	    static readonly string[] kLODStrings = new string[]
	    {
			"Default",
			"600",
			"500",
			"400",
			"300",
			"250",
			"200",
			"150",
			"100"
		};
		static readonly int[] kLODs = new int[]
	    {
			int.MaxValue,
			600,
			500,
			400,
			300,
			250,
			200,
			150,
			100
		};
	}
}
