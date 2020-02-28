
using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

class ZanLibShaderBlends : MaterialEditor
{
	public override void OnInspectorGUI() 
	{
		OnGUI();
		base.OnInspectorGUI();
	}
	void OnGUI()
	{
		if( isVisible == false)
		{
			return;
		}
		
		int _fColorBlendFactor = Shader.PropertyToID( "_BLENDFACTOR");
		int rsColorBlendFactor = Shader.PropertyToID( "_RS_BlendFactor");
		int rsColorBlendOp = Shader.PropertyToID( "_RS_ColorBlendOp");
		int rsColorSrcFactor = Shader.PropertyToID( "_RS_ColorSrcFactor");
		int rsColorDstFactor = Shader.PropertyToID( "_RS_ColorDstFactor");
		int rsAlphaBlendOp = Shader.PropertyToID( "_RS_AlphaBlendOp");
		int rsAlphaSrcFactor = Shader.PropertyToID( "_RS_AlphaSrcFactor");
		int rsAlphaDstFactor = Shader.PropertyToID( "_RS_AlphaDstFactor");
		var material = target as Material;
		
		if( material.HasProperty( _fColorBlendFactor) == false
		||	material.HasProperty( rsColorBlendFactor) == false
		||	material.HasProperty( rsColorBlendOp) == false
		||	material.HasProperty( rsColorSrcFactor) == false
		||	material.HasProperty( rsColorDstFactor) == false
		||	material.HasProperty( rsAlphaBlendOp) == false
		||	material.HasProperty( rsAlphaSrcFactor) == false
		||	material.HasProperty( rsAlphaDstFactor) == false)
		{
			return;
		}
		
		EditorGUILayout.BeginVertical( GUI.skin.box);
		EditorGUILayout.LabelField( "Blending Presets", EditorStyles.boldLabel);
		
		EditorGUI.BeginChangeCheck();
		var prevColor = ZanLibShaderInspector.GetBlendColorPreset( 
			(BlendOp)material.GetFloat( rsColorBlendOp),
			(BlendMode)material.GetFloat( rsColorSrcFactor),
			(BlendMode)material.GetFloat( rsColorDstFactor), 
			material.GetFloat( _fColorBlendFactor), 
			material.GetColor( rsColorBlendFactor));
		var nextColor = (ZanLibShaderInspector.BlendColorPreset)EditorGUILayout.EnumPopup( "Color Channel Blending", prevColor);
		
		if( EditorGUI.EndChangeCheck() != false)
		{
			if( nextColor != prevColor)
			{
				ZanLibShaderInspector.SetBlendColorPreset( material, rsColorBlendOp, rsColorSrcFactor, 
					rsColorDstFactor, _fColorBlendFactor, rsColorBlendFactor, nextColor);
			}
		}
		
		EditorGUI.BeginChangeCheck();
		var prevAlpha = ZanLibShaderInspector.GetBlendAlphaPreset( 
			(BlendOp)material.GetFloat( rsAlphaBlendOp),
			(BlendMode)material.GetFloat( rsAlphaSrcFactor),
			(BlendMode)material.GetFloat( rsAlphaDstFactor));
		var nextAlpha = (ZanLibShaderInspector.BlendAlphaPreset)EditorGUILayout.EnumPopup( "Alpha Channel Blending", prevAlpha);
		
		if( EditorGUI.EndChangeCheck() != false)
		{
			if( nextAlpha != prevAlpha)
			{
				ZanLibShaderInspector.SetBlendAlphaPreset( material, rsAlphaBlendOp, rsAlphaSrcFactor, rsAlphaDstFactor, nextAlpha);
			}
		}
		EditorGUILayout.EndVertical();
	}
}
