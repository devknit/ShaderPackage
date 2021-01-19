
using UnityEditor;
using UnityEngine;

namespace Shaders.Editor
{
	class Vector4Drawer : MaterialPropertyDrawer
	{
		public Vector4Drawer()
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( "X"),
				EditorGUIUtility.TrTextContent( "Y"),
				EditorGUIUtility.TrTextContent( "Z"),
				EditorGUIUtility.TrTextContent( "W")
			};
		}
		public Vector4Drawer( string xElementName, string yElementName, string zElementName, string wElementName)
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( xElementName),
				EditorGUIUtility.TrTextContent( yElementName),
				EditorGUIUtility.TrTextContent( zElementName),
				EditorGUIUtility.TrTextContent( wElementName)
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
					"Vector4 used on a non-vector property: " + prop.name,
                    EditorGUIUtility.Load( "console.warnicon") as Texture2D);
                EditorGUI.LabelField( position, c, EditorStyles.helpBox);
                return;
			}
			
			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;
			
			var xyzw = new float[]
			{
				prop.vectorValue.x, 
				prop.vectorValue.y, 
				prop.vectorValue.z,
				prop.vectorValue.w
			};
			float labelWidth = EditorGUIUtility.labelWidth;
			position.height = EditorGUIUtility.singleLineHeight;
			
			EditorGUI.LabelField( position, prop.displayName);
			EditorGUI.MultiFloatField( new Rect( 
				position.x + labelWidth, position.y, 
				position.width - labelWidth, position.height), subLabels, xyzw);
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = new Vector4( xyzw[ 0], xyzw[ 1], xyzw[ 2], xyzw[ 3]);
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		readonly GUIContent[] subLabels;
	}
}
