
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace ZanShader.Editor
{
	class LightDrawer : MaterialPropertyDrawer
	{
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
					"Light used on a non-vector property: " + prop.name,
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
			
			float buttonWidth = (position.width - labelWidth) * 0.25f;
			float fieldWidth = buttonWidth * 3.0f;
			
			EditorGUI.LabelField( position, prop.displayName);
			EditorGUI.MultiFloatField( new Rect( 
				position.x + labelWidth, position.y, 
				fieldWidth, position.height), kSubLabels, xyz);
			
			if( GUI.Button( new Rect( 
				position.x + labelWidth + fieldWidth + 4, 
				position.y, buttonWidth - 4, position.height), "Light") != false)
			{
				Vector3 direction;
				
				if( TryGetDirectionalLightDirection( out direction) != false)
				{
					xyz[ 0] = direction.x;
					xyz[ 1] = direction.y;
					xyz[ 2] = direction.z;
				}
			}
			EditorGUI.showMixedValue = false;
			
			if( EditorGUI.EndChangeCheck() != false)
			{
				prop.vectorValue = new Vector4( xyz[ 0], xyz[ 1], xyz[ 2], 0.0f);
			}
		}
		static bool TryGetDirectionalLightDirection( out Vector3 direction)
		{
			for( int i0 = 0; i0 < SceneManager.sceneCount; ++i0)
			{
				var scene = SceneManager.GetSceneAt( i0);
				var gameObjects = scene.GetRootGameObjects();
				
				for( int i1 = 0; i1 < gameObjects.Length; ++i1)
				{
					var lights = gameObjects[ i1].GetComponentsInChildren<Light>();
					for( int i2 = 0; i2 < lights.Length; ++i2)
					{
						var light = lights[ i2];
						
						if( light.type == LightType.Directional)
						{
							direction = -light.transform.forward;
							return true;
						}
					}
				}
			}
			direction = Vector3.zero;
			return false;
		}
		static bool IsPropertyTypeSuitable( MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Vector;
        }
		static readonly GUIContent[] kSubLabels = new GUIContent[]
		{
			EditorGUIUtility.TrTextContent( "X"),
			EditorGUIUtility.TrTextContent( "Y"),
			EditorGUIUtility.TrTextContent( "Z")
		};
	}
}
