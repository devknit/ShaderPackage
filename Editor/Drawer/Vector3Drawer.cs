
using UnityEditor;
using UnityEngine;

namespace ZanShader.Editor
{
	class Vector3Drawer : MaterialPropertyDrawer
	{
		public Vector3Drawer()
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( "X"),
				EditorGUIUtility.TrTextContent( "Y"),
				EditorGUIUtility.TrTextContent( "Z")
			};
		}
		public Vector3Drawer( string xElementName, string yElementName, string zElementName)
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( xElementName),
				EditorGUIUtility.TrTextContent( yElementName),
				EditorGUIUtility.TrTextContent( zElementName)
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
					"Vector3 used on a non-vector property: " + prop.name,
                    EditorGUIUtility.Load( "console.warnicon") as Texture2D);
                EditorGUI.LabelField( position, c, EditorStyles.helpBox);
                return;
			}
			
			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;
			
			var xyz = new float[]
			{
				prop.vectorValue.x, 
				prop.vectorValue.y, 
				prop.vectorValue.z
			};
			float labelWidth = EditorGUIUtility.labelWidth;
			position.height = EditorGUIUtility.singleLineHeight;
			
			EditorGUI.LabelField( position, prop.displayName);
			EditorGUI.MultiFloatField( new Rect( 
				position.x + labelWidth, position.y, 
				position.width - labelWidth, position.height), subLabels, xyz);
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = new Vector4( xyz[ 0], xyz[ 1], xyz[ 2], 0.0f);
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		readonly GUIContent[] subLabels;
	}
}
