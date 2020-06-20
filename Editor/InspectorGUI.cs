
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using System;
using System.Collections.Generic;

namespace ZanShader.Editor
{
	public class InspectorGUI : ShaderGUI
	{
		protected virtual void OnPropertiesGUI( MaterialEditor materialEditor, List<MaterialProperty> properties)
		{
			foreach( var property in properties)
			{
				materialEditor.ShaderProperty( property, property.displayName);
			}
		}
		public override void OnGUI( MaterialEditor materialEditor, MaterialProperty[] properties)
		{
			var materialProperties = new List<MaterialProperty>();
			MaterialProperty property;
			int indentCount = 0;
			
			if( renderingStatus == null)
			{
				renderingStatus = new RenderingStatus();
			}
			if( blendStatus == null)
			{
				blendStatus = new BlendStatus();
			}
			if( blendStatusForwardBase == null)
			{
				blendStatusForwardBase = new BlendStatus();
			}
			if( blendStatusForwardAdd == null)
			{
				blendStatusForwardAdd = new BlendStatus();
			}
			if( depthStencilStatus == null)
			{
				depthStencilStatus = new DepthStencilStatus();
			}
			
			renderingStatus.ClearProperty();
			blendStatus.ClearProperty();
			blendStatusForwardBase.ClearProperty();
			blendStatusForwardAdd.ClearProperty();
			depthStencilStatus.ClearProperty();
			
			for( int i0 = 0; i0 < properties.Length; ++i0)
			{
				property = properties[ i0];
				
				if( renderingStatus.SetProperty( property) != false)
				{
					continue;
				}
				if( blendStatus.SetProperty( property) != false)
				{
					continue;
				}
				if( blendStatusForwardBase.SetPropertyForwardBase( property) != false)
				{
					continue;
				}
				if( blendStatusForwardAdd.SetPropertyForwardAdd( property) != false)
				{
					continue;
				}
				if( depthStencilStatus.SetProperty( property) != false)
				{
					continue;
				}
				if( (property.flags & (MaterialProperty.PropFlags.HideInInspector | MaterialProperty.PropFlags.PerRendererData)) == 0)
				{
					materialProperties.Add( property);
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
			OnPropertiesGUI( materialEditor, materialProperties);
			
			if( indentCount > 0)
			{
				EditorGUI.indentLevel -= indentCount;
				indentCount = 0;
			}
			CaptionDecorator.OnBeforeGUI = null;
            CaptionDecorator.OnAfterGUI = null;
			CaptionDecorator.enabled = false;
			
			if( renderingStatus.ValidGUI() != false
			||	blendStatus.ValidGUI() != false
			||	blendStatusForwardBase.ValidGUI() != false
			||	blendStatusForwardAdd.ValidGUI() != false
			||	depthStencilStatus.ValidGUI() != false)
			{
				EditorGUILayout.Space();
				GUILayout.Box( string.Empty, GUILayout.ExpandWidth( true), GUILayout.Height( 1));
				renderingStatus.OnGUI( "Rendering Status", materialEditor, Foldout);
				blendStatus.OnGUI( "Blending Status", materialEditor, Foldout);
				blendStatusForwardBase.OnGUI( "Forward Base Blending Status", materialEditor, Foldout);
				blendStatusForwardAdd.OnGUI( "Forward Add Blending Status", materialEditor, Foldout);
				depthStencilStatus.OnGUI( "Depth Stencil Status", materialEditor, Foldout);
				GUILayout.Box( string.Empty, GUILayout.ExpandWidth( true), GUILayout.Height( 1));
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
        protected static bool Foldout( bool display, bool toggle, string caption)
        {
			if( foldoutStyle == null)
			{
	            foldoutStyle = new GUIStyle( "ShurikenModuleTitle");
	            foldoutStyle.font = new GUIStyle( EditorStyles.boldLabel).font;
	            foldoutStyle.fontStyle = FontStyle.Bold;
	            foldoutStyle.fixedHeight = 22;
	            foldoutStyle.border = new RectOffset( 15, 7, 4, 4);
	            foldoutStyle.contentOffset = new Vector2( 20, -2);
	        }
            var rect = GUILayoutUtility.GetRect( 16f, 22f, foldoutStyle);
            GUI.Box( rect, caption, foldoutStyle);

            var e = Event.current;

            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if( e.type == EventType.Repaint)
            {
				GUIStyle style = (toggle == false)?
					EditorStyles.foldout : EditorStyles.toggle;
                style.Draw(　toggleRect, false, false, display, false);
            }
            if( e.type == EventType.MouseDown && rect.Contains( e.mousePosition) != false)
            {
                display = !display;
                e.Use();
            }
            return display;
        }	
        
        static GUIStyle foldoutStyle = null;
		RenderingStatus renderingStatus = null;
		BlendStatus blendStatus = null;
		BlendStatus blendStatusForwardBase = null;
		BlendStatus blendStatusForwardAdd = null;
		DepthStencilStatus depthStencilStatus = null;
	}
	class RenderingStatus
	{
		internal void ClearProperty()
		{
			cullProp = null;
			zWriteProp = null;
			zWriteBaseProp = null;
			zWriteAddProp = null;
			zTestProp = null;
			zTestBaseProp = null;
			zTestAddProp = null;
			colorMaskProp = null;
			alphaClipProp = null;
			alphaClipThresholdProp = null;
			ditheringProp = null;
		}
		internal bool SetProperty( MaterialProperty property)
		{
			switch( property.name)
			{
				case kCull:
				{
					cullProp = property;
					return true;
				}
				case kZWrite:
				{
					zWriteProp = property;
					return true;
				}
				case kZWriteB:
				{
					zWriteBaseProp = property;
					return true;
				}
				case kZWriteA:
				{
					zWriteAddProp = property;
					return true;
				}
				case kZTest:
				{
					zTestProp = property;
					return true;
				}
				case kZTestB:
				{
					zTestBaseProp = property;
					return true;
				}
				case kZTestA:
				{
					zTestAddProp = property;
					return true;
				}
				case kColorMask:
				{
					colorMaskProp = property;
					return true;
				}
				case kAlphaClip:
				{
					alphaClipProp = property;
					return true;
				}
				case kAlphaClipThreshold:
				{
					alphaClipThresholdProp = property;
					return true;
				}
				case kDithering:
				{
					ditheringProp = property;
					return true;
				}
			}
			return false;
		}
		internal bool ValidGUI()
		{
			if( cullProp == null
			||	(zWriteProp == null && zWriteBaseProp == null && zWriteAddProp == null)
			||	(zTestProp == null && zTestBaseProp == null && zTestAddProp == null)
			||	colorMaskProp == null)
			{
				return false;
			}
			return true;
		}
		internal void OnGUI( string caption, MaterialEditor materialEditor, System.Func<bool, bool, string, bool> Foldout)
		{
			if( ValidGUI() == false)
			{
				return;
			}
			foldoutFlag = Foldout( foldoutFlag, false, caption);
			
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
				if( zWriteBaseProp != null)
				{
					materialEditor.ShaderProperty( zWriteBaseProp, zWriteBaseProp.displayName);
				}
				if( zTestBaseProp != null)
				{
					materialEditor.ShaderProperty( zTestBaseProp, zTestBaseProp.displayName);
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
		
		const string kCull = "_RS_Cull";
		const string kZWrite = "_RS_ZWrite";
		const string kZWriteB = "_RS_FB_ZWrite";
		const string kZWriteA = "_RS_FA_ZWrite";
		const string kZTest = "_RS_ZTest";
		const string kZTestB = "_RS_FB_ZTest";
		const string kZTestA = "_RS_FA_ZTest";
		const string kColorMask = "_RS_ColorMask";
		const string kAlphaClip = "_ALPHACLIP";
		const string kAlphaClipThreshold = "_AlphaClipThreshold";
		const string kDithering = "_DITHERING";
		
		static bool foldoutFlag = false;
		
		internal MaterialProperty cullProp = null;
		internal MaterialProperty zWriteProp = null;
		internal MaterialProperty zWriteBaseProp = null;
		internal MaterialProperty zWriteAddProp = null;
		internal MaterialProperty zTestProp = null;
		internal MaterialProperty zTestBaseProp = null;
		internal MaterialProperty zTestAddProp = null;
		internal MaterialProperty colorMaskProp = null;
		internal MaterialProperty alphaClipProp = null;
		internal MaterialProperty alphaClipThresholdProp = null;
		internal MaterialProperty ditheringProp = null;
	}
	class BlendStatus
	{
		internal void ClearProperty()
		{
			colorBlendOpProp = null;
			colorSrcFactorProp = null;
			colorDstFactorProp = null;
			alphaBlendOpProp = null;
			alphaSrcFactorProp = null;
			alphaDstFactorProp = null;
			colorBlendFactorValueProp = null;
			colorBlendFactorEnabledProp = null;
		}
		internal bool SetProperty( MaterialProperty property)
		{
			switch( property.name)
			{
				case kColorBlendOp:
				{
					colorBlendOpProp = property;
					return true;
				}
				case kColorSrcFactor:
				{
					colorSrcFactorProp = property;
					return true;
				}
				case kColorDstFactor:
				{
					colorDstFactorProp = property;
					return true;
				}
				case kAlphaBlendOp:
				{
					alphaBlendOpProp = property;
					return true;
				}
				case kAlphaSrcFactor:
				{
					alphaSrcFactorProp = property;
					return true;
				}
				case kAlphaDstFactor:
				{
					alphaDstFactorProp = property;
					return true;
				}
				case kColorBlendFactorValue:
				{
					colorBlendFactorValueProp = property;
					return true;
				}
				case kColorBlendFactorEnabled:
				{
					colorBlendFactorEnabledProp = property;
					return true;
				}
			}
			return false;
		}
		internal bool SetPropertyForwardBase( MaterialProperty property)
		{
			switch( property.name)
			{
				case kColorBlendOpB:
				{
					colorBlendOpProp = property;
					return true;
				}
				case kColorSrcFactorB:
				{
					colorSrcFactorProp = property;
					return true;
				}
				case kColorDstFactorB:
				{
					colorDstFactorProp = property;
					return true;
				}
				case kAlphaBlendOpB:
				{
					alphaBlendOpProp = property;
					return true;
				}
				case kAlphaSrcFactorB:
				{
					alphaSrcFactorProp = property;
					return true;
				}
				case kAlphaDstFactorB:
				{
					alphaDstFactorProp = property;
					return true;
				}
				case kColorBlendFactorValueB:
				{
					colorBlendFactorValueProp = property;
					return true;
				}
				case kColorBlendFactorEnabledB:
				{
					colorBlendFactorEnabledProp = property;
					return true;
				}
			}
			return false;
		}
		internal bool SetPropertyForwardAdd( MaterialProperty property)
		{
			switch( property.name)
			{
				case kColorBlendOpA:
				{
					colorBlendOpProp = property;
					return true;
				}
				case kColorSrcFactorA:
				{
					colorSrcFactorProp = property;
					return true;
				}
				case kColorDstFactorA:
				{
					colorDstFactorProp = property;
					return true;
				}
				case kAlphaBlendOpA:
				{
					alphaBlendOpProp = property;
					return true;
				}
				case kAlphaSrcFactorA:
				{
					alphaSrcFactorProp = property;
					return true;
				}
				case kAlphaDstFactorA:
				{
					alphaDstFactorProp = property;
					return true;
				}
				case kColorBlendFactorValueA:
				{
					colorBlendFactorValueProp = property;
					return true;
				}
				case kColorBlendFactorEnabledA:
				{
					colorBlendFactorEnabledProp = property;
					return true;
				}
			}
			return false;
		}
		internal bool ValidGUI()
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
		internal void OnGUI( string caption, MaterialEditor materialEditor, System.Func<bool, bool, string, bool> Foldout)
		{
			if( ValidGUI() == false)
			{
				return;
			}
			foldoutFlag = Foldout( foldoutFlag, false, caption);
			
			if( foldoutFlag != false)
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
								colorBlendOpProp, 
								colorSrcFactorProp, 
								colorDstFactorProp, 
								colorBlendFactorEnabledProp, 
								colorBlendFactorValueProp);
						}
					}
				}
				EditorGUILayout.BeginVertical( EditorStyles.inspectorDefaultMargins);
				{
					if( colorBlendFactorValueProp != null && colorBlendFactorEnabledProp != null)
					{
						materialEditor.ShaderProperty( colorBlendOpProp, "├─ " + colorBlendOpProp.displayName);
						materialEditor.ShaderProperty( colorSrcFactorProp, "├─ " + colorSrcFactorProp.displayName);
						materialEditor.ShaderProperty( colorDstFactorProp, "├─ " + colorDstFactorProp.displayName);
						materialEditor.ShaderProperty( colorBlendFactorValueProp, "├─ " + colorBlendFactorValueProp.displayName);
						materialEditor.ShaderProperty( colorBlendFactorEnabledProp, "└─ " + colorBlendFactorEnabledProp.displayName);
					}
					else
					{
						materialEditor.ShaderProperty( colorBlendOpProp, "├─ " + colorBlendOpProp.displayName);
						materialEditor.ShaderProperty( colorSrcFactorProp, "├─ " + colorSrcFactorProp.displayName);
						materialEditor.ShaderProperty( colorDstFactorProp, "└─ " + colorDstFactorProp.displayName);
					}
					string formula;
					
					if( TryGetBlendFormula( 
						(BlendOp)colorBlendOpProp.floatValue,
						(BlendMode)colorSrcFactorProp.floatValue,
						(BlendMode)colorDstFactorProp.floatValue,
						"rgb", out formula) != false)
					{
						if( colorBlendFactorEnabledProp.floatValue != 0.0f)
						{
							formula = "src.rgb = src.rgb * src.a + BlendFacter.rgb * (1.0 - src.a);\n" + formula;
						}
						EditorGUILayout.LabelField( new GUIContent( formula), EditorStyles.helpBox);
					}
					if( colorBlendFactorEnabledProp.floatValue != 0.0f)
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
					alphaBlendOpProp.floatValue,
					alphaSrcFactorProp.floatValue,
					alphaDstFactorProp.floatValue);
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
								alphaBlendOpProp, 
								alphaSrcFactorProp, 
								alphaDstFactorProp);
						}
					}
				}
				EditorGUILayout.BeginVertical( EditorStyles.inspectorDefaultMargins);
				{
					materialEditor.ShaderProperty( alphaBlendOpProp, "├─ " + alphaBlendOpProp.displayName);
					materialEditor.ShaderProperty( alphaSrcFactorProp, "├─ " + alphaSrcFactorProp.displayName);
					materialEditor.ShaderProperty( alphaDstFactorProp, "└─ " + alphaDstFactorProp.displayName);
					
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
		const string kColorBlendOp = "_RS_ColorBlendOp";
		const string kColorSrcFactor = "_RS_ColorSrcFactor";
		const string kColorDstFactor = "_RS_ColorDstFactor";
		const string kAlphaBlendOp = "_RS_AlphaBlendOp";
		const string kAlphaSrcFactor = "_RS_AlphaSrcFactor";
		const string kAlphaDstFactor = "_RS_AlphaDstFactor";
		const string kColorBlendFactorValue = "_RS_BlendFactor";
		const string kColorBlendFactorEnabled = "_BLENDFACTOR";
		
		const string kColorBlendOpB = "_RS_FB_ColorBlendOp";
		const string kColorSrcFactorB = "_RS_FB_ColorSrcFactor";
		const string kColorDstFactorB = "_RS_FB_ColorDstFactor";
		const string kAlphaBlendOpB = "_RS_FB_AlphaBlendOp";
		const string kAlphaSrcFactorB = "_RS_FB_AlphaSrcFactor";
		const string kAlphaDstFactorB = "_RS_FB_AlphaDstFactor";
		const string kColorBlendFactorValueB = "_RS_FB_BlendFactor";
		const string kColorBlendFactorEnabledB = "_FB_BLENDFACTOR";
		
		const string kColorBlendOpA = "_RS_FA_ColorBlendOp";
		const string kColorSrcFactorA = "_RS_FA_ColorSrcFactor";
		const string kColorDstFactorA = "_RS_FA_ColorDstFactor";
		const string kAlphaBlendOpA = "_RS_FA_AlphaBlendOp";
		const string kAlphaSrcFactorA = "_RS_FA_AlphaSrcFactor";
		const string kAlphaDstFactorA = "_RS_FA_AlphaDstFactor";
		const string kColorBlendFactorValueA = "_RS_FA_BlendFactor";
		const string kColorBlendFactorEnabledA = "_FA_BLENDFACTOR";
		
		static bool foldoutFlag = false;
		
		internal MaterialProperty colorBlendOpProp = null;
		internal MaterialProperty colorSrcFactorProp = null;
		internal MaterialProperty colorDstFactorProp = null;
		internal MaterialProperty alphaBlendOpProp = null;
		internal MaterialProperty alphaSrcFactorProp = null;
		internal MaterialProperty alphaDstFactorProp = null;
		internal MaterialProperty colorBlendFactorValueProp = null;
		internal MaterialProperty colorBlendFactorEnabledProp = null;
	}
	class DepthStencilStatus
	{
		internal void ClearProperty()
		{
			stencilRefProp = null;
			stencilReadMaskProp = null;
			stencilWriteMaskProp = null;
			stencilCompProp = null;
			stencilPassProp = null;
			stencilFailProp = null;
			stencilZFailProp = null;
		}
		internal bool SetProperty( MaterialProperty property)
		{
			switch( property.name)
			{
				case stencilRef:
				{
					stencilRefProp = property;
					return true;
				}
				case stencilReadMask:
				{
					stencilReadMaskProp = property;
					return true;
				}
				case stencilWriteMask:
				{
					stencilWriteMaskProp = property;
					return true;
				}
				case stencilComp:
				{
					stencilCompProp = property;
					return true;
				}
				case stencilPass:
				{
					stencilPassProp = property;
					return true;
				}
				case stencilFail:
				{
					stencilFailProp = property;
					return true;
				}
				case stencilZFail:
				{
					stencilZFailProp = property;
					return true;
				}
			}
			return false;
		}
		internal bool ValidGUI()
		{
			if( stencilRefProp == null
			||	stencilReadMaskProp == null
			||	stencilWriteMaskProp == null
			||	stencilCompProp == null
			||	stencilPassProp == null
			||	stencilFailProp == null
			||	stencilZFailProp == null)
			{
				return false;
			}
			return true;
		}
		internal void OnGUI( string caption, MaterialEditor materialEditor, System.Func<bool, bool, string, bool> Foldout)
		{
			if( ValidGUI() == false)
			{
				return;
			}
			foldoutFlag = Foldout( foldoutFlag, false, caption);
			
			if( foldoutFlag != false)
			{
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
		}
		const string stencilRef = "_StencilRef";
		const string stencilReadMask = "_StencilReadMask";
		const string stencilWriteMask = "_StencilWriteMask";
		const string stencilComp = "_StencilComp";
		const string stencilPass = "_StencilPass";
		const string stencilFail = "_StencilFail";
		const string stencilZFail = "_StencilZFail";
		
		static bool foldoutFlag = false;
		
		MaterialProperty stencilRefProp = null;
		MaterialProperty stencilReadMaskProp = null;
		MaterialProperty stencilWriteMaskProp = null;
		MaterialProperty stencilCompProp = null;
		MaterialProperty stencilPassProp = null;
		MaterialProperty stencilFailProp = null;
		MaterialProperty stencilZFailProp = null;
	}
}
