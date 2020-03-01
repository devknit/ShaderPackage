
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
			CaptionDecorator.OnBeforeGUI = (position) =>
			{
				if( indentCount > 0)
				{
					position.height = 1;
					EditorGUI.DrawRect( position, Color.gray);
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
					materialEditor.ShaderProperty( rsColorMaskProp, rsColorMaskProp.displayName);
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( rsColorMaskProp.floatValue != 15.0f)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Color Mask を RGBA 以外に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映してもよろしいですか？", "はい", "いいえ") == false)
							{
								rsColorMaskProp.floatValue = 15.0f;
							}
						}
					}
					if( rsColorMaskProp.floatValue != 15.0f)
					{
	                	EditorGUILayout.LabelField( new GUIContent( 
							"Color Mask の設定がモバイルでは高負荷となる状態です\n設定をRGBAに変更することで解消されます",
	                    	EditorGUIUtility.Load( "console.warnicon.sml") as Texture2D), EditorStyles.helpBox);
	                }
					
					EditorGUI.BeginChangeCheck();
					materialEditor.ShaderProperty( rsAlphaClipProp, rsAlphaClipProp.displayName);
					if( EditorGUI.EndChangeCheck() != false)
					{
						if( rsAlphaClipProp.floatValue != 0.0f)
						{
							if( EditorUtility.DisplayDialog( "Warning", "Alpha Clip を有効に設定すると\nモバイル環境で高負荷となります。\n\n設定を反映してもよろしいですか？", "はい", "いいえ") == false)
							{
								rsAlphaClipProp.floatValue = 0.0f;
							}
						}
					}
					if( rsAlphaClipProp.floatValue != 0.0f)
					{
	                	EditorGUILayout.LabelField( new GUIContent( 
							"Alpha Clip の設定がモバイルでは高負荷となる状態です\n設定を無効に変更することで解消されます",
	                    	EditorGUIUtility.Load( "console.warnicon.sml") as Texture2D), EditorStyles.helpBox);
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
					var nextColor = (BlendColorPreset)EditorGUILayout.Popup( 
						"Color Channel Blending", (int)prevColor, BlendColorPresetParam.kBlendColorPresetNames);
					
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
						
						string formula;
						
						if( TryGetBlendFormula( 
							(BlendOp)rsColorBlendOpProp.floatValue,
							(BlendMode)rsColorSrcFactorProp.floatValue,
							(BlendMode)rsColorDstFactorProp.floatValue,
							"rgb", out formula) != false)
						{
							if( _fColorBlendFactorProp.floatValue != 0.0f)
							{
								formula = "src.rgb = src.rgb * src.a + BlendFacter.rgb * (1.0 - src.a);\n" + formula;
							}
							EditorGUILayout.LabelField( new GUIContent( formula), EditorStyles.helpBox);
						}
						if( _fColorBlendFactorProp.floatValue != 0.0f)
						{
		                	EditorGUILayout.LabelField( new GUIContent( 
								"事前に透過計算をするためにGPUへのプロパティ転送とフラグメント演算が追加されています",
		                    	EditorGUIUtility.Load( "console.infoicon.sml") as Texture2D), EditorStyles.helpBox);
		                }
					}
					EditorGUILayout.EndVertical();
					
					/* alpha */
					EditorGUI.BeginChangeCheck();
					var prevAlpha = BlendAlphaPresetParam.GetPreset( 
						rsAlphaBlendOpProp.floatValue,
						rsAlphaSrcFactorProp.floatValue,
						rsAlphaDstFactorProp.floatValue);
					var nextAlpha = (BlendAlphaPreset)EditorGUILayout.Popup( 
						"Alpha Channel Blending", (int)prevAlpha, BlendAlphaPresetParam.kBlendAlphaPresetNames);
					
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
						
						string formula;
						
						if( TryGetBlendFormula( 
							(BlendOp)rsAlphaBlendOpProp.floatValue,
							(BlendMode)rsAlphaSrcFactorProp.floatValue,
							(BlendMode)rsAlphaDstFactorProp.floatValue,
							"a", out formula) != false)
						{
							EditorGUILayout.LabelField( new GUIContent( formula), EditorStyles.helpBox);
						}
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
		static bool TryGetBlendFormula( BlendOp blendOp, BlendMode srcFactor, BlendMode dstFactor, string swizzle, out string formula)
		{
			string format, srcValue, dstValue;
			formula = string.Empty;
			
			if( TryGetBlendOpFormat( blendOp, swizzle, out format) != false
			&&	TryGetBlendFactorValue( srcFactor, out srcValue) != false
			&&	TryGetBlendFactorValue( dstFactor, out dstValue) != false)
			{
				formula = string.Format( format, srcValue, dstValue);
			}
			return string.IsNullOrEmpty( formula) == false;
		}
		static bool TryGetBlendOpFormat( BlendOp blendOp, string swizzle, out string format)
		{
			format = string.Empty;
			
			switch( blendOp)
			{
				case BlendOp.Add:
				{
					format = string.Format( "{0} = dst.{0} * {1} + src.{0} * {2};", swizzle, "{1}", "{0}");
					break;
				}
				case BlendOp.Subtract:
				{
					format = string.Format( "{0} = src.{0} * {1} - dst.{0} * {2};", swizzle, "{1}", "{0}");
					break;
				}
				case BlendOp.ReverseSubtract:
				{
					format = string.Format( "{0} = dst.{0} * {1} - src.{0} * {2};", swizzle, "{1}", "{0}");
					break;
				}
				case BlendOp.Min:
				{
					format = string.Format( "{0} = min( dst.{0}, src.{0});", swizzle);
					break;
				}
				case BlendOp.Max:
				{
					format = string.Format( "{0} = max( dst.{0}, src.{0});", swizzle);
					break;
				}
			}
			return string.IsNullOrEmpty( format) == false;
		}
		static bool TryGetBlendFactorValue( BlendMode factor, out string value)
		{
			value = string.Empty;
			
			switch( factor)
			{
				case BlendMode.Zero:
				{
					value = "0.0";
					break;
				}
				case BlendMode.One:
				{
					value = "1.0";
					break;
				}
				case BlendMode.DstColor:
				{
					value = "dst.rgb";
					break;
				}
				case BlendMode.SrcColor:
				{
					value = "src.rgb";
					break;
				}
				case BlendMode.OneMinusDstColor:
				{
					value = "(1.0 - dst.rgb)";
					break;
				}
				case BlendMode.SrcAlpha:
				{
					value = "src.a";
					break;
				}
				case BlendMode.OneMinusSrcColor:
				{
					value = "(1.0 - src.rgb)";
					break;
				}
				case BlendMode.DstAlpha:
				{
					value = "dst.a";
					break;
				}
				case BlendMode.OneMinusDstAlpha:
				{
					value = "(1.0 - dst.a)";
					break;
				}
				case BlendMode.SrcAlphaSaturate:
				{
					value = "min( 1.0 - dst.a, src.a)";
					break;
				}
				case BlendMode.OneMinusSrcAlpha:
				{
					value = "(1.0 - src.a)";
					break;
				}
			}
			return string.IsNullOrEmpty( value) == false;
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
