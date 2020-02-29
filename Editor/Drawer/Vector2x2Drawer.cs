
using UnityEditor;
using UnityEngine;

namespace ZanShader.Editor
{
	class Vector2x2Drawer : MaterialPropertyDrawer
	{
		public Vector2x2Drawer( string xyName, string zwName)
		{
			xyLabel = EditorGUIUtility.TrTextContent( xyName);
			zwLabel = EditorGUIUtility.TrTextContent( zwName);
			subLabels = new GUIContent[]
			{
				EditorGUIUtility.TrTextContent( "X"),
				EditorGUIUtility.TrTextContent( "Y")
			};
		}
		public Vector2x2Drawer( string xyName, string zwName, string xElementName, string yElementName)
		{
			xyLabel = EditorGUIUtility.TrTextContent( xyName);
			zwLabel = EditorGUIUtility.TrTextContent( zwName);
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
				return (EditorGUIUtility.singleLineHeight + kHeightInterval) * 3;
			}
			return base.GetPropertyHeight( prop, label, editor);
		}
		public override void OnGUI( Rect position, MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( IsPropertyTypeSuitable( prop) == false)
			{
				GUIContent c = new GUIContent( 
					"Vector2x2 used on a non-vector property: " + prop.name,
                    EditorGUIUtility.Load( "console.warnicon") as Texture2D);
                EditorGUI.LabelField( position, c, EditorStyles.helpBox);
                return;
			}
			
			EditorGUI.BeginChangeCheck();
			
			var xy = new float[]{ prop.vectorValue.x, prop.vectorValue.y };
			var zw = new float[]{ prop.vectorValue.z, prop.vectorValue.w };
			
			float labelWidth = EditorGUIUtility.labelWidth;
			position.height = EditorGUIUtility.singleLineHeight;
			
			EditorGUI.LabelField( position, prop.displayName);
			position.y += EditorGUIUtility.singleLineHeight + kHeightInterval;
			
			var labelRect = new Rect( position.x + kIndentWidth, position.y, labelWidth, position.height);
			var valueRect = new Rect( position.x + labelWidth, position.y, position.width - labelWidth, position.height);
			EditorGUI.PrefixLabel( labelRect, xyLabel);
			EditorGUI.MultiFloatField( valueRect, subLabels, xy);
			
			labelRect.y += EditorGUIUtility.singleLineHeight + kHeightInterval;
			valueRect.y += EditorGUIUtility.singleLineHeight + kHeightInterval;
			EditorGUI.PrefixLabel( labelRect, zwLabel);
			EditorGUI.MultiFloatField( valueRect, subLabels, zw);
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = new Vector4( xy[ 0], xy[ 1], zw[ 0], zw[ 1]);
			}
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		
		const float kIndentWidth = 15;
		const float kHeightInterval = 2;
		
		readonly GUIContent xyLabel;
		readonly GUIContent zwLabel;
		readonly GUIContent[] subLabels;
	}
}
