
using UnityEditor;
using UnityEngine;

namespace ZanShader.Editor
{
	public class MaterialPropertyGroup
	{
		public MaterialPropertyGroup( string groupCaption, string[] propertyNames)
			: this( groupCaption, propertyNames, new int[]{ -1 })
		{
		}
		public MaterialPropertyGroup( string[] propertyNames, params int[] foldoutIndices)
			: this( string.Empty, propertyNames, foldoutIndices)
		{
		}
		public MaterialPropertyGroup( string groupCaption, string[] propertyNames, params int[] foldoutIndices)
		{
			this.groupCaption = groupCaption;
			this.propertyNames = propertyNames;
			this.foldoutIndices = (foldoutIndices != null)? foldoutIndices : new int[]{ 0 };
		}
		public void ClearProperty()
		{
			if( properties == null)
			{
				properties = new MaterialProperty[ propertyNames.Length];
			}
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				properties[ i0] = null;
			}
		}
		public bool SetProperty( MaterialProperty property)
		{
			for( int i0 = 0; i0 < propertyNames.Length; ++i0)
			{
				if( property.name == propertyNames[ i0])
				{
					properties[ i0] = property;
					return true;
				}
			}
			return false;
		}
		public virtual bool ValidGUI()
		{
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				if( properties[ i0] == null)
				{
					return false;
				}
			}
			return true;
		}
		public virtual void OnGUI( MaterialEditor materialEditor)
		{
			if( ValidGUI() != false)
			{
				OnInternalGUI( 0, materialEditor, true);
			}
		}
		protected virtual bool GroupFoldout
		{
			get{ return true; }
			set{ }
		}
		int OnInternalGUI( int hierarchyNo, MaterialEditor materialEditor, bool recursion)
		{
			int foldoutIndex = foldoutIndices[ hierarchyNo++];
			int startIndex = foldoutIndex + 1;
			int endIndex = propertyNames.Length;
			
			if( hierarchyNo < foldoutIndices.Length)
			{
				endIndex = foldoutIndices[ hierarchyNo];
			}
			if( startIndex < endIndex)
			{
				for( int i0 = startIndex; i0 < endIndex; ++i0)
				{
					if( properties[ i0] == null)
					{
						return -1;
					}
				}
				bool foldout;
				
				if( foldoutIndex < 0)
				{
					GroupFoldout = foldout = Foldout( GroupFoldout, groupCaption);
				}
				else
				{
					foldout = Foldout( materialEditor, properties[ foldoutIndex], properties[ foldoutIndex].displayName);
				}
				if( foldout != false)
				{
					++EditorGUI.indentLevel;
					
					for( int i0 = startIndex; i0 < endIndex; ++i0)
					{
						if( (properties[ i0].flags & MaterialProperty.PropFlags.HideInInspector) == 0)
						{
							materialEditor.ShaderProperty( properties[ i0], properties[ i0].displayName);
						}
					}
					if( recursion != false)
					{
						while( hierarchyNo >= 0 && hierarchyNo < foldoutIndices.Length)
						{
							hierarchyNo = OnInternalGUI( hierarchyNo, materialEditor, false);
						}
					}
					--EditorGUI.indentLevel;
				}
			}
			return hierarchyNo;
		}
		protected static void SetToggleKeyword( MaterialProperty property)
		{
			if( property.type == MaterialProperty.PropType.Float
			||	property.type == MaterialProperty.PropType.Range)
			{
				string keyword = property.name.ToUpperInvariant() + "_ON";
				if( property.floatValue > 0.0f)
				{
					foreach( Material material in property.targets)
					{
						material.EnableKeyword( keyword);
					}
				}
				else
				{
					foreach( Material material in property.targets)
					{
						material.DisableKeyword( keyword);
					}
				}
			}
		}
		protected static bool Foldout( MaterialEditor materialEditor, MaterialProperty property, string caption)
		{
			if( property.type == MaterialProperty.PropType.Float
			||	property.type == MaterialProperty.PropType.Range)
			{
				var style = FoldoutStyle;
				style = new GUIStyle( "ShurikenModuleTitle");
				style.font = new GUIStyle( EditorStyles.boldLabel).font;
				style.fontStyle = FontStyle.Bold;
				style.fixedHeight = 22;
				style.border = new RectOffset( 15, 7, 4, 4);
				style.contentOffset = new Vector2( 20, -2);
				
				var rect = GUILayoutUtility.GetRect( 16f, 22f, foldoutStyle);
				rect.xMin += EditorGUI.indentLevel * 16.0f;
				GUI.Box( rect, caption, foldoutStyle);
				
				EditorGUI.showMixedValue = property.hasMixedValue;
				rect.xMin -= EditorGUI.indentLevel * 16.0f;
				rect.xMin += 4;
				rect.yMin -= 2;
				
				EditorGUI.BeginChangeCheck();
				
				bool display = EditorGUI.ToggleLeft( rect, "", property.floatValue > 0.0f);
				if( EditorGUI.EndChangeCheck() != false)
				{
					materialEditor.RegisterPropertyChangeUndo( property.name);
					property.floatValue = (display == false)? 0.0f : 1.0f;
					SetToggleKeyword( property);
				}
				EditorGUI.showMixedValue = false;
				
				return display != false || property.hasMixedValue != false;
			}
			return false;
		}
		protected static bool Foldout( bool display, string caption)
		{
			var style = FoldoutStyle;
			style = new GUIStyle( "ShurikenModuleTitle");
			style.font = new GUIStyle( EditorStyles.boldLabel).font;
			style.fontStyle = FontStyle.Bold;
			style.fixedHeight = 22;
			style.border = new RectOffset( 15, 7, 4, 4);
			style.contentOffset = new Vector2( 20, -2);
			
			var rect = GUILayoutUtility.GetRect( 16f, 22f, style);
			rect.xMin += EditorGUI.indentLevel * 16.0f;
			GUI.Box( rect, caption, style);
			
			var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
			if( Event.current.type == EventType.Repaint)
			{
				EditorStyles.foldout.Draw(　toggleRect, false, false, display, false);
			}
			if( Event.current.type == EventType.MouseDown && rect.Contains( Event.current.mousePosition) != false)
			{
				display = !display;
				Event.current.Use();
			}
			return display;
		}
		public string Caption
		{
			get => groupCaption;
		}
		static GUIStyle FoldoutStyle
		{
			get
			{
				if( foldoutStyle == null)
				{
					foldoutStyle = new GUIStyle( "ShurikenModuleTitle");
					foldoutStyle.font = new GUIStyle( EditorStyles.boldLabel).font;
					foldoutStyle.fontStyle = FontStyle.Bold;
					foldoutStyle.fixedHeight = 22;
					foldoutStyle.border = new RectOffset( 15, 7, 4, 4);
					foldoutStyle.contentOffset = new Vector2( 20, -2);
				}
				return foldoutStyle;
			}
		}
		static GUIStyle foldoutStyle = null;
		
		string groupCaption;
		string[] propertyNames;
		int[] foldoutIndices;
		protected MaterialProperty[] properties;
	}
}
