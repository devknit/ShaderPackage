
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
			MaterialProperty rsZWriteBProp = null;
			MaterialProperty rsZWriteAProp = null;
			MaterialProperty rsZTestProp = null;
			MaterialProperty rsZTestBProp = null;
			MaterialProperty rsZTestAProp = null;
			MaterialProperty rsColorMaskProp = null;
			MaterialProperty rsAlphaClipProp = null;
			MaterialProperty rsAlphaClipThresholdProp = null;
			
			BlendState rsBlendState = null;
			BlendState rsBlendStateB = null;
			BlendState rsBlendStateA = null;
			
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
					case rsZWriteB:
					{
						rsZWriteBProp = property;
						break;
					}
					case rsZWriteA:
					{
						rsZWriteAProp = property;
						break;
					}
					case rsZTest:
					{
						rsZTestProp = property;
						break;
					}
					case rsZTestB:
					{
						rsZTestBProp = property;
						break;
					}
					case rsZTestA:
					{
						rsZTestAProp = property;
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
					case rsAlphaClipThreshold:
					{
						rsAlphaClipThresholdProp = property;
						break;
					}
					
					/* Blending Status */
					case rsColorBlendOp:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsColorBlendOpProp = property;
						break;
					}
					case rsColorSrcFactor:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsColorSrcFactorProp = property;
						break;
					}
					case rsColorDstFactor:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsColorDstFactorProp = property;
						break;
					}
					case rsAlphaBlendOp:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsAlphaBlendOpProp = property;
						break;
					}
					case rsAlphaSrcFactor:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsAlphaSrcFactorProp = property;
						break;
					}
					case rsAlphaDstFactor:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsAlphaDstFactorProp = property;
						break;
					}
					case rsColorBlendFactor:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState.rsColorBlendFactorProp = property;
						break;
					}
					case _fColorBlendFactor:
					{
						if( rsBlendState == null)
						{
							rsBlendState = new BlendState();
						}
						rsBlendState._fColorBlendFactorProp = property;
						break;
					}
					
					/* Forward Base Blending Status */
					case rsColorBlendOpB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsColorBlendOpProp = property;
						break;
					}
					case rsColorSrcFactorB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsColorSrcFactorProp = property;
						break;
					}
					case rsColorDstFactorB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsColorDstFactorProp = property;
						break;
					}
					case rsAlphaBlendOpB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsAlphaBlendOpProp = property;
						break;
					}
					case rsAlphaSrcFactorB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsAlphaSrcFactorProp = property;
						break;
					}
					case rsAlphaDstFactorB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsAlphaDstFactorProp = property;
						break;
					}
					case rsColorBlendFactorB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB.rsColorBlendFactorProp = property;
						break;
					}
					case _fColorBlendFactorB:
					{
						if( rsBlendStateB == null)
						{
							rsBlendStateB = new BlendState();
						}
						rsBlendStateB._fColorBlendFactorProp = property;
						break;
					}
					
					/* Forward Add Blending Status */
					case rsColorBlendOpA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsColorBlendOpProp = property;
						break;
					}
					case rsColorSrcFactorA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsColorSrcFactorProp = property;
						break;
					}
					case rsColorDstFactorA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsColorDstFactorProp = property;
						break;
					}
					case rsAlphaBlendOpA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsAlphaBlendOpProp = property;
						break;
					}
					case rsAlphaSrcFactorA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsAlphaSrcFactorProp = property;
						break;
					}
					case rsAlphaDstFactorA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsAlphaDstFactorProp = property;
						break;
					}
					case rsColorBlendFactorA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA.rsColorBlendFactorProp = property;
						break;
					}
					case _fColorBlendFactorA:
					{
						if( rsBlendStateA == null)
						{
							rsBlendStateA = new BlendState();
						}
						rsBlendStateA._fColorBlendFactorProp = property;
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
			||	rsZWriteProp != null
			||	rsZWriteBProp != null
			||	rsZWriteAProp != null
			||	rsZTestProp != null
			||	rsZTestBProp != null
			||	rsZTestAProp != null
			||	rsColorMaskProp != null
			||	rsAlphaClipProp != null
			||	rsAlphaClipThreshold != null)
			{
				EditorGUILayout.Space();
				EditorGUILayout.BeginVertical( GUI.skin.box);
				{
					EditorGUILayout.LabelField( "Rendering Status", EditorStyles.boldLabel);
					++EditorGUI.indentLevel;
					if( rsCullProp != null)
					{
						materialEditor.ShaderProperty( rsCullProp, rsCullProp.displayName);
					}
					if( rsZWriteProp != null)
					{
						materialEditor.ShaderProperty( rsZWriteProp, rsZWriteProp.displayName);
					}
					if( rsZTestProp != null)
					{
						materialEditor.ShaderProperty( rsZTestProp, rsZTestProp.displayName);
					}
					if( rsZWriteBProp != null)
					{
						materialEditor.ShaderProperty( rsZWriteBProp, rsZWriteBProp.displayName);
					}
					if( rsZTestBProp != null)
					{
						materialEditor.ShaderProperty( rsZTestBProp, rsZTestBProp.displayName);
					}
					if( rsZWriteAProp != null)
					{
						materialEditor.ShaderProperty( rsZWriteAProp, rsZWriteAProp.displayName);
					}
					if( rsZTestAProp != null)
					{
						materialEditor.ShaderProperty( rsZTestAProp, rsZTestAProp.displayName);
					}
					if( rsColorMaskProp != null)
					{
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
		            }
					if( rsAlphaClipProp != null)
					{
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
							if( rsAlphaClipThresholdProp != null)
							{
								materialEditor.ShaderProperty( rsAlphaClipThresholdProp, rsAlphaClipThresholdProp.displayName);
							}
		                	EditorGUILayout.LabelField( new GUIContent( 
								"Alpha Clip の設定がモバイルでは高負荷となる状態です\n設定を無効に変更することで解消されます",
		                    	EditorGUIUtility.Load( "console.warnicon.sml") as Texture2D), EditorStyles.helpBox);
						}
					}
					--EditorGUI.indentLevel;
				}
				EditorGUILayout.EndVertical();
			}
			/* Blending Status */
			if( rsBlendState != null)
			{
				rsBlendState.OnGUI( "Blending Status", materialEditor);
			}
			if( rsBlendStateB != null)
			{
				rsBlendStateB.OnGUI( "Forward Base Blending Status", materialEditor);
			}
			if( rsBlendStateA != null)
			{
				rsBlendStateA.OnGUI( "Forward Add Blending Status", materialEditor);
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
		void SetKeyword( MaterialProperty prop, bool on, string defaultKeywordSuffix)
        {
            string keyword = prop.name.ToUpperInvariant() + defaultKeywordSuffix;
            foreach( Material material in prop.targets)
            {
                if( on != false)
                {
                    material.EnableKeyword( keyword);
                }
                else
                {
                    material.DisableKeyword( keyword);
                }
            }
        }
		
		/* Rendering Status */
		const string rsCull = "_RS_Cull";
		const string rsZWrite = "_RS_ZWrite";
		const string rsZWriteB = "_RS_FB_ZWrite";
		const string rsZWriteA = "_RS_FA_ZWrite";
		const string rsZTest = "_RS_ZTest";
		const string rsZTestB = "_RS_FB_ZTest";
		const string rsZTestA = "_RS_FA_ZTest";
		const string rsColorMask = "_RS_ColorMask";
		const string rsAlphaClip = "_ALPHACLIP";
		const string rsAlphaClipThreshold = "_AlphaClipThreshold";
		
		/* Blending Status */
		const string rsColorBlendOp = "_RS_ColorBlendOp";
		const string rsColorSrcFactor = "_RS_ColorSrcFactor";
		const string rsColorDstFactor = "_RS_ColorDstFactor";
		const string rsAlphaBlendOp = "_RS_AlphaBlendOp";
		const string rsAlphaSrcFactor = "_RS_AlphaSrcFactor";
		const string rsAlphaDstFactor = "_RS_AlphaDstFactor";
		const string rsColorBlendFactor = "_RS_BlendFactor";
		const string _fColorBlendFactor = "_BLENDFACTOR";
		
		/* Forward Base Blending Status */
		const string rsColorBlendOpB = "_RS_FB_ColorBlendOp";
		const string rsColorSrcFactorB = "_RS_FB_ColorSrcFactor";
		const string rsColorDstFactorB = "_RS_FB_ColorDstFactor";
		const string rsAlphaBlendOpB = "_RS_FB_AlphaBlendOp";
		const string rsAlphaSrcFactorB = "_RS_FB_AlphaSrcFactor";
		const string rsAlphaDstFactorB = "_RS_FB_AlphaDstFactor";
		const string rsColorBlendFactorB = "_RS_FB_BlendFactor";
		const string _fColorBlendFactorB = "_FB_BLENDFACTOR";
		
		/* Forward Base Blending Status */
		const string rsColorBlendOpA = "_RS_FA_ColorBlendOp";
		const string rsColorSrcFactorA = "_RS_FA_ColorSrcFactor";
		const string rsColorDstFactorA = "_RS_FA_ColorDstFactor";
		const string rsAlphaBlendOpA = "_RS_FA_AlphaBlendOp";
		const string rsAlphaSrcFactorA = "_RS_FA_AlphaSrcFactor";
		const string rsAlphaDstFactorA = "_RS_FA_AlphaDstFactor";
		const string rsColorBlendFactorA = "_RS_FA_BlendFactor";
		const string _fColorBlendFactorA = "_FA_BLENDFACTOR";
		
		/* Depth Stencil Status */
		const string stencilRef = "_StencilRef";
		const string stencilReadMask = "_StencilReadMask";
		const string stencilWriteMask = "_StencilWriteMask";
		const string stencilComp = "_StencilComp";
		const string stencilPass = "_StencilPass";
		const string stencilFail = "_StencilFail";
		const string stencilZFail = "_StencilZFail";
	}
	class BlendState
	{
		public void OnGUI( string caption, MaterialEditor materialEditor)
		{
			if( rsColorBlendOpProp == null
			||	rsColorSrcFactorProp == null
			||	rsColorDstFactorProp == null
			||	rsAlphaBlendOpProp == null
			||	rsAlphaSrcFactorProp == null
			||	rsAlphaDstFactorProp == null
			||	rsColorBlendFactorProp == null
			||	_fColorBlendFactorProp == null)
			{
				return;
			}
			EditorGUILayout.Space();
			EditorGUILayout.BeginVertical( GUI.skin.box);
			{
				EditorGUILayout.LabelField( caption, EditorStyles.boldLabel);
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
		public MaterialProperty rsColorBlendOpProp = null;
		public MaterialProperty rsColorSrcFactorProp = null;
		public MaterialProperty rsColorDstFactorProp = null;
		public MaterialProperty rsAlphaBlendOpProp = null;
		public MaterialProperty rsAlphaSrcFactorProp = null;
		public MaterialProperty rsAlphaDstFactorProp = null;
		public MaterialProperty rsColorBlendFactorProp = null;
		public MaterialProperty _fColorBlendFactorProp = null;
	}
}
