
using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

class ZanLibShaderInspector
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
	public enum BlendAlphaPreset
	{
		None,
		SrcAlphaBlend,
		DstAlphaBlend,
		Other
	}
	public static BlendColorPreset GetBlendColorPreset( BlendOp op, BlendMode src, BlendMode dst, float _fBlendFactor, Color rsBlendFactor)
	{
		var ret = BlendColorPreset.Other;
		
		switch( op)
		{
			case BlendOp.Add:
			{
				if( src == BlendMode.One && dst == BlendMode.Zero && 
						_fBlendFactor == 0.0f && rsBlendFactor == Color.clear)
				{
					ret = BlendColorPreset.None;
				}
				else if( src == BlendMode.SrcAlpha && dst == BlendMode.OneMinusSrcAlpha && 
						_fBlendFactor == 0.0f && rsBlendFactor == Color.clear)
				{
					ret = BlendColorPreset.SrcAlphaBlend;
				}
				else if( src == BlendMode.DstAlpha && dst == BlendMode.OneMinusDstAlpha && 
						_fBlendFactor == 0.0f && rsBlendFactor == Color.clear)
				{
					ret = BlendColorPreset.DstAlphaBlend;
				}
				else if( src == BlendMode.SrcAlpha && dst == BlendMode.One && 
						_fBlendFactor == 0.0f && rsBlendFactor == Color.clear)
				{
					ret = BlendColorPreset.Add;
				}
				else if( src == BlendMode.Zero && dst == BlendMode.SrcColor && 
						_fBlendFactor == 1.0f && rsBlendFactor == Color.white)
				{
					ret = BlendColorPreset.Multiply;
				}
				else if( src == BlendMode.OneMinusDstColor && dst == BlendMode.One && 
						_fBlendFactor == 1.0f && rsBlendFactor == Color.black)
				{
					ret = BlendColorPreset.Screen;
				}
				else if( src == BlendMode.OneMinusDstColor && dst == BlendMode.OneMinusSrcColor && 
						_fBlendFactor == 1.0f && rsBlendFactor == Color.black)
				{
					ret = BlendColorPreset.Exclude;
				}
				else if( src == BlendMode.DstColor && dst == BlendMode.One && 
						_fBlendFactor == 1.0f && rsBlendFactor == Color.black)
				{
					ret = BlendColorPreset.ColorDouble;
				}
				else if( src == BlendMode.DstColor && dst == BlendMode.SrcColor && 
						_fBlendFactor == 1.0f && rsBlendFactor == Color.gray)
				{
					ret = BlendColorPreset.MultiplyDouble;
				}
				break;
			}
			case BlendOp.ReverseSubtract:
			{
				if( src == BlendMode.SrcAlpha && dst == BlendMode.One)
				{
					ret = BlendColorPreset.Subtract;
				}
				break;
			}
			case BlendOp.Max:
			{
				if( src == BlendMode.One && dst == BlendMode.One && 
					_fBlendFactor == 1.0f && rsBlendFactor == Color.black)
				{
					ret = BlendColorPreset.CompareBright;
				}
				break;
			}
			case BlendOp.Min:
			{
				if( src == BlendMode.One && dst == BlendMode.One && 
					_fBlendFactor == 1.0f && rsBlendFactor == Color.white)
				{
					ret = BlendColorPreset.CompareDark;
				}
				break;
			}
		}
		return ret;
	}
	public static void SetBlendColorPreset( Material material, int rsBlendOp, int rsSrcFactor, int rsDstFactor, int _fBlendFactor, int rsBlendFactor, BlendColorPreset preset)
	{
		switch( preset)
		{
			case BlendColorPreset.None:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.One);
				material.SetFloat( rsDstFactor, (float)BlendMode.Zero);
				material.SetFloat( _fBlendFactor, 0.0f);
				material.SetColor( rsBlendFactor, Color.clear);
				break;
			}
			case BlendColorPreset.SrcAlphaBlend:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.SrcAlpha);
				material.SetFloat( rsDstFactor, (float)BlendMode.OneMinusSrcAlpha);
				material.SetFloat( _fBlendFactor, 0.0f);
				material.SetColor( rsBlendFactor, Color.clear);
				break;
			}
			case BlendColorPreset.DstAlphaBlend:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.DstAlpha);
				material.SetFloat( rsDstFactor, (float)BlendMode.OneMinusDstAlpha);
				material.SetFloat( _fBlendFactor, 0.0f);
				material.SetColor( rsBlendFactor, Color.clear);
				break;
			}
			case BlendColorPreset.Add:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.SrcAlpha);
				material.SetFloat( rsDstFactor, (float)BlendMode.One);
				material.SetFloat( _fBlendFactor, 0.0f);
				material.SetColor( rsBlendFactor, Color.clear);
				break;
			}
			case BlendColorPreset.Subtract:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.ReverseSubtract);
				material.SetFloat( rsSrcFactor, (float)BlendMode.SrcAlpha);
				material.SetFloat( rsDstFactor, (float)BlendMode.One);
				material.SetFloat( _fBlendFactor, 0.0f);
				material.SetColor( rsBlendFactor, Color.clear);
				break;
			}
			case BlendColorPreset.Multiply:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.Zero);
				material.SetFloat( rsDstFactor, (float)BlendMode.SrcColor);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.white);
				break;
			}
			case BlendColorPreset.Screen:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.OneMinusDstColor);
				material.SetFloat( rsDstFactor, (float)BlendMode.One);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.black);
				break;
			}
			case BlendColorPreset.Exclude:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.OneMinusDstColor);
				material.SetFloat( rsDstFactor, (float)BlendMode.OneMinusSrcColor);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.black);
				break;
			}
			case BlendColorPreset.CompareBright:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Max);
				material.SetFloat( rsSrcFactor, (float)BlendMode.One);
				material.SetFloat( rsDstFactor, (float)BlendMode.One);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.black);
				break;
			}
			case BlendColorPreset.CompareDark:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Min);
				material.SetFloat( rsSrcFactor, (float)BlendMode.One);
				material.SetFloat( rsDstFactor, (float)BlendMode.One);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.white);
				break;
			}
			case BlendColorPreset.ColorDouble:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.DstColor);
				material.SetFloat( rsDstFactor, (float)BlendMode.One);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.black);
				break;
			}
			case BlendColorPreset.MultiplyDouble:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.DstColor);
				material.SetFloat( rsDstFactor, (float)BlendMode.SrcColor);
				material.SetFloat( _fBlendFactor, 1.0f);
				material.SetColor( rsBlendFactor, Color.gray);
				break;
			}
		}
	}
	public static BlendAlphaPreset GetBlendAlphaPreset( BlendOp op, BlendMode src, BlendMode dst)
	{
		var ret = BlendAlphaPreset.Other;
		
		switch( op)
		{
			case BlendOp.Add:
			{
				if( src == BlendMode.One && dst == BlendMode.Zero)
				{
					ret = BlendAlphaPreset.None;
				}
				else if( src == BlendMode.SrcAlpha && dst == BlendMode.OneMinusSrcAlpha)
				{
					ret = BlendAlphaPreset.SrcAlphaBlend;
				}
				else if( src == BlendMode.DstAlpha && dst == BlendMode.OneMinusDstAlpha)
				{
					ret = BlendAlphaPreset.DstAlphaBlend;
				}
				break;
			}
		}
		return ret;
	}
	public static void SetBlendAlphaPreset( Material material, int rsBlendOp, int rsSrcFactor, int rsDstFactor, BlendAlphaPreset preset)
	{
		switch( preset)
		{
			case BlendAlphaPreset.None:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.One);
				material.SetFloat( rsDstFactor, (float)BlendMode.Zero);
				break;
			}
			case BlendAlphaPreset.SrcAlphaBlend:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.SrcAlpha);
				material.SetFloat( rsDstFactor, (float)BlendMode.OneMinusSrcAlpha);
				break;
			}
			case BlendAlphaPreset.DstAlphaBlend:
			{
				material.SetFloat( rsBlendOp, (float)BlendOp.Add);
				material.SetFloat( rsSrcFactor, (float)BlendMode.DstAlpha);
				material.SetFloat( rsDstFactor, (float)BlendMode.OneMinusDstAlpha);
				break;
			}
		}
	}
}
