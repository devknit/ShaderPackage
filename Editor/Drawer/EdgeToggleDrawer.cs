
using UnityEditor;
using UnityEngine;

namespace ZanShader.Editor
{
	class EdgeToggleDrawer : MaterialPropertyDrawer
	{
		public EdgeToggleDrawer()
		{
		}
		public EdgeToggleDrawer( string keyword)
		{
			this.keyword = keyword;
		}
		public EdgeToggleDrawer( bool leftSide)
		{
			this.leftSide = leftSide;
		}
		public override float GetPropertyHeight( MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( IsPropertyTypeSuitable( prop) != false)
			{
				return EditorGUIUtility.singleLineHeight;
			}
			return EditorGUIUtility.singleLineHeight * 2.5f;
		}
		public override void OnGUI( Rect position, MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( IsPropertyTypeSuitable( prop) == false)
			{
				GUIContent c = new GUIContent( 
					"ToggleRight used on a non-float property: " + prop.name,
					EditorGUIUtility.Load( "console.warnicon") as Texture2D);
				EditorGUI.LabelField( position, c, EditorStyles.helpBox);
				return;
			}
			
			EditorGUI.BeginChangeCheck();
			
			bool value = System.Math.Abs( prop.floatValue) > 0.001f;
			EditorGUI.showMixedValue = prop.hasMixedValue;
			
			if( leftSide == false)
			{
				EditorGUI.LabelField( position, label);
				position.x += position.width - 32;
				position.width = 32;
				value = EditorGUI.Toggle( position, value);
			}
			else
			{
				value = EditorGUI.ToggleLeft( position, label, value);
			}
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.floatValue = value ? 1.0f : 0.0f;
				SetKeyword( prop, value);
			}
		}
		void SetKeyword(MaterialProperty prop, bool on)
		{
			SetKeywordInternal( prop, on, "_ON");
		}
		void SetKeywordInternal( MaterialProperty prop, bool on, string defaultKeywordSuffix)
		{
			string kw = string.IsNullOrEmpty( keyword) ? prop.name.ToUpperInvariant() + defaultKeywordSuffix : keyword;
			foreach( Material material in prop.targets)
			{
				if( on != false)
				{
					material.EnableKeyword( kw);
				}
				else
				{
					material.DisableKeyword( kw);
				}
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
		{
			return prop.type == MaterialProperty.PropType.Float || prop.type == MaterialProperty.PropType.Range;
		}
		
		readonly string keyword;
		readonly bool leftSide;
	}
}
