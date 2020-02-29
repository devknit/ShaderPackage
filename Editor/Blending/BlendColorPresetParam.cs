
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ZanShader
{
	public enum BlendColorPreset
	{
		None,
		SrcAlphaBlend,
		DstAlphaBlend,
		Add,
		Subtract,
		Multiply,
		Screen,
		Exclude,
		CompareBright,
		CompareDark,
		ColorDouble,
		MultiplyDouble,
		Other
	}
	class BlendColorPresetParam : BlendAlphaPresetParam
	{
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
		}
		protected bool Equals( float blendOp, float srcFactor, float dstFactor, float blendFactorFlag, Color blendFactorColor)
		{
			return Equals( blendOp, srcFactor, dstFactor) != false && _fBlendFactor == blendFactorFlag && rsBlendFactor == blendFactorColor;
		}
		public float _fBlendFactor;
		public Color rsBlendFactor;
		
		static readonly BlendColorPresetParam[] kBlendColorPresetParams = new BlendColorPresetParam[]
		{
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.One,
				(float)BlendMode.Zero,
				0.0f,
				Color.clear),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.OneMinusSrcAlpha,
				0.0f,
				Color.clear),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstAlpha,
				(float)BlendMode.OneMinusDstAlpha,
				0.0f,
				Color.clear),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.One,
				0.0f,
				Color.clear),
			new BlendColorPresetParam(
				(float)BlendOp.ReverseSubtract,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.One,
				0.0f,
				Color.clear),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.Zero,
				(float)BlendMode.SrcColor,
				1.0f,
				Color.white),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.OneMinusDstColor,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.OneMinusDstColor,
				(float)BlendMode.OneMinusSrcColor,
				1.0f,
				Color.black),
			new BlendColorPresetParam(
				(float)BlendOp.Max,
				(float)BlendMode.One,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			new BlendColorPresetParam(
				(float)BlendOp.Min,
				(float)BlendMode.One,
				(float)BlendMode.One,
				1.0f,
				Color.white),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstColor,
				(float)BlendMode.One,
				1.0f,
				Color.black),
			new BlendColorPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstColor,
				(float)BlendMode.SrcColor,
				1.0f,
				Color.gray)
		};
	}
}
