
using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ZanShader.Editor
{
	class InspectorGUI : ShaderGUI
	{
		public override void OnGUI( MaterialEditor materialEditor, MaterialProperty[] properties)
		{
			bool[] baseProperties = new bool[ properties.Length];
			MaterialProperty rsCullProp = null;
			MaterialProperty rsZWriteProp = null;
			MaterialProperty rsZTestProp = null;
			MaterialProperty rsColorMaskProp = null;
			MaterialProperty rsAlphaClipProp = null;
			MaterialProperty rsColorBlendOpProp = null;
			MaterialProperty rsColorSrcFactorProp = null;
			MaterialProperty rsColorDstFactorProp = null;
			MaterialProperty rsAlphaBlendOpProp = null;
			MaterialProperty rsAlphaSrcFactorProp = null;
			MaterialProperty rsAlphaDstFactorProp = null;
			MaterialProperty rsColorBlendFactorProp = null;
			MaterialProperty _fColorBlendFactorProp = null;
			MaterialProperty stencilRefProp = null;
			MaterialProperty stencilReadMaskProp = null;
			MaterialProperty stencilWriteMaskProp = null;
			MaterialProperty stencilCompProp = null;
			MaterialProperty stencilPassProp = null;
			MaterialProperty stencilFailProp = null;
			MaterialProperty stencilZFailProp = null;
			MaterialProperty property;
			int indentCount = 0;
			
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				property = properties[ i0];
				
				switch( property.name)
				{
					/* Rendering Status */
					case rsCull:
					{
						rsCullProp = property;
						break;
					}
					case rsZWrite:
					{
						rsZWriteProp = property;
						break;
					}
					case rsZTest:
					{
						rsZTestProp = property;
						break;
					}
					case rsColorMask:
					{
						rsColorMaskProp = property;
						break;
					}
					case rsAlphaClip:
					{
						rsAlphaClipProp = property;
						break;
					} 
					
					/* Blending Status */
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
					
					/* Depth Stencil Status */
					case stencilRef:
					{
						stencilRefProp = property;
						break;
					}
					case stencilReadMask:
					{
						stencilReadMaskProp = property;
						break;
					}
					case stencilWriteMask:
					{
						stencilWriteMaskProp = property;
						break;
					}
					case stencilComp:
					{
						stencilCompProp = property;
						break;
					}
					case stencilPass:
					{
						stencilPassProp = property;
						break;
					}
					case stencilFail:
					{
						stencilFailProp = property;
						break;
					}
					case stencilZFail:
					{
						stencilZFailProp = property;
						break;
					}
					
					default:
					{
						if( (property.flags & (MaterialProperty.PropFlags.HideInInspector | MaterialProperty.PropFlags.PerRendererData)) == 0)
						{
							baseProperties[ i0] = true;
						}
						break;
					}
				}
			}
			EditorGUIUtility.fieldWidth = 64; //EditorGUI.kObjectFieldThumbnailHeight;
			EditorGUIUtility.labelWidth = EditorGUIUtility.currentViewWidth * 0.5f;
			if( EditorGUIUtility.labelWidth < 204)
			{
				EditorGUIUtility.labelWidth = EditorGUIUtility.currentViewWidth - 204;
			}
			CaptionDecorator.OnBeforeGUI = () =>
			{
				if( indentCount > 0)
				{
					EditorGUI.indentLevel -= indentCount;
					indentCount = 0;
				}
			};
			CaptionDecorator.OnAfterGUI = () =>
			{
				++EditorGUI.indentLevel;
				++indentCount;
			};
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				if( baseProperties[ i0] != false)
				{
					property = properties[ i0];
					materialEditor.ShaderProperty( property, property.displayName);
				}
			}
			if( indentCount > 0)
			{
				EditorGUI.indentLevel -= indentCount;
				indentCount = 0;
			}
			CaptionDecorator.OnBeforeGUI = null;
            CaptionDecorator.OnAfterGUI = null;
			CaptionDecorator.enabled = false;
			
			/* Rendering Status */
			if( rsCullProp != null
			&&	rsZWriteProp != null
			&&	rsZTestProp != null
			&&	rsColorMaskProp != null
			&&	rsAlphaClipProp != null)
			{
				EditorGUILayout.Space();
				EditorGUILayout.BeginVertical( GUI.skin.box);
				{
					EditorGUILayout.LabelField( "Rendering Status", EditorStyles.boldLabel);
					++EditorGUI.indentLevel;
					materialEditor.ShaderProperty( rsCullProp, rsCullProp.displayName);
					materialEditor.ShaderProperty( rsZWriteProp, rsZWriteProp.displayName);
					materialEditor.ShaderProperty( rsZTestProp, rsZTestProp.displayName);
					EditorGUI.BeginChangeCheck();
					materialEditor.ShaderProperty( rsColorMaskProp, "<!>" + rsColorMaskProp.displayName);
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( rsColorMaskProp.floatValue != 15.0f)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Color Mask を RGBA 以外に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映させてよろしいですか？", "はい", "いいえ") == false)
							{
								rsColorMaskProp.floatValue = 15.0f;
							}
						}
					}
					EditorGUI.BeginChangeCheck();
					materialEditor.ShaderProperty( rsAlphaClipProp, "<!>" + rsAlphaClipProp.displayName);
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( rsAlphaClipProp.floatValue != 0.0f)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Alpha Clip を有効に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映させてよろしいですか？", "はい", "いいえ") == false)
							{
								rsAlphaClipProp.floatValue = 0.0f;
							}
						}
					}
					--EditorGUI.indentLevel;
				}
				EditorGUILayout.EndVertical();
			}
			/* Blending Status */
			if( rsColorBlendOpProp != null
			&&	rsColorSrcFactorProp != null
			&&	rsColorDstFactorProp != null
			&&	rsAlphaBlendOpProp != null
			&&	rsAlphaSrcFactorProp != null
			&&	rsAlphaDstFactorProp != null
			&&	rsColorBlendFactorProp != null
			&&	_fColorBlendFactorProp != null)
			{
				EditorGUILayout.Space();
				EditorGUILayout.BeginVertical( GUI.skin.box);
				{
					EditorGUILayout.LabelField( "Blending Status", EditorStyles.boldLabel);
					++EditorGUI.indentLevel;
					
					/* color */
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
					EditorGUILayout.BeginVertical( EditorStyles.inspectorDefaultMargins);
					{
						materialEditor.ShaderProperty( rsColorBlendOpProp, "├─ " + rsColorBlendOpProp.displayName);
						materialEditor.ShaderProperty( rsColorSrcFactorProp, "├─ " + rsColorSrcFactorProp.displayName);
						materialEditor.ShaderProperty( rsColorDstFactorProp, "├─ " + rsColorDstFactorProp.displayName);
						materialEditor.ShaderProperty( rsColorBlendFactorProp, "├─ " + rsColorBlendFactorProp.displayName);
						materialEditor.ShaderProperty( _fColorBlendFactorProp, "└─ " + _fColorBlendFactorProp.displayName);
					}
					EditorGUILayout.EndVertical();
					
					/* alpha */
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
					EditorGUILayout.BeginVertical( EditorStyles.inspectorDefaultMargins);
					{
						materialEditor.ShaderProperty( rsAlphaBlendOpProp, "├─ " + rsAlphaBlendOpProp.displayName);
						materialEditor.ShaderProperty( rsAlphaSrcFactorProp, "├─ " + rsAlphaSrcFactorProp.displayName);
						materialEditor.ShaderProperty( rsAlphaDstFactorProp, "└─ " + rsAlphaDstFactorProp.displayName);
					}
					EditorGUILayout.EndVertical();
					--EditorGUI.indentLevel;
				}
				EditorGUILayout.EndVertical();
			}
			/* Depth Stencil Status */
			if( stencilRefProp != null
			&&	stencilReadMaskProp != null
			&&	stencilWriteMaskProp != null
			&&	stencilCompProp != null
			&&	stencilPassProp != null
			&&	stencilFailProp != null
			&&	stencilZFailProp != null)
			{
				EditorGUILayout.Space();
				EditorGUILayout.BeginVertical( GUI.skin.box);
				{
					EditorGUILayout.LabelField( "Depth Stencil Status", EditorStyles.boldLabel);
					++EditorGUI.indentLevel;
					materialEditor.ShaderProperty( stencilRefProp, stencilRefProp.displayName);
					materialEditor.ShaderProperty( stencilReadMaskProp, stencilReadMaskProp.displayName);
					materialEditor.ShaderProperty( stencilWriteMaskProp, stencilWriteMaskProp.displayName);
					materialEditor.ShaderProperty( stencilCompProp, stencilCompProp.displayName);
					materialEditor.ShaderProperty( stencilPassProp, stencilPassProp.displayName);
					materialEditor.ShaderProperty( stencilFailProp, stencilFailProp.displayName);
					materialEditor.ShaderProperty( stencilZFailProp, stencilZFailProp.displayName);
					--EditorGUI.indentLevel;
				}
				EditorGUILayout.EndVertical();
			}
			
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			
			if( UnityEngine.Rendering.SupportedRenderingFeatures.active.editableMaterialRenderQueue != false)
			{
                materialEditor.RenderQueueField();
            }
            materialEditor.EnableInstancingField();
            materialEditor.DoubleSidedGIField();
            
            CaptionDecorator.enabled = true;
		}
		
		/* Rendering Status */
		const string rsCull = "_RS_Cull";
		const string rsZWrite = "_RS_ZWrite";
		const string rsZTest = "_RS_ZTest";
		const string rsColorMask = "_RS_ColorMask";
		const string rsAlphaClip = "_ALPHACLIP";
		
		/* Blending Status */
		const string rsColorBlendOp = "_RS_ColorBlendOp";
		const string rsColorSrcFactor = "_RS_ColorSrcFactor";
		const string rsColorDstFactor = "_RS_ColorDstFactor";
		const string rsAlphaBlendOp = "_RS_AlphaBlendOp";
		const string rsAlphaSrcFactor = "_RS_AlphaSrcFactor";
		const string rsAlphaDstFactor = "_RS_AlphaDstFactor";
		const string rsColorBlendFactor = "_RS_BlendFactor";
		const string _fColorBlendFactor = "_BLENDFACTOR";
		
		/* Depth Stencil Status */
		const string stencilRef = "_StencilRef";
		const string stencilReadMask = "_StencilReadMask";
		const string stencilWriteMask = "_StencilWriteMask";
		const string stencilComp = "_StencilComp";
		const string stencilPass = "_StencilPass";
		const string stencilFail = "_StencilFail";
		const string stencilZFail = "_StencilZFail";
	}
}
