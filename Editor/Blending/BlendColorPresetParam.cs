//#define WITH_EXPERIMENT

using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ZanShader.Editor
{
	internal enum BlendColorPreset
	{
		None,
		SrcAlphaBlend,
		DstAlphaBlend,
		Add,
		AddAlpha,
		AddPreAlpha,
		Subtract,
		SubtractAlpha,
		SubtractPreAlpha,
		Multiply,
		MultipliedPreAlpha,
		Screen,
		ScreenPreAlpha,
		Exclude,
		ExcludePreAlpha,
		Lighten,
		LightenPreAlpha,
		Darken,
		DarkenPreAlpha,
	#if WITH_EXPERIMENT
		ColorDouble,
		MultiplyDouble,
	#endif
		Other
	}
	internal class BlendColorPresetParam : BlendAlphaPresetParam
	{
		public static string[] kBlendColorPresetNames = new string[]
		{
			"ëOåiÇè„èëÇ´",
			"ëOåiÇÃÉAÉãÉtÉ@Ç≈çáê¨",
			"îwåiÇÃÉAÉãÉtÉ@Ç≈çáê¨",
			"â¡éZçáê¨",
			"â¡éZìßâﬂçáê¨",
			"â¡éZéñëOìßâﬂçáê¨",
			"å∏éZçáê¨",
			"å∏éZìßâﬂçáê¨",
			"å∏éZéñëOìßâﬂçáê¨",
			"èÊéZçáê¨",
			"èÊéZéñëOìßâﬂçáê¨",
			"ÉXÉNÉäÅ[Éìçáê¨",
			"ÉXÉNÉäÅ[ÉìéñëOìßâﬂçáê¨",
			"èúäOçáê¨",
			"èúäOéñëOìßâﬂçáê¨",
			"î‰är(ñæ)çáê¨",
			"î‰är(ñæ)éñëOìßâﬂçáê¨",
			"î‰är(à√)çáê¨",
			"î‰är(à√)éñëOìßâﬂçáê¨",
		#if WITH_EXPERIMENT
			"ÉJÉâÅ[2î{",
			"èÊéZ2î{",
		#endif
			"ÇªÇÃëº"
		};
		public static BlendColorPreset GetPreset( float blendOp, float srcFactor, float dstFactor, float blendFactorFlag, Color blendFactorColor)
		{
			for( int i0 = 0; i0 < kBlendColorPresetParams.Length; ++i0)
			{
				if( kBlendColorPresetParams[ i0].Equals( blendOp, srcFactor, dstFactor, blendFactorFlag, blendFactorColor) != false)
				{
					return (BlendColorPreset)i0;
				}
			}
			return BlendColorPreset.Other;
		}
		public static bool TryGetPresetParam( BlendColorPreset preset, out BlendColorPresetParam param)
		{
			try
			{
				param = kBlendColorPresetParams[ (int)preset];
			}
			catch
			{
				param = null;
			}
			return param != null;
		}
		public BlendColorPresetParam( float blendOp, float srcFactor, float dstFactor, float blendFactorFlag, Color blendFactorColor) : base( blendOp, srcFactor, dstFactor)
		{
			_fBlendFactor = blendFactorFlag;
			rsBlendFactor = blendFactorColor;
		}
		public void SetMaterialProperty(
			MaterialProperty rsBlendOpProp, 
			MaterialProperty rsSrcFactorProp,
			MaterialProperty rsDstFactorProp,
			MaterialProperty _fBlendFactorProp,
			MaterialProperty rsBlendFactorProp)
		{
			SetMaterialProperty( rsBlendOpProp, rsSrcFactorProp, rsDstFactorProp);
			_fBlendFactorProp.floatValue = _fBlendFactor;
			rsBlendFactorProp.colorValue = rsBlendFactor;
			
			string keyword = string.Format( $"{_fBlendFactorProp.name.ToUpperInvariant()}_ON");
			bool enabled = System.Math.Abs( _fBlendFactor) > 0.001f;
			
			foreach( Material material in _fBlendFactorProp.targets)
			{
				if( enabled != false)
				{
					material.EnableKeyword( keyword);
				}
				else
				{
					material.DisableKeyword( keyword);
				}
			}
			
		}
		protected bool Equals( float blendOp, float srcFactor, float dstFactor, float blendFactorFlag, Color blendFactorColor)
		{
			if( Equals( blendOp, srcFactor, dstFactor) != false && _fBlendFactor == blendFactorFlag)
			{
				return rsBlendFactor.r == blendFactorColor.r && rsBlendFactor.g == blendFactorColor.g && rsBlendFactor.b == blendFactorColor.b;
			}
			return false;
		}
		public float _fBlendFactor;
		public Color rsBlendFactor;
		
		static readonly BlendColorPresetParam[] kBlendColorPresetParams = new BlendColorPresetParam[]
		{
			/* None */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.One,
				(float)BlendMode.Zero,
				0.0f,
				Color.black),
			/* SrcAlphaBlend */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.OneMinusSrcAlpha,
				0.0f,
				Color.black),
			/* DstAlphaBlend */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstAlpha,
				(float)BlendMode.OneMinusDstAlpha,
				0.0f,
				Color.black),
			/* Add */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.One,
				(float)BlendMode.One,
				0.0f,
				Color.black),
			/* AddAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.One,
				0.0f,
				Color.black),
			/* AddPreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			/* Subtract */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.Zero,
				(float)BlendMode.OneMinusSrcColor,
				0.0f,
				Color.black),
			/* SubtractAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.ReverseSubtract,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.One,
				0.0f,
				Color.black),
			/* SubtractPreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.ReverseSubtract,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			/* Multiply */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.Zero,
				(float)BlendMode.SrcColor,
				0.0f,
				Color.black),
			/* MultipliedPreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.Zero,
				(float)BlendMode.SrcColor,
				1.0f,
				Color.white),
			/* Screen */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.OneMinusDstColor,
				(float)BlendMode.One,
				0.0f,
				Color.black),
			/* ScreenPreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.OneMinusDstColor,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			/* Exclude */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.OneMinusDstColor,
				(float)BlendMode.OneMinusSrcColor,
				0.0f,
				Color.black),
			/* ExcludePreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.OneMinusDstColor,
				(float)BlendMode.OneMinusSrcColor,
				1.0f,
				Color.black),
			/* Lighten */
			new BlendColorPresetParam(
				(float)BlendOp.Max,
				(float)BlendMode.One,
				(float)BlendMode.One,
				0.0f,
				Color.black),
			/* LightenPreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Max,
				(float)BlendMode.One,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			/* Darken */
			new BlendColorPresetParam(
				(float)BlendOp.Min,
				(float)BlendMode.One,
				(float)BlendMode.One,
				0.0f,
				Color.black),
			/* DarkenPreAlpha */
			new BlendColorPresetParam(
				(float)BlendOp.Min,
				(float)BlendMode.One,
				(float)BlendMode.One,
				1.0f,
				Color.white),
		#if WITH_EXPERIMENT
			/* ColorDouble */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstColor,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			/* MultiplyDouble */
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstColor,
				(float)BlendMode.SrcColor,
				1.0f,
				Color.gray),
		#endif
		};
	}
}
