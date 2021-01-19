
using UnityEditor;
using UnityEngine;

namespace Shaders.Editor
{
	class Property4Drawer : MaterialPropertyDrawer
	{
		public Property4Drawer()
		{
			xLabel = EditorGUIUtility.TrTextContent( "X");
			yLabel = EditorGUIUtility.TrTextContent( "Y");
			zLabel = EditorGUIUtility.TrTextContent( "Z");
			wLabel = EditorGUIUtility.TrTextContent( "W");
		}
		public Property4Drawer( string xElementName, string yElementName, string zElementName, string wElementName)
		{
			xLabel = EditorGUIUtility.TrTextContent( xElementName);
			yLabel = EditorGUIUtility.TrTextContent( yElementName);
			zLabel = EditorGUIUtility.TrTextContent( zElementName);
			wLabel = EditorGUIUtility.TrTextContent( wElementName);
		}
		public override float GetPropertyHeight( MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( IsPropertyTypeSuitable( prop) != false)
			{
				return (EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing) * 5.0f;
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
			
			Vector4 value = prop.vectorValue;
			int indentLevel = EditorGUI.indentLevel;
			position.height = EditorGUIUtility.singleLineHeight;
			
			EditorGUI.LabelField( position, prop.displayName);
			position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
			EditorGUI.indentLevel = indentLevel + 1;
			
			value.x = EditorGUI.FloatField( position, xLabel, value.x);
			position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
			value.y = EditorGUI.FloatField( position, yLabel, value.y);
			position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
			value.z = EditorGUI.FloatField( position, zLabel, value.z);
			position.y += EditorGUIUtility.singleLineHeight + EditorGUIUtility.standardVerticalSpacing;
			value.w = EditorGUI.FloatField( position, wLabel, value.w);
			
			EditorGUI.indentLevel = indentLevel;
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = value;
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		readonly GUIContent xLabel;
		readonly GUIContent yLabel;
		readonly GUIContent zLabel;
		readonly GUIContent wLabel;
		readonly bool showLabel;
	}
}
