
using UnityEditor;
using UnityEngine;

namespace ZanShader.Editor
{
	class RenderingStatus : MaterialPropertyGroup
	{
		public RenderingStatus() : base( "Rendering Status", kPropertyNames)
		{
		}
		static readonly string[] kPropertyNames = new string[]
		{
			"_Cull",
			"_ZWrite",
			"_ZWriteA",
			"_ZTest",
			"_ZTestA",
			"_ColorMask",
			"_ALPHACLIP",
			"_AlphaClipThreshold",
			"_DITHERING",
		};
		public override bool ValidGUI()
		{
			if( cullProp == null
			||	(zWriteProp == null && zWriteAddProp == null)
			||	(zTestProp == null && zTestAddProp == null)
			||	colorMaskProp == null)
			{
				return false;
			}
			return true;
		}
		public override void OnGUI( MaterialEditor materialEditor)
		{
			if( ValidGUI() == false)
			{
				return;
			}
			foldoutFlag = Foldout( foldoutFlag, Caption);
			
			if( foldoutFlag != false)
			{
				++EditorGUI.indentLevel;
				
				if( cullProp != null)
				{
					materialEditor.ShaderProperty( cullProp, cullProp.displayName);
				}
				if( zWriteProp != null)
				{
					materialEditor.ShaderProperty( zWriteProp, zWriteProp.displayName);
				}
				if( zTestProp != null)
				{
					materialEditor.ShaderProperty( zTestProp, zTestProp.displayName);
				}
				if( zWriteAddProp != null)
				{
					materialEditor.ShaderProperty( zWriteAddProp, zWriteAddProp.displayName);
				}
				if( zTestAddProp != null)
				{
					materialEditor.ShaderProperty( zTestAddProp, zTestAddProp.displayName);
				}
				if( colorMaskProp != null)
				{
					EditorGUI.BeginChangeCheck();
					materialEditor.ShaderProperty( colorMaskProp, colorMaskProp.displayName);
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( colorMaskProp.floatValue != 15.0f)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Color Mask を RGBA 以外に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映してもよろしいですか？", "はい", "いいえ") == false)
							{
								colorMaskProp.floatValue = 15.0f;
							}
						}
					}
					if( colorMaskProp.floatValue != 15.0f)
					{
						EditorGUILayout.LabelField( new GUIContent( 
							"Color Mask の設定がモバイルでは高負荷となる状態です\n設定をRGBAに変更することで解消されます",
							EditorGUIUtility.Load( "console.warnicon.sml") as Texture2D), EditorStyles.helpBox);
					}
				}
				if( alphaClipProp != null)
				{
					EditorGUI.BeginChangeCheck();
					materialEditor.ShaderProperty( alphaClipProp, alphaClipProp.displayName);
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( alphaClipProp.floatValue != 0.0f)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Alpha Clip を有効に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映してもよろしいですか？", "はい", "いいえ") == false)
							{
								alphaClipProp.floatValue = 0.0f;
							}
						}
					}
					if( alphaClipProp.floatValue != 0.0f)
					{
						if( alphaClipThresholdProp != null)
						{
							materialEditor.ShaderProperty( alphaClipThresholdProp, alphaClipThresholdProp.displayName);
						}
						EditorGUILayout.LabelField( new GUIContent( 
							"Alpha Clip の設定がモバイルでは高負荷となる状態です\n設定を無効に変更することで解消されます",
							EditorGUIUtility.Load( "console.warnicon.sml") as Texture2D), EditorStyles.helpBox);
					}
				}
				if( ditheringProp != null)
				{
					materialEditor.ShaderProperty( ditheringProp, ditheringProp.displayName);
					
					if( ditheringProp.floatValue != 0.0f
					&&	alphaClipProp != null && alphaClipProp.floatValue == 0.0f)
					{
						EditorGUILayout.LabelField( new GUIContent( 
								"Alpha Clip の設定を有効にすることで擬似的な半透明として描画されます",
								EditorGUIUtility.Load( "console.infoicon.sml") as Texture2D), EditorStyles.helpBox);
					}
				}
				--EditorGUI.indentLevel;
			}
		}
		static bool foldoutFlag = false;
		MaterialProperty cullProp{ get{ return properties[ 0]; } }
		MaterialProperty zWriteProp{ get{ return properties[ 1]; } }
		MaterialProperty zWriteAddProp{ get{ return properties[ 2]; } }
		MaterialProperty zTestProp{ get{ return properties[ 3]; } }
		MaterialProperty zTestAddProp{ get{ return properties[ 4]; } }
		MaterialProperty colorMaskProp{ get{ return properties[ 5]; } }
		MaterialProperty alphaClipProp{ get{ return properties[ 6]; } }
		MaterialProperty alphaClipThresholdProp{ get{ return properties[ 7]; } }
		MaterialProperty ditheringProp{ get{ return properties[ 8]; } }
	}
}
