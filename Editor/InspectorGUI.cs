
using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ZanShader
{
	class InspectorGUI : ShaderGUI
	{
		public override void OnGUI( MaterialEditor materialEditor, MaterialProperty[] properties)
		{
			MaterialProperty rsColorBlendOpProp = null;
			MaterialProperty rsColorSrcFactorProp = null;
			MaterialProperty rsColorDstFactorProp = null;
			MaterialProperty rsAlphaBlendOpProp = null;
			MaterialProperty rsAlphaSrcFactorProp = null;
			MaterialProperty rsAlphaDstFactorProp = null;
			MaterialProperty rsColorBlendFactorProp = null;
			MaterialProperty _fColorBlendFactorProp = null;
			MaterialProperty property;
			float prevFloatValue;
			
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				property = properties[ i0];
				
				switch( property.name)
				{
					case rsColorBlendOp:
					{
						rsColorBlendOpProp = property;
						break;
					}
					case rsColorSrcFactor:
					{
						rsColorSrcFactorProp = property;
						break;
					}
					case rsColorDstFactor:
					{
						rsColorDstFactorProp = property;
						break;
					}
					case rsAlphaBlendOp:
					{
						rsAlphaBlendOpProp = property;
						break;
					}
					case rsAlphaSrcFactor:
					{
						rsAlphaSrcFactorProp = property;
						break;
					}
					case rsAlphaDstFactor:
					{
						rsAlphaDstFactorProp = property;
						break;
					}
					case rsColorBlendFactor:
					{
						rsColorBlendFactorProp = property;
						break;
					}
					case _fColorBlendFactor:
					{
						_fColorBlendFactorProp = property;
						break;
					}
				}
			}
			if( rsColorBlendOpProp != null
			&&	rsColorSrcFactorProp != null
			&&	rsColorDstFactorProp != null
			&&	rsAlphaBlendOpProp != null
			&&	rsAlphaSrcFactorProp != null
			&&	rsAlphaDstFactorProp != null
			&&	rsColorBlendFactorProp != null
			&&	_fColorBlendFactorProp != null)
			{
				EditorGUILayout.BeginVertical( GUI.skin.box);
				{
					EditorGUILayout.LabelField( "Blending Presets", EditorStyles.boldLabel);
					
					EditorGUI.BeginChangeCheck();
					var prevColor = BlendColorPresetParam.GetPreset( 
						rsColorBlendOpProp.floatValue,
						rsColorSrcFactorProp.floatValue,
						rsColorDstFactorProp.floatValue, 
						_fColorBlendFactorProp.floatValue, 
						rsColorBlendFactorProp.colorValue);
					var nextColor = (BlendColorPreset)EditorGUILayout.EnumPopup( "Color Channel Blending", prevColor);
					
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( nextColor != prevColor)
						{
							BlendColorPresetParam colorParam;
							
							if( BlendColorPresetParam.TryGetPresetParam( nextColor, out colorParam) != false)
							{
								colorParam.SetMaterialProperty( 
									rsColorBlendOpProp, 
									rsColorSrcFactorProp, 
									rsColorDstFactorProp, 
									_fColorBlendFactorProp, 
									rsColorBlendFactorProp);
							}
						}
					}
					EditorGUI.BeginChangeCheck();
					var prevAlpha = BlendAlphaPresetParam.GetPreset( 
						rsAlphaBlendOpProp.floatValue,
						rsAlphaSrcFactorProp.floatValue,
						rsAlphaDstFactorProp.floatValue);
					var nextAlpha = (BlendAlphaPreset)EditorGUILayout.EnumPopup( "Alpha Channel Blending", prevAlpha);
					
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( nextAlpha != prevAlpha)
						{
							BlendAlphaPresetParam alphaParam;
							
							if( BlendAlphaPresetParam.TryGetPresetParam( nextAlpha, out alphaParam) != false)
							{
								alphaParam.SetMaterialProperty( 
									rsAlphaBlendOpProp, 
									rsAlphaSrcFactorProp, 
									rsAlphaDstFactorProp);
							}
						}
					}
				}
				EditorGUILayout.EndVertical();
			}
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				property = properties[ i0];
				prevFloatValue = property.floatValue;
				materialEditor.ShaderProperty( property, property.displayName);
				
				switch( property.name)
				{
					case rsColorMask:
					{
						if( property.floatValue != 15.0f && property.floatValue != prevFloatValue)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Color Mask を RGBA 以外に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映させてよろしいですか？", "はい", "いいえ") == false)
							{
								property.floatValue = prevFloatValue;
							}
						}
						break;
					}
					case rsAlphaClip:
					{
						if( property.floatValue != 0.0f && property.floatValue != prevFloatValue)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Alpha Clip を有効に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映させてよろしいですか？", "はい", "いいえ") == false)
							{
								property.floatValue = prevFloatValue;
							}
						}
						break;
					}
				}
			}
		}
		
		const string rsColorBlendOp = "_RS_ColorBlendOp";
		const string rsColorSrcFactor = "_RS_ColorSrcFactor";
		const string rsColorDstFactor = "_RS_ColorDstFactor";
		const string rsAlphaBlendOp = "_RS_AlphaBlendOp";
		const string rsAlphaSrcFactor = "_RS_AlphaSrcFactor";
		const string rsAlphaDstFactor = "_RS_AlphaDstFactor";
		const string rsColorBlendFactor = "_RS_BlendFactor";
		const string _fColorBlendFactor = "_BLENDFACTOR";
		
		const string rsColorMask = "_RS_ColorMask";
		const string rsAlphaClip = "_ALPHACLIP";
		
	}
}
