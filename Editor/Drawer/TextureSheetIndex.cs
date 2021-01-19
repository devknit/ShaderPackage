
using UnityEditor;
using UnityEngine;

namespace Shaders.Editor
{
	class TextureSheetIndexDrawer : MaterialPropertyDrawer
	{
		public TextureSheetIndexDrawer()
		{
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( "X"),
				EditorGUIUtility.TrTextContent( "Y")
			};
		}
		public override float GetPropertyHeight( MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( IsPropertyTypeSuitable( prop) != false)
			{
				return EditorGUIUtility.singleLineHeight * 2.0f;
			}
			return EditorGUIUtility.singleLineHeight * 2.5f;
		}
		public override void OnGUI( Rect position, MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( IsPropertyTypeSuitable( prop) == false)
			{
				GUIContent c = new GUIContent( 
					"TextureSheet used on a non-vector property: " + prop.name,
                    EditorGUIUtility.Load( "console.warnicon") as Texture2D);
                EditorGUI.LabelField( position, c, EditorStyles.helpBox);
                return;
			}
			
			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;
			
			var xy = new int[]
			{
				(int)prop.vectorValue.x, 
				(int)prop.vectorValue.y
			};
			int index = (int)prop.vectorValue.z;
			
			float labelWidth = EditorGUIUtility.labelWidth;
			position.height = EditorGUIUtility.singleLineHeight;
			var tilesPosition = new Rect( 
				position.x + labelWidth, position.y, 
				position.width - labelWidth, position.height);
			var selectPosition = tilesPosition;
			selectPosition.y += EditorGUIUtility.singleLineHeight;
			
			EditorGUI.LabelField( position, prop.displayName);
			EditorGUI.MultiIntField( tilesPosition, subLabels, xy);
			
			if( xy[ 0] < 1)
			{
				xy[ 0] = 1;
			}
			if( xy[ 1] < 1)
			{
				xy[ 1] = 1;
			}
			index = EditorGUI.IntSlider( selectPosition, index, 0, xy[ 0] * xy[ 1] - 1);
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = new Vector4( xy[ 0], xy[ 1], index, 0.0f);
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		readonly GUIContent[] subLabels;
	}
}
