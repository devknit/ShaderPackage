
using UnityEditor;
using UnityEngine;

namespace Shaders.Editor
{
	class Vector2Drawer : MaterialPropertyDrawer
	{
		public Vector2Drawer()
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( "X"),
				EditorGUIUtility.TrTextContent( "Y")
			};
		}
		public Vector2Drawer( string xElementName, string yElementName)
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( xElementName),
				EditorGUIUtility.TrTextContent( yElementName)
			};
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
					"Vector2 used on a non-vector property: " + prop.name,
                    EditorGUIUtility.Load( "console.warnicon") as Texture2D);
                EditorGUI.LabelField( position, c, EditorStyles.helpBox);
                return;
			}
			
			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;
			
			var xy = new float[]
			{
				prop.vectorValue.x, 
				prop.vectorValue.y
			};
			float labelWidth = EditorGUIUtility.labelWidth;
			position.height = EditorGUIUtility.singleLineHeight;
			
			EditorGUI.LabelField( position, prop.displayName);
			EditorGUI.MultiFloatField( new Rect( 
				position.x + labelWidth, position.y, 
				position.width - labelWidth, position.height), subLabels, xy);
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = new Vector4( xy[ 0], xy[ 1], 0.0f, 0.0f);
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		readonly GUIContent[] subLabels;
	}
}
