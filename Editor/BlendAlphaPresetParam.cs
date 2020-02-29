
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ZanShader
{
	public enum BlendAlphaPreset
	{
		None,
		SrcAlphaBlend,
		DstAlphaBlend,
		Other
	}
	class BlendAlphaPresetParam
	{
		public static BlendAlphaPreset GetPreset( float blendOp, float srcFactor, float dstFactor)
		{
			for( int i0 = 0; i0 < kBlendAlphaPresetParams.Length; ++i0)
			{
				if( kBlendAlphaPresetParams[ i0].Equals( blendOp, srcFactor, dstFactor) != false)
				{
					return (BlendAlphaPreset)i0;
				}
			}
			return BlendAlphaPreset.Other;
		}
		public static bool TryGetPresetParam( BlendAlphaPreset preset, out BlendAlphaPresetParam param)
		{
			try
			{
				param = kBlendAlphaPresetParams[ (int)preset];
			}
			catch
			{
				param = null;
			}
			return param != null;
		}
		public BlendAlphaPresetParam( float blendOp, float srcFactor, float dstFactor)
		{
			rsBlendOp = blendOp;
			rsSrcFactor = srcFactor;
			rsDstFactor = dstFactor;
		}
		public void SetMaterialProperty(
			MaterialProperty rsBlendOpProp, 
			MaterialProperty rsSrcFactorProp,
			MaterialProperty rsDstFactorProp)
		{
			rsBlendOpProp.floatValue = rsBlendOp;
			rsSrcFactorProp.floatValue = rsSrcFactor;
			rsDstFactorProp.floatValue = rsDstFactor;
		}
		protected bool Equals( float blendOp, float srcFactor, float dstFactor)
		{
			return rsBlendOp == blendOp && rsSrcFactor == srcFactor && rsDstFactor == dstFactor;
		}
		public float rsBlendOp;
		public float rsSrcFactor;
		public float rsDstFactor;
		
		static readonly BlendAlphaPresetParam[] kBlendAlphaPresetParams = new BlendAlphaPresetParam[]
		{
			new BlendAlphaPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.One,
				(float)BlendMode.Zero),
			new BlendAlphaPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.SrcAlpha,
				(float)BlendMode.OneMinusSrcAlpha),
			new BlendAlphaPresetParam(
				(float)BlendOp.Add,
				(float)BlendMode.DstAlpha,
				(float)BlendMode.OneMinusDstAlpha)
		};
	}
}
