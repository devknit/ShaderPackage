
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ZanShader.Editor
{
	abstract class BlendStatusAtom : MaterialPropertyGroup
	{
		public BlendStatusAtom( string groupCaption, string[] propertyNames)
			: base( groupCaption, propertyNames)
		{
		}
		public override bool ValidGUI()
		{
			if( colorBlendOpProp == null
			||	colorSrcFactorProp == null
			||	colorDstFactorProp == null
			||	alphaBlendOpProp == null
			||	alphaSrcFactorProp == null
			||	alphaDstFactorProp == null)
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
			GroupFoldout = Foldout( GroupFoldout, Caption);
			
			if( GroupFoldout != false)
			{
				++EditorGUI.indentLevel;
				
				/* color */
				EditorGUI.BeginChangeCheck();
				var prevColor = BlendColorPresetParam.GetPreset( 
					colorBlendOpProp.floatValue,
					colorSrcFactorProp.floatValue,
					colorDstFactorProp.floatValue, 
					colorBlendFactorEnabledProp?.floatValue, 
					colorBlendFactorValueProp?.colorValue);
				BlendColorPreset nextColor = prevColor;
				
				colorFoldoutFlag = Foldout( colorFoldoutFlag, "Color Channel Blending", (rect) =>
				{
					var popupRect = rect;
					popupRect.xMin += rect.width / 2;
					popupRect.yMin += 1;
					nextColor = (BlendColorPreset)EditorGUI.Popup( popupRect, (int)prevColor, BlendColorPresetParam.kBlendColorPresetNames);
					rect.xMax -= rect.width / 2;
					return rect;
				});
				if( EditorGUI.EndChangeCheck() != false)
				{
					if( nextColor != prevColor)
					{
						BlendColorPresetParam colorParam;
						
						if( BlendColorPresetParam.TryGetPresetParam( nextColor, out colorParam) != false)
						{
							colorParam.SetMaterialProperty( 
								colorBlendOpProp, 
								colorSrcFactorProp, 
								colorDstFactorProp, 
								colorBlendFactorEnabledProp, 
								colorBlendFactorValueProp);
						}
					}
				}
				if( colorFoldoutFlag != false)
				{
					EditorGUILayout.BeginVertical( EditorStyles.inspectorDefaultMargins);
					{
						materialEditor.ShaderProperty( colorBlendOpProp, colorBlendOpProp.displayName);
						materialEditor.ShaderProperty( colorSrcFactorProp, colorSrcFactorProp.displayName);
						materialEditor.ShaderProperty( colorDstFactorProp, colorDstFactorProp.displayName);
						
						if( colorBlendFactorValueProp != null && colorBlendFactorEnabledProp != null)
						{
							if( Foldout( materialEditor, colorBlendFactorEnabledProp, colorBlendFactorEnabledProp.displayName + " (option)") != false)
							{
								++EditorGUI.indentLevel;
								materialEditor.ShaderProperty( colorBlendFactorValueProp, colorBlendFactorValueProp.displayName);
								--EditorGUI.indentLevel;
							}
						}
						string formula = string.Empty;
						
						if( TryGetBlendFormula( 
							(BlendOp)colorBlendOpProp.floatValue,
							(BlendMode)colorSrcFactorProp.floatValue,
							(BlendMode)colorDstFactorProp.floatValue,
							"rgb", out formula) != false)
						{
							if( colorBlendFactorEnabledProp?.floatValue != 0.0f)
							{
								formula = "src.rgb = src.rgb * src.a + PreBlendColor.rgb * (1.0 - src.a);\n" + formula;
							}
							EditorGUILayout.LabelField( new GUIContent( formula), EditorStyles.helpBox);
						}
						if( colorBlendFactorEnabledProp?.floatValue != 0.0f)
						{
							EditorGUILayout.LabelField( new GUIContent( 
								"事前に透過計算をするためにGPUへのプロパティ転送とフラグメント処理が追加されています",
								EditorGUIUtility.Load( "console.infoicon.sml") as Texture2D), EditorStyles.helpBox);
						}
					}
					EditorGUILayout.EndVertical();
				}
				/* alpha */
				EditorGUI.BeginChangeCheck();
				var prevAlpha = BlendAlphaPresetParam.GetPreset( 
					alphaBlendOpProp.floatValue,
					alphaSrcFactorProp.floatValue,
					alphaDstFactorProp.floatValue);
				BlendAlphaPreset nextAlpha = prevAlpha;
				
				alphaFoldoutFlag = Foldout( alphaFoldoutFlag, "Alpha Channel Blending", (rect) =>
				{
					var popupRect = rect;
					popupRect.xMin += rect.width / 2;
					popupRect.yMin += 1;
					nextColor = (BlendColorPreset)EditorGUI.Popup( popupRect, (int)prevAlpha, BlendColorPresetParam.kBlendAlphaPresetNames);
					rect.xMax -= rect.width / 2;
					return rect;
				});
				if( EditorGUI.EndChangeCheck() != false)
				{
					if( nextAlpha != prevAlpha)
					{
						BlendAlphaPresetParam alphaParam;
						
						if( BlendAlphaPresetParam.TryGetPresetParam( nextAlpha, out alphaParam) != false)
						{
							alphaParam.SetMaterialProperty( 
								alphaBlendOpProp, 
								alphaSrcFactorProp, 
								alphaDstFactorProp);
						}
					}
				}
				if( alphaFoldoutFlag != false)
				{
					EditorGUILayout.BeginVertical( EditorStyles.inspectorDefaultMargins);
					{
						materialEditor.ShaderProperty( alphaBlendOpProp, alphaBlendOpProp.displayName);
						materialEditor.ShaderProperty( alphaSrcFactorProp, alphaSrcFactorProp.displayName);
						materialEditor.ShaderProperty( alphaDstFactorProp, alphaDstFactorProp.displayName);
						
						string formula;
						
						if( TryGetBlendFormula( 
							(BlendOp)alphaBlendOpProp.floatValue,
							(BlendMode)alphaSrcFactorProp.floatValue,
							(BlendMode)alphaDstFactorProp.floatValue,
							"a", out formula) != false)
						{
							EditorGUILayout.LabelField( new GUIContent( formula), EditorStyles.helpBox);
						}
					}
					EditorGUILayout.EndVertical();
				}
				--EditorGUI.indentLevel;
			}
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
		static bool colorFoldoutFlag = false;
		static bool alphaFoldoutFlag = false;
		
		MaterialProperty colorBlendOpProp{ get{ return properties[ 0]; } }
		MaterialProperty colorSrcFactorProp{ get{ return properties[ 1]; } }
		MaterialProperty colorDstFactorProp{ get{ return properties[ 2]; } }
		MaterialProperty alphaBlendOpProp{ get{ return properties[ 3]; } }
		MaterialProperty alphaSrcFactorProp{ get{ return properties[ 4]; } }
		MaterialProperty alphaDstFactorProp{ get{ return properties[ 5]; } }
		MaterialProperty colorBlendFactorValueProp{ get{ return properties[ 6]; } }
		MaterialProperty colorBlendFactorEnabledProp{ get{ return properties[ 7]; } }
	}
	class BlendStatus : BlendStatusAtom
	{
		public BlendStatus() : base( "Blending Status", kPropertyNames)
		{
		}
		protected override bool GroupFoldout
		{
			get{ return foldoutFlag; }
			set{ foldoutFlag = value; }
		}
		static readonly string[] kPropertyNames = new string[]
		{
			"_ColorBlendOp",
			"_ColorSrcFactor",
			"_ColorDstFactor",
			"_AlphaBlendOp",
			"_AlphaSrcFactor",
			"_AlphaDstFactor",
			"_PreBlendColor",
			"_USE_PREBLEND"
		};
		static bool foldoutFlag = true;
	}
	class BlendStatusAdd : BlendStatusAtom
	{
		public BlendStatusAdd() : base( "Add Blending Status", kPropertyNames)
		{
		}
		protected override bool GroupFoldout
		{
			get{ return foldoutFlag; }
			set{ foldoutFlag = value; }
		}
		static readonly string[] kPropertyNames = new string[]
		{
			"_ColorBlendOpA",
			"_ColorSrcFactorA",
			"_ColorDstFactorA",
			"_AlphaBlendOpA",
			"_AlphaSrcFactorA",
			"_AlphaDstFactorA",
			"_PreBlendColorA",
			"_USE_PREBLENDA"
		};
		static bool foldoutFlag = true;
	}
}
